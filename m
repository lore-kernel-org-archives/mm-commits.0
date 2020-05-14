From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/7] mm/gup: fix fixup_user_fault() on multiple
 retries
Date: Wed, 13 May 2020 17:50:41 -0700
Message-ID: <20200514005041.Biir9x7Bl%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 20:50:42 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, bgeffon@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com, torvalds@linux-foundation.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: fix fixup_user_fault() on multiple retries

This part is overlooked when reworking the gup code on multiple retries. 
When we get the 2nd+ retry, we'll be with TRIED flag set.  Current code
will bail out on the 2nd retry because the !TRIED check will fail so the
retry logic will be skipped.  What's worse is that, it will also return
zero which errornously hints the caller that the page is faulted in while
it's not.

The !TRIED flag check seems to not be needed even before the mutliple
retries change because if we get a VM_FAULT_RETRY, it must be the 1st
retry, and we should not have TRIED set for that.

Fix it by removing the !TRIED check, at the meantime check against fatal
signals properly before the page fault so we can still properly respond to
the user killing the process during retries.

Link: http://lkml.kernel.org/r/20200502003523.8204-1-peterx@redhat.com
Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-fix-fixup_user_fault-on-multiple-retries
+++ a/mm/gup.c
@@ -1218,6 +1218,10 @@ retry:
 	if (!vma_permits_fault(vma, fault_flags))
 		return -EFAULT;
 
+	if ((fault_flags & FAULT_FLAG_KILLABLE) &&
+	    fatal_signal_pending(current))
+		return -EINTR;
+
 	ret = handle_mm_fault(vma, address, fault_flags);
 	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
@@ -1230,11 +1234,9 @@ retry:
 
 	if (ret & VM_FAULT_RETRY) {
 		down_read(&mm->mmap_sem);
-		if (!(fault_flags & FAULT_FLAG_TRIED)) {
-			*unlocked = true;
-			fault_flags |= FAULT_FLAG_TRIED;
-			goto retry;
-		}
+		*unlocked = true;
+		fault_flags |= FAULT_FLAG_TRIED;
+		goto retry;
 	}
 
 	if (tsk) {
_

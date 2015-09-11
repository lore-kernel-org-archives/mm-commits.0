From: akpm@linux-foundation.org
Subject: [folded-merged] mm-mlock-add-new-mlock-system-call-v7.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 14:59:52 -0700
Message-ID: <55f34ed8.GMq8wLyEO1tslefn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbbIKV7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-new-mlock-system-call-v7
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-new-mlock-system-call-v7.patch

This patch was dropped because it was folded into mm-mlock-add-new-mlock-system-call.patch

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-mlock-add-new-mlock-system-call-v7

With the refactored mlock code, introduce a new system call for mlock. 
The new call will allow the user to specify what lock states are being
added.  mlock2 is trivial at the moment, but a follow on patch will add a
new mlock state making it useful.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-mlock-add-new-mlock-system-call-v7 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-new-mlock-system-call-v7
+++ a/mm/mlock.c
@@ -646,11 +646,10 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 {
-	vm_flags_t vm_flags = VM_LOCKED;
 	if (flags)
 		return -EINVAL;
 
-	return do_mlock(start, len, vm_flags);
+	return do_mlock(start, len, VM_LOCKED);
 }
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v7.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch


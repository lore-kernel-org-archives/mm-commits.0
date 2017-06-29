From: akpm@linux-foundation.org
Subject: + expand_downwards-dont-require-the-gap-if-vm_prev.patch added to -mm tree
Date: Thu, 29 Jun 2017 15:14:58 -0700
Message-ID: <59557be2.yR8B8SZgdiM5+87e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbdF2WO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, lwoodman@redhat.com, mhocko@suse.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: expand_downwards: don't require the gap if !vm_prev
has been added to the -mm tree.  Its filename is
     expand_downwards-dont-require-the-gap-if-vm_prev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/expand_downwards-dont-require-the-gap-if-vm_prev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/expand_downwards-dont-require-the-gap-if-vm_prev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/mmap.c: expand_downwards: don't require the gap if !vm_prev

expand_stack(vma) fails if address < stack_guard_gap even if there is no
vma->vm_prev.  I don't think this makes sense, and we didn't do this
before the recent commit 1be7107fbe18 ("mm: larger stack guard gap,
between vmas").  We do not need a gap in this case, any address is fine as
long as security_mmap_addr() doesn't object.

This also simplifies the code, we know that address >= prev->vm_end and
thus underflow is not possible.

Link: http://lkml.kernel.org/r/20170628175258.GA24881@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/mmap.c~expand_downwards-dont-require-the-gap-if-vm_prev mm/mmap.c
--- a/mm/mmap.c~expand_downwards-dont-require-the-gap-if-vm_prev
+++ a/mm/mmap.c
@@ -2315,7 +2315,6 @@ int expand_downwards(struct vm_area_stru
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	unsigned long gap_addr;
 	int error;
 
 	address &= PAGE_MASK;
@@ -2324,14 +2323,11 @@ int expand_downwards(struct vm_area_stru
 		return error;
 
 	/* Enforce stack_guard_gap */
-	gap_addr = address - stack_guard_gap;
-	if (gap_addr > address)
-		return -ENOMEM;
 	prev = vma->vm_prev;
-	if (prev && prev->vm_end > gap_addr) {
-		if (!(prev->vm_flags & VM_GROWSDOWN))
+	/* Check that both stack segments have the same anon_vma? */
+	if (prev && !(prev->vm_flags & VM_GROWSDOWN)) {
+		if (address - prev->vm_end < stack_guard_gap)
 			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
 	}
 
 	/* We must make sure the anon_vma is allocated. */
_

Patches currently in -mm which might be from oleg@redhat.com are

expand_downwards-dont-require-the-gap-if-vm_prev.patch


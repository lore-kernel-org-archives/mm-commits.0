From: akpm@linux-foundation.org
Subject: + lib-interval_tree-fast-overlap-detection-fix.patch added to -mm tree
Date: Tue, 08 Aug 2017 16:49:51 -0700
Message-ID: <598a4e1f.KXveZTXzFPy0bHqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdHHXtw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2017 19:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dbueso@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: fix deadlock from typo vm_lock_anon_vma()
has been added to the -mm tree.  Its filename is
     lib-interval_tree-fast-overlap-detection-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval_tree-fast-overlap-detection-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval_tree-fast-overlap-detection-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/mmu_notifier: fix deadlock from typo vm_lock_anon_vma()

Fix typo introduced by 0c67e6038580e343bd ("lib/interval_tree: fast
overlap detection") which result in deadlock when mm_take_all_locks() is
call (only user being mmu_notifier at this time).

Link: http://lkml.kernel.org/r/20170808225719.20723-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~lib-interval_tree-fast-overlap-detection-fix mm/mmap.c
--- a/mm/mmap.c~lib-interval_tree-fast-overlap-detection-fix
+++ a/mm/mmap.c
@@ -3322,7 +3322,7 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->rb_root.rb_root.rb_node)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
_

Patches currently in -mm which might be from jglisse@redhat.com are

lib-interval_tree-fast-overlap-detection-fix.patch


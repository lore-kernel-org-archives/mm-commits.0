From: akpm@linux-foundation.org
Subject: + fork-use-vma_pages-to-simplify-the-code-fix.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:42:23 -0700
Message-ID: <20120613214223.BD61EA02A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38969 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2FMVmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:42:25 -0400
Received: by ghbz15 with SMTP id z15so94304ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:42:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, shijie8@gmail.com


The patch titled
     Subject: fork-use-vma_pages-to-simplify-the-code-fix
has been added to the -mm tree.  Its filename is
     fork-use-vma_pages-to-simplify-the-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fork-use-vma_pages-to-simplify-the-code-fix

initialise `len' at its definition site

Cc: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~fork-use-vma_pages-to-simplify-the-code-fix kernel/fork.c
--- a/kernel/fork.c~fork-use-vma_pages-to-simplify-the-code-fix
+++ a/kernel/fork.c
@@ -383,8 +383,8 @@ static int dup_mmap(struct mm_struct *mm
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned long len;
-			len = vma_pages(mpnt);
+			unsigned long len = vma_pages(mpnt);
+
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
_
Subject: Subject: fork-use-vma_pages-to-simplify-the-code-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


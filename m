From: akpm@linux-foundation.org
Subject: + mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:28:04 -0700
Message-ID: <201010052128.o95LS43R021067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755675Ab0JEV2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     mm: add casts to/from gfp_t in gfp_to_alloc_flags()
has been added to the -mm tree.  Its filename is
     mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add casts to/from gfp_t in gfp_to_alloc_flags()
From: Namhyung Kim <namhyung@gmail.com>

This removes following warning from sparse:

 mm/page_alloc.c:1934:9: warning: restricted gfp_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags
+++ a/mm/page_alloc.c
@@ -1932,7 +1932,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
-	BUILD_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
+	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
@@ -1940,7 +1940,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	alloc_flags |= (gfp_mask & __GFP_HIGH);
+	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
 		alloc_flags |= ALLOC_HARDER;
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
mm-remove-temporary-variable-on-generic_file_direct_write.patch
mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch
mm-wrap-get_locked_pte-using-__cond_lock.patch
mm-add-lock-release-annotation-on-do_wp_page.patch
mm-wrap-follow_pte-using-__cond_lock.patch
rmap-annotate-lock-context-change-on-page_lock_anon_vma.patch
rmap-wrap-page_check_address-using-__cond_lock.patch
rmap-make-anon_vma_free-static.patch
vmalloc-rename-temporary-variable-in-__insert_vmap_area.patch
vmalloc-annotate-lock-context-change-on-s_start-stop.patch
mm-declare-some-external-symbols.patch
vmstat-include-compactionh-when-config_compaction.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch


From: akpm@linux-foundation.org
Subject: + mm-declare-some-external-symbols.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:28:22 -0700
Message-ID: <201010052128.o95LSMBq021124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab0JEVbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     mm: declare some external symbols
has been added to the -mm tree.  Its filename is
     mm-declare-some-external-symbols.patch

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
Subject: mm: declare some external symbols
From: Namhyung Kim <namhyung@gmail.com>

Declare 'bdi_pending_list' and 'tag_pages_for_writeback()' to remove
following sparse warnings:

 mm/backing-dev.c:46:1: warning: symbol 'bdi_pending_list' was not declared. Should it be static?
 mm/page-writeback.c:825:6: warning: symbol 'tag_pages_for_writeback' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 include/linux/writeback.h   |    2 ++
 2 files changed, 3 insertions(+)

diff -puN include/linux/backing-dev.h~mm-declare-some-external-symbols include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-declare-some-external-symbols
+++ a/include/linux/backing-dev.h
@@ -111,6 +111,7 @@ void bdi_wakeup_thread_delayed(struct ba
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
+extern struct list_head bdi_pending_list;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
diff -puN include/linux/writeback.h~mm-declare-some-external-symbols include/linux/writeback.h
--- a/include/linux/writeback.h~mm-declare-some-external-symbols
+++ a/include/linux/writeback.h
@@ -149,6 +149,8 @@ int write_cache_pages(struct address_spa
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
+void tag_pages_for_writeback(struct address_space *mapping,
+			     pgoff_t start, pgoff_t end);
 
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
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


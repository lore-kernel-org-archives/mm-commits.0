From: akpm@linux-foundation.org
Subject: +
 mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch added to -mm tree
Date: Mon, 10 Mar 2014 13:40:56 -0700
Message-ID: <531e2358.j/aV38t7hi5HreJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbaCJUk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: + mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch added to -mm tree
To: josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:40:56 -0700


The patch titled
     Subject: mm: disable mm/balloon_compaction.c completely when !CONFIG_BALLOON_COMPACTION
has been added to the -mm tree.  Its filename is
     mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: mm: disable mm/balloon_compaction.c completely when !CONFIG_BALLOON_COMPACTION

mm/balloon_compaction.c contains ifdefs around some of its functions when
!CONFIG_BALLOON_COMPACTION, but the remaining functions aren't used in
that case either.  Drop the ifdefs in the file, and move
mm/balloon_compaction.o to obj-$(CONFIG_BALLOON_COMPACTION).

In addition to eliminating that ifdef, this also saves some space;
bloat-o-meter statistics:
add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-281 (-281)
function                                     old     new   delta
balloon_devinfo_alloc                         63       -     -63
balloon_page_enqueue                          84       -     -84
balloon_page_dequeue                         134       -    -134

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile             |    4 ++--
 mm/balloon_compaction.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/Makefile~mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction mm/Makefile
--- a/mm/Makefile~mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction
+++ a/mm/Makefile
@@ -16,7 +16,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o balloon_compaction.o vmacache.o \
+			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o $(mmu-y)
 
 obj-y += init-mm.o
@@ -28,7 +28,7 @@ else
 endif
 
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
-
+obj-$(CONFIG_BALLOON_COMPACTION) += balloon_compaction.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
diff -puN mm/balloon_compaction.c~mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction
+++ a/mm/balloon_compaction.c
@@ -131,7 +131,6 @@ struct page *balloon_page_dequeue(struct
 }
 EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
-#ifdef CONFIG_BALLOON_COMPACTION
 /*
  * balloon_mapping_alloc - allocates a special ->mapping for ballooned pages.
  * @b_dev_info: holds the balloon device information descriptor.
@@ -299,4 +298,3 @@ int balloon_page_migrate(struct page *ne
 	unlock_page(newpage);
 	return rc;
 }
-#endif /* CONFIG_BALLOON_COMPACTION */
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lglock-map-to-spinlock-when-config_smp.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
lib-decompress_inflatec-include-appropriate-header-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-make-bug-always-stop-the-machine.patch
x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
linux-next.patch


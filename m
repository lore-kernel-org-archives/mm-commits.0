From: akpm@linux-foundation.org
Subject: + linux-next-unbork-meminfo.patch added to -mm tree
Date: Tue, 21 Oct 2008 16:53:09 -0700
Message-ID: <200810220007.m9M07oXk020737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYJVAIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 20:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, sfr@canb.auug.org.au


The patch titled
     linux-next-unbork-meminfo
has been added to the -mm tree.  Its filename is
     linux-next-unbork-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-unbork-meminfo
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |   87 +++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff -puN fs/proc/meminfo.c~linux-next-unbork-meminfo fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~linux-next-unbork-meminfo
+++ a/fs/proc/meminfo.c
@@ -26,6 +26,8 @@ static int meminfo_proc_show(struct seq_
 	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
+	unsigned long pages[NR_LRU_LISTS];
+	int lru;
 
 /*
  * display in kilobytes.
@@ -44,51 +46,70 @@ static int meminfo_proc_show(struct seq_
 
 	get_vmalloc_info(&vmi);
 
+	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+
 	/*
 	 * Tagged format, for easy grepping and expansion.
 	 */
 	seq_printf(m,
-		"MemTotal:     %8lu kB\n"
-		"MemFree:      %8lu kB\n"
-		"Buffers:      %8lu kB\n"
-		"Cached:       %8lu kB\n"
-		"SwapCached:   %8lu kB\n"
-		"Active:       %8lu kB\n"
-		"Inactive:     %8lu kB\n"
+		"MemTotal:       %8lu kB\n"
+		"MemFree:        %8lu kB\n"
+		"Buffers:        %8lu kB\n"
+		"Cached:         %8lu kB\n"
+		"SwapCached:     %8lu kB\n"
+		"Active:         %8lu kB\n"
+		"Inactive:       %8lu kB\n"
+		"Active(anon):   %8lu kB\n"
+		"Inactive(anon): %8lu kB\n"
+		"Active(file):   %8lu kB\n"
+		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		"Unevictable:    %8lu kB\n"
+		"Mlocked:        %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
-		"HighTotal:    %8lu kB\n"
-		"HighFree:     %8lu kB\n"
-		"LowTotal:     %8lu kB\n"
-		"LowFree:      %8lu kB\n"
-#endif
-		"SwapTotal:    %8lu kB\n"
-		"SwapFree:     %8lu kB\n"
-		"Dirty:        %8lu kB\n"
-		"Writeback:    %8lu kB\n"
-		"AnonPages:    %8lu kB\n"
-		"Mapped:       %8lu kB\n"
-		"Slab:         %8lu kB\n"
-		"SReclaimable: %8lu kB\n"
-		"SUnreclaim:   %8lu kB\n"
-		"PageTables:   %8lu kB\n"
+		"HighTotal:      %8lu kB\n"
+		"HighFree:       %8lu kB\n"
+		"LowTotal:       %8lu kB\n"
+		"LowFree:        %8lu kB\n"
+#endif
+		"SwapTotal:      %8lu kB\n"
+		"SwapFree:       %8lu kB\n"
+		"Dirty:          %8lu kB\n"
+		"Writeback:      %8lu kB\n"
+		"AnonPages:      %8lu kB\n"
+		"Mapped:         %8lu kB\n"
+		"Slab:           %8lu kB\n"
+		"SReclaimable:   %8lu kB\n"
+		"SUnreclaim:     %8lu kB\n"
+		"PageTables:     %8lu kB\n"
 #ifdef CONFIG_QUICKLIST
-		"Quicklists:   %8lu kB\n"
+		"Quicklists:     %8lu kB\n"
 #endif
-		"NFS_Unstable: %8lu kB\n"
-		"Bounce:       %8lu kB\n"
-		"WritebackTmp: %8lu kB\n"
-		"CommitLimit:  %8lu kB\n"
-		"Committed_AS: %8lu kB\n"
-		"VmallocTotal: %8lu kB\n"
-		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
+		"NFS_Unstable:   %8lu kB\n"
+		"Bounce:         %8lu kB\n"
+		"WritebackTmp:   %8lu kB\n"
+		"CommitLimit:    %8lu kB\n"
+		"Committed_AS:   %8lu kB\n"
+		"VmallocTotal:   %8lu kB\n"
+		"VmallocUsed:    %8lu kB\n"
+		"VmallocChunk:   %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages),
-		K(global_page_state(NR_ACTIVE)),
-		K(global_page_state(NR_INACTIVE)),
+		K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
+		K(pages[LRU_ACTIVE_ANON]),
+		K(pages[LRU_INACTIVE_ANON]),
+		K(pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_FILE]),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_MLOCK)),
+#endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-unbork-meminfo.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


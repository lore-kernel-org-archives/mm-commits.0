From: akpm@linux-foundation.org
Subject: + remove-documentation-smptxt.patch added to -mm tree
Date: Fri, 09 Nov 2007 00:25:05 -0800
Message-ID: <200711090825.lA98P60L004515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbXKIIZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 03:25:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, alan@redhat.com


The patch titled
     remove Documentation/smp.txt
has been added to the -mm tree.  Its filename is
     remove-documentation-smptxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove Documentation/smp.txt
From: Adrian Bunk <bunk@kernel.org>

After seeing the filename I'd have expected something about the
implementation of SMP in the Linux kernel - not some notes on kernel
configuration and building trivialities noone would search at this place.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX |    2 --
 Documentation/smp.txt  |   22 ----------------------
 2 files changed, 24 deletions(-)

diff -puN Documentation/00-INDEX~remove-documentation-smptxt Documentation/00-INDEX
--- a/Documentation/00-INDEX~remove-documentation-smptxt
+++ a/Documentation/00-INDEX
@@ -362,8 +362,6 @@ sharedsubtree.txt
 	- a description of shared subtrees for namespaces.
 smart-config.txt
 	- description of the Smart Config makefile feature.
-smp.txt
-	- a few notes on symmetric multi-processing.
 sony-laptop.txt
 	- Sony Notebook Control Driver (SNC) Readme.
 sonypi.txt
diff -puN Documentation/smp.txt~remove-documentation-smptxt /dev/null
--- a/Documentation/smp.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-To set up SMP
-
-Configure the kernel and answer Y to CONFIG_SMP.
-
-If you are using LILO, it is handy to have both SMP and non-SMP
-kernel images on hand. Edit /etc/lilo.conf to create an entry
-for another kernel image called "linux-smp" or something.
-
-The next time you compile the kernel, when running a SMP kernel,
-edit linux/Makefile and change "MAKE=make" to "MAKE=make -jN"
-(where N = number of CPU + 1, or if you have tons of memory/swap
- you can just use "-j" without a number). Feel free to experiment
-with this one.
-
-Of course you should time how long each build takes :-)
-Example:
-   make config
-   time -v sh -c 'make clean install modules modules_install'
-
-If you are using some Compaq MP compliant machines you will need to set
-the operating system in the BIOS settings to "Unixware" - don't ask me
-why Compaqs don't work otherwise.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch

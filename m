From: akpm@linux-foundation.org
Subject: - kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 25 Oct 2008 15:01:14 -0700
Message-ID: <200810252201.m9PM1FKt007091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbYJYWB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Oct 2008 18:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ashutosh.naik@gmail.com, ashutosh@chelsio.com, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch

This patch was dropped because it was folded into kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need consistent spacing around '-' (ctx:WxV)
#26: FILE: scripts/mod/sumversion.c:297:
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
 	                ^

ERROR: spaces required around that '==' (ctx:VxV)
#26: FILE: scripts/mod/sumversion.c:297:
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
 	                   ^

ERROR: spaces required around that '==' (ctx:VxV)
#26: FILE: scripts/mod/sumversion.c:297:
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
 	                                              ^

ERROR: space required before the open parenthesis '('
#26: FILE: scripts/mod/sumversion.c:297:
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))

WARNING: line over 80 characters
#39: FILE: scripts/mod/sumversion.c:432:
+		if (!(is_static_library(fname)) && !parse_source_files(fname, &md))

total: 4 errors, 1 warnings, 23 lines checked

./patches/kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Ashutosh Naik" <ashutosh@chelsio.com>
Cc: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/sumversion.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/mod/sumversion.c~kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes scripts/mod/sumversion.c
--- a/scripts/mod/sumversion.c~kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes
+++ a/scripts/mod/sumversion.c
@@ -294,7 +294,7 @@ static int parse_file(const char *fname,
 static int is_static_library(const char *objfile)
 {
 	int len = strlen(objfile);
-	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
+	if (objfile[len - 2] == '.' && objfile[len - 1] == 'a')
 		return 1;
 	else
 		return 0;
@@ -429,7 +429,8 @@ void get_src_version(const char *modname
 	while ((fname = strsep(&sources, " ")) != NULL) {
 		if (!*fname)
 			continue;
-		if (!(is_static_library(fname)) && !parse_source_files(fname, &md))
+		if (!(is_static_library(fname)) &&
+				!parse_source_files(fname, &md))
 			goto release;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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


From: akpm@linux-foundation.org
Subject: [to-be-updated] exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 27 Jan 2010 13:33:04 -0800
Message-ID: <201001272133.o0RLX4H4000701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab0A0VdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 16:33:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#90: FILE: arch/x86/kernel/cpu/mcheck/mce.c:1177:
+	call_usermodehelper(mce_helper, mce_helper_argv, NULL, NULL, UMH_NO_WAIT);

WARNING: line over 80 characters
#138: FILE: drivers/net/hamradio/baycom_epp.c:323:
+	return call_usermodehelper(eppconfig_path, argv, envp, NULL, UMH_WAIT_PROC);

ERROR: space prohibited before open square bracket '['
#150: FILE: drivers/pnp/pnpbios/core.c:145:
+	value = call_usermodehelper(argv [0], argv, envp, NULL, UMH_WAIT_EXEC);

WARNING: line over 80 characters
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);

ERROR: code indent should use tabs where possible
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);$

ERROR: space required after that ',' (ctx:VxV)
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
                                                                   ^

ERROR: space required after that ',' (ctx:VxV)
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
                                                                        ^

ERROR: space required after that ',' (ctx:VxV)
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
                                                                             ^

ERROR: space required after that ',' (ctx:VxV)
#162: FILE: drivers/staging/rtl8187se/r8180_core.c:4290:
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
                                                                                  ^

ERROR: trailing whitespace
#188: FILE: fs/exec.c:1767:
+ * Its called in the context of the task thats going to $

ERROR: trailing whitespace
#259: FILE: include/linux/kmod.h:51:
+^I^I^I^I^I^I  char **envp, $

ERROR: trailing whitespace
#270: FILE: include/linux/kmod.h:77:
+call_usermodehelper(char *path, char **argv, char **envp, $

ERROR: trailing whitespace
#286: FILE: include/linux/kmod.h:91:
+^I^I^I struct key *session_keyring, $

ERROR: trailing whitespace
#361: FILE: kernel/kmod.c:373:
+^I^I^I^I^I^I  char **envp, $

WARNING: line over 80 characters
#387: FILE: kernel/kmod.c:527:
+	sub_info = call_usermodehelper_setup(path, argv, envp, finit, GFP_KERNEL);

total: 11 errors, 4 warnings, 289 lines checked

./patches/exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c             |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |    3 ++-
 fs/exec.c                              |    8 ++++----
 kernel/kmod.c                          |    3 ++-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/pnp/pnpbios/core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
+++ a/drivers/pnp/pnpbios/core.c
@@ -142,7 +142,7 @@ static int pnp_dock_event(int dock, stru
 			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 
-	value = call_usermodehelper(argv [0], argv, envp, NULL, UMH_WAIT_EXEC);
+	value = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
 	kfree(buf);
 	kfree(envp);
 	return 0;
diff -puN drivers/staging/rtl8187se/r8180_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -4287,7 +4287,8 @@ void GPIOChangeRFWorkItemCallBack(struct
                                 argv[0] = RadioPowerPath;
                                 argv[2] = NULL;
 
-                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
+				call_usermodehelper(RadioPowerPath, argv,
+							envp, NULL, 1);
 			}
 		}
 }
diff -puN fs/exec.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
+++ a/fs/exec.c
@@ -1762,10 +1762,10 @@ static void wait_for_dump_helpers(struct
 }
 
 /*
- * This is used as a helper to set up the task that execs
- * our user space core collector application
- * Its called in the context of the task thats going to
- * exec itself to be the helper, so we can modify current here
+ * This is used as a helper to set up the task that execs our userspace core
+ * collector application.
+ * It is called in the context of the task that is going to exec itself to be
+ * the helper, so we can modify current here.
  */
 void core_pipe_setup(void)
 {
diff -puN kernel/kmod.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes kernel/kmod.c
--- a/kernel/kmod.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes
+++ a/kernel/kmod.c
@@ -524,7 +524,8 @@ int call_usermodehelper_pipe(char *path,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, finit, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp, finit,
+						GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


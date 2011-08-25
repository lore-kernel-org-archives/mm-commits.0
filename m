From: akpm@linux-foundation.org
Subject: + drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch added to -mm tree
Date: Thu, 25 Aug 2011 16:58:48 -0700
Message-ID: <201108252358.p7PNwmeO021114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab1HYX6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 19:58:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kashyap.desai@lsi.com, wferi@niif.hu


The patch titled
     drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch

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
Subject: drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#22: FILE: drivers/message/fusion/mptbase.c:118:
+static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN+1];

WARNING: line over 80 characters
#32: FILE: drivers/message/fusion/mptbase.c:720:
+			strlcpy(MptCallbacksName[cb_idx], func_name, MPT_MAX_CALLBACKNAME_LEN+1);

total: 0 errors, 2 warnings, 24 lines checked

./patches/drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Desai <kashyap.desai@lsi.com>
Cc: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes
+++ a/drivers/message/fusion/mptbase.c
@@ -115,7 +115,8 @@ module_param(mpt_fwfault_debug, int, 060
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN+1];
+static char
+MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN + 1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -717,7 +718,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DR
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			strlcpy(MptCallbacksName[cb_idx], func_name, MPT_MAX_CALLBACKNAME_LEN+1);
+			strlcpy(MptCallbacksName[cb_idx], func_name,
+				MPT_MAX_CALLBACKNAME_LEN+1);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
alpha-unbreak-osf_setsysinfossi_nvpairs.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
kernel-rtmutexc-fix-warning-improve-coding-style.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


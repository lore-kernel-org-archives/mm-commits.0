From: akpm@osdl.org
Subject: - drivers-isdn-handcrafted-min-max-macro-removal-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:58:22 -0800
Message-ID: <200612080858.kB88wMxD014203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425257AbWLHI6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, amol@verismonetworks.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers-isdn-handcrafted-min-max-macro-removal-fix
has been removed from the -mm tree.  Its filename was
     drivers-isdn-handcrafted-min-max-macro-removal-fix.patch

This patch was dropped because it was folded into drivers-isdn-handcrafted-min-max-macro-removal.patch

------------------------------------------------------
Subject: drivers-isdn-handcrafted-min-max-macro-removal-fix
From: Andrew Morton <akpm@osdl.org>

drivers/isdn/hardware/eicon/io.c: In function 'request':
drivers/isdn/hardware/eicon/io.c:265: warning: comparison of distinct pointer types lacks a cast

Cc: Amol Lad <amol@verismonetworks.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/eicon/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/eicon/io.c~drivers-isdn-handcrafted-min-max-macro-removal-fix drivers/isdn/hardware/eicon/io.c
--- a/drivers/isdn/hardware/eicon/io.c~drivers-isdn-handcrafted-min-max-macro-removal-fix
+++ a/drivers/isdn/hardware/eicon/io.c
@@ -262,7 +262,7 @@ void request(PISDN_ADAPTER IoAdapter, EN
     case IDI_SYNC_REQ_XDI_GET_CAPI_PARAMS: {
        diva_xdi_get_capi_parameters_t prms, *pI = &syncReq->xdi_capi_prms.info;
        memset (&prms, 0x00, sizeof(prms));
-       prms.structure_length = min(sizeof(prms), pI->structure_length);
+       prms.structure_length = min_t(size_t, sizeof(prms), pI->structure_length);
        memset (pI, 0x00, pI->structure_length);
        prms.flag_dynamic_l1_down    = (IoAdapter->capi_cfg.cfg_1 & \
          DIVA_XDI_CAPI_CFG_1_DYNAMIC_L1_ON) ? 1 : 0;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch


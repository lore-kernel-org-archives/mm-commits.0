From: akpm@linux-foundation.org
Subject: [merged] efifb-fix-framebuffer-handoff.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:38 -0800
Message-ID: <201002241939.o1OJdcfg016308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876Ab0BXTkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, airlied@redhat.com, alex.vizor@gmail.com, pjones@redhat.com, rjw@sisk.pl, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     efifb: fix framebuffer handoff
has been removed from the -mm tree.  Its filename was
     efifb-fix-framebuffer-handoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efifb: fix framebuffer handoff
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Commit 4410f3910947dcea8672280b3adecd53cec4e85e (fbdev: add support for
handoff from firmware to hw framebuffers) didn't add fb_destroy operation
to efifb.  Fix it and change aperture_size to match size passed to
request_mem_region.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15151

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Reported-by: Alex Zhavnerchik <alex.vizor@gmail.com>
Tested-by: Alex Zhavnerchik <alex.vizor@gmail.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/video/efifb.c~efifb-fix-framebuffer-handoff drivers/video/efifb.c
--- a/drivers/video/efifb.c~efifb-fix-framebuffer-handoff
+++ a/drivers/video/efifb.c
@@ -161,8 +161,17 @@ static int efifb_setcolreg(unsigned regn
 	return 0;
 }
 
+static void efifb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(info->aperture_base, info->aperture_size);
+	framebuffer_release(info);
+}
+
 static struct fb_ops efifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_destroy	= efifb_destroy,
 	.fb_setcolreg	= efifb_setcolreg,
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
@@ -281,7 +290,7 @@ static int __init efifb_probe(struct pla
 	info->par = NULL;
 
 	info->aperture_base = efifb_fix.smem_start;
-	info->aperture_size = size_total;
+	info->aperture_size = size_remap;
 
 	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch


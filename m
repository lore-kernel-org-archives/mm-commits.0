From: akpm@linux-foundation.org
Subject: [merged]
 drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch removed
 from -mm tree
Date: Thu, 19 Dec 2013 11:54:15 -0800
Message-ID: <52b34ee7.SmchQlcurYDRlBQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3LSTyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alexander.deucher@amd.com, geert@linux-m68k.org

Subject: [merged] drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch removed from -mm tree
To: geert@linux-m68k.org,alexander.deucher@amd.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:15 -0800


The patch titled
     Subject: drivers/gpu/drm/drm_edid_load.c: make edid_load() return a void *
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/gpu/drm/drm_edid_load.c: make edid_load() return a void *

Always use "void *" for arbitrary memory buffers, as this allows to drop
casts in assignments.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_edid_load.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/drm_edid_load.c~drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void drivers/gpu/drm/drm_edid_load.c
--- a/drivers/gpu/drm/drm_edid_load.c~drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void
+++ a/drivers/gpu/drm/drm_edid_load.c
@@ -141,7 +141,7 @@ static int edid_size(const u8 *edid, int
 	return (edid[0x7e] + 1) * EDID_LENGTH;
 }
 
-static u8 *edid_load(struct drm_connector *connector, const char *name,
+static void *edid_load(struct drm_connector *connector, const char *name,
 			const char *connector_name)
 {
 	const struct firmware *fw = NULL;
@@ -263,7 +263,7 @@ int drm_load_edid_firmware(struct drm_co
 	if (*last == '\n')
 		*last = '\0';
 
-	edid = (struct edid *) edid_load(connector, edidname, connector_name);
+	edid = edid_load(connector, edidname, connector_name);
 	if (IS_ERR_OR_NULL(edid))
 		return 0;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
futex-switch-to-user_ds-for-futex-test.patch
sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch


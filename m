From: akpm@linux-foundation.org
Subject: +
 drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch added to
 -mm tree
Date: Tue, 19 Nov 2013 14:33:26 -0800
Message-ID: <528be736.dggkIY3Eu2AEXWL4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3KSWd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 17:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alexander.deucher@amd.com, geert@linux-m68k.org

Subject: + drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch added to -mm tree
To: geert@linux-m68k.org,alexander.deucher@amd.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 14:33:26 -0800


The patch titled
     Subject: drivers/gpu/drm/drm_edid_load.c: make edid_load() return a void *
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
linux-next.patch


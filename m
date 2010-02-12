From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:36 -0800
Message-ID: <201002121903.o1CJ3aCD021129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab0BLTEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, airlied@linux.ie, bskeggs@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/nouveau/nouveau_grctx.c: correct NULL test
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/nouveau/nouveau_grctx.c: correct NULL test
From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_grctx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_grctx.c~drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test drivers/gpu/drm/nouveau/nouveau_grctx.c
--- a/drivers/gpu/drm/nouveau/nouveau_grctx.c~drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test
+++ a/drivers/gpu/drm/nouveau/nouveau_grctx.c
@@ -97,8 +97,8 @@ nouveau_grctx_prog_load(struct drm_devic
 		}
 
 		pgraph->ctxvals = kmalloc(fw->size, GFP_KERNEL);
-		if (!pgraph->ctxprog) {
-			NV_ERROR(dev, "OOM copying ctxprog\n");
+		if (!pgraph->ctxvals) {
+			NV_ERROR(dev, "OOM copying ctxvals\n");
 			release_firmware(fw);
 			nouveau_grctx_fini(dev);
 			return -ENOMEM;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch


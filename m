From: akpm@linux-foundation.org
Subject: [merged] gpu-vga_switcheroo-fix-lock-imbalance.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:39 -0400
Message-ID: <201005061910.o46JA9DX008496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab0EFTKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, airlied@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gpu: vga_switcheroo, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     gpu-vga_switcheroo-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpu: vga_switcheroo, fix lock imbalance
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that one error path in vga_switcheroo_debugfs_write omits to
unlock vgasr_mutex.  Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vga_switcheroo.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/vga/vga_switcheroo.c~gpu-vga_switcheroo-fix-lock-imbalance drivers/gpu/vga/vga_switcheroo.c
--- a/drivers/gpu/vga/vga_switcheroo.c~gpu-vga_switcheroo-fix-lock-imbalance
+++ a/drivers/gpu/vga/vga_switcheroo.c
@@ -276,8 +276,10 @@ vga_switcheroo_debugfs_write(struct file
 
 	mutex_lock(&vgasr_mutex);
 
-	if (!vgasr_priv.active)
-		return -EINVAL;
+	if (!vgasr_priv.active) {
+		cnt = -EINVAL;
+		goto out;
+	}
 
 	/* pwr off the device not in use */
 	if (strncmp(usercmd, "OFF", 3) == 0) {
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch


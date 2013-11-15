From: akpm@linux-foundation.org
Subject: [folded-merged]
 drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 14:14:17 -0800
Message-ID: <52869cb9.Nxglw6dliPLsOK+j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KOWOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.cz, jeffm@suse.com, bskeggs@redhat.com, airlied@linux.ie, rdunlap@infradead.org

Subject: [folded-merged] drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix.patch removed from -mm tree
To: rdunlap@infradead.org,airlied@linux.ie,bskeggs@redhat.com,jeffm@suse.com,jslaby@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:14:17 -0800


The patch titled
     Subject: nouveau: fix build eror when VGA_SWITCHEROO is not enabled
has been removed from the -mm tree.  Its filename was
     drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix.patch

This patch was dropped because it was folded into drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: nouveau: fix build eror when VGA_SWITCHEROO is not enabled

Fix nouveau build error on x86, when ACPI is enabled but VGA_SWITCHEROO is
not enabled, by providing a stub function.

drivers/built-in.o: In function `nouveau_pmops_runtime_suspend':
nouveau_drm.c:(.text+0x3aac89): undefined reference to `nouveau_switcheroo_optimus_dsm'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_acpi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/nouveau/nouveau_acpi.c~drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix drivers/gpu/drm/nouveau/nouveau_acpi.c
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c~drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix
+++ a/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -380,6 +380,7 @@ void nouveau_unregister_dsm_handler(void
 #else
 void nouveau_register_dsm_handler(void) {}
 void nouveau_unregister_dsm_handler(void) {}
+void nouveau_switcheroo_optimus_dsm(void) {}
 #endif
 
 /* retrieve the ROM in 4k blocks */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch


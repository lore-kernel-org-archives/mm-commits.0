From: akpm@linux-foundation.org
Subject: + nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:37:56 -0700
Message-ID: <523cb224.D2bdB+iT1Fuia/4H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3ITUh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bskeggs@redhat.com, airlied@linux.ie, rdunlap@infradead.org

Subject: + nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch added to -mm tree
To: rdunlap@infradead.org,airlied@linux.ie,bskeggs@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:37:56 -0700


The patch titled
     Subject: nouveau: fix build eror when VGA_SWITCHEROO is not enabled
has been added to the -mm tree.  Its filename is
     nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: nouveau: fix build eror when VGA_SWITCHEROO is not enabled

Fix nouveau build error on x86, when ACPI is enabled but VGA_SWITCHEROO is
not enabled, by providing a stub function.

drivers/built-in.o: In function `nouveau_pmops_runtime_suspend':
nouveau_drm.c:(.text+0x3aac89): undefined reference to `nouveau_switcheroo_optimus_dsm'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_acpi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/nouveau/nouveau_acpi.c~nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled drivers/gpu/drm/nouveau/nouveau_acpi.c
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c~nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled
+++ a/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -373,6 +373,7 @@ void nouveau_unregister_dsm_handler(void
 #else
 void nouveau_register_dsm_handler(void) {}
 void nouveau_unregister_dsm_handler(void) {}
+void nouveau_switcheroo_optimus_dsm(void) {}
 #endif
 
 /* retrieve the ROM in 4k blocks */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
include-linux-of_irqh-fix-warnings-when-config_of=n.patch
linux-next.patch
nouveau-fix-build-eror-when-vga_switcheroo-is-not-enabled.patch
debugging-keep-track-of-page-owners-fix-2.patch


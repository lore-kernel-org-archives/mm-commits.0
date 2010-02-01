From: akpm@linux-foundation.org
Subject: + edac-add-__init-to-i7core_xeon_pci_fixup.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:18:05 -0800
Message-ID: <201002012018.o11KI5tS009976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756052Ab0BAUSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, mchehab@redhat.com, norsk5@yahoo.com


The patch titled
     edac: add __init to i7core_xeon_pci_fixup()
has been added to the -mm tree.  Its filename is
     edac-add-__init-to-i7core_xeon_pci_fixup.patch

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
Subject: edac: add __init to i7core_xeon_pci_fixup()
From: Jiri Slaby <jslaby@suse.cz>

It's called only from an __init function and is the only user of
pcibios_scan_specific_bus which shall be marked as __devinit to resolve
section mismatches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i7core_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i7core_edac.c~edac-add-__init-to-i7core_xeon_pci_fixup drivers/edac/i7core_edac.c
--- a/drivers/edac/i7core_edac.c~edac-add-__init-to-i7core_xeon_pci_fixup
+++ a/drivers/edac/i7core_edac.c
@@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
 		i7core_put_devices(i7core_dev);
 }
 
-static void i7core_xeon_pci_fixup(int dev_id)
+static void __init i7core_xeon_pci_fixup(int dev_id)
 {
 	struct pci_dev *pdev = NULL;
 	int i;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
video-backlight-progear-fix-pci-device-refcounting.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch


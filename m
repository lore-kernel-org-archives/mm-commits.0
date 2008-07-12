From: akpm@linux-foundation.org
Subject: + x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch added to -mm tree
Date: Fri, 11 Jul 2008 18:04:45 -0700
Message-ID: <200807120104.m6C14jsR013672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbYGLBGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 21:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jbarnes@virtuousgeek.org, mingo@elte.hu


The patch titled
     x86 pci: fix pci_subsys_init() to have a return value
has been added to the -mm tree.  Its filename is
     x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 pci: fix pci_subsys_init() to have a return value
From: David Howells <dhowells@redhat.com>

Fix pci_subsys_init() to return a value (0) when it has finished.  All the
functions it calls currently return 0, so returning 0 here unconditionally
rather than gathering the results of its callees would seem reasonable.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/legacy.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/pci/legacy.c~x86-pci-fix-pci_subsys_init-to-have-a-return-value arch/x86/pci/legacy.c
--- a/arch/x86/pci/legacy.c~x86-pci-fix-pci_subsys_init-to-have-a-return-value
+++ a/arch/x86/pci/legacy.c
@@ -63,5 +63,6 @@ int __init pci_subsys_init(void)
 	pci_legacy_init();
 	pcibios_irq_init();
 	pcibios_init();
+	return 0;
 }
 subsys_initcall(pci_subsys_init);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch


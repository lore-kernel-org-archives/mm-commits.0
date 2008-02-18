From: akpm@linux-foundation.org
Subject: + pcmcia-annotate-cb_alloc-with-__ref.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:02:23 -0800
Message-ID: <200802181003.m1IA3KTe019116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbYBRKD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, linux@dominikbrodowski.net


The patch titled
     pcmcia: annotate cb_alloc with __ref
has been added to the -mm tree.  Its filename is
     pcmcia-annotate-cb_alloc-with-__ref.patch

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
Subject: pcmcia: annotate cb_alloc with __ref
From: Sam Ravnborg <sam@ravnborg.org>

cb_alloc() uses a function (pci_scan_slot) that will be annotated __devinit.

Annotate cb_alloc() with __ref to tell modpost to ignore this reference.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cardbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/cardbus.c~pcmcia-annotate-cb_alloc-with-__ref drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~pcmcia-annotate-cb_alloc-with-__ref
+++ a/drivers/pcmcia/cardbus.c
@@ -209,7 +209,7 @@ static void cardbus_assign_irqs(struct p
 	}
 }
 
-int cb_alloc(struct pcmcia_socket * s)
+int __ref cb_alloc(struct pcmcia_socket * s)
 {
 	struct pci_bus *bus = s->cb_dev->subordinate;
 	struct pci_dev *dev;
_

Patches currently in -mm which might be from sam@ravnborg.org are

samples-build-fix.patch
git-acpi.patch
acpi-fix-section-mismatch-in-acpi_pci_root_add.patch
acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify.patch
acer-wmi-fix-section-mismatch-warnings.patch
alsa-caiaq-fix-section-mismatch-warning.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
git-kbuild.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
scsi-fix-section-mismatch-in-aic94xx.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch

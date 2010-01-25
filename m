From: akpm@linux-foundation.org
Subject: + vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0.patch added to -mm tree
Date: Mon, 25 Jan 2010 15:57:18 -0800
Message-ID: <201001252357.o0PNvIib018708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab0AYX5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 18:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de


The patch titled
     vgaarb: fix VGA arbiter to accept PCI domains other than 0
has been added to the -mm tree.  Its filename is
     vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0.patch

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
Subject: vgaarb: fix VGA arbiter to accept PCI domains other than 0
From: Mike Travis <travis@sgi.com>

Update the VGA Arbiter to accept PCI Domains other than 0.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vgaarb.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/vga/vgaarb.c~vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0 drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0
+++ a/drivers/gpu/vga/vgaarb.c
@@ -954,6 +954,7 @@ static ssize_t vga_arb_write(struct file
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -969,18 +970,31 @@ static ssize_t vga_arb_write(struct file
 				ret_val = -EPROTO;
 				goto done;
 			}
+			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-			pdev = pci_get_bus_and_slot(bus, devfn);
+			pbus = pci_find_bus(domain, bus);
+			pr_devel("vgaarb: pbus %p\n", pbus);
+			if (pbus == NULL) {
+				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
+					domain, bus);
+				ret_val = -ENODEV;
+				goto done;
+			}
+			pdev = pci_get_slot(pbus, devfn);
+			pr_devel("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
-				pr_info("vgaarb: invalid PCI address!\n");
+				pr_err("vgaarb: invalid PCI address %x:%x\n",
+					bus, devfn);
 				ret_val = -ENODEV;
 				goto done;
 			}
 		}
 
 		vgadev = vgadev_find(pdev);
+		pr_devel("vgaarb: vgadev %p\n", vgadev);
 		if (vgadev == NULL) {
-			pr_info("vgaarb: this pci device is not a vga device\n");
+			pr_err("vgaarb: this pci device is not a vga device\n");
 			pci_dev_put(pdev);
 			ret_val = -ENODEV;
 			goto done;
@@ -998,7 +1012,8 @@ static ssize_t vga_arb_write(struct file
 			}
 		}
 		if (i == MAX_USER_CARDS) {
-			pr_err("vgaarb: maximum user cards number reached!\n");
+			pr_err("vgaarb: maximum user cards (%d) number reached!\n",
+				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
 			ret_val =  -ENOMEM;
_

Patches currently in -mm which might be from travis@sgi.com are

pci-update-pci_set_vga_state-to-call-arch-functions.patch
x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly.patch
vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0.patch
vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch


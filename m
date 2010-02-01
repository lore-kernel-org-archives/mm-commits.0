From: akpm@linux-foundation.org
Subject: + agp-amd64-fix-pci-reference-leaks.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:19:31 -0800
Message-ID: <201002012019.o11KJVon010088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0BAUUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, airlied@linux.ie, jbarnes@virtuousgeek.org


The patch titled
     agp: amd64, fix pci reference leaks
has been added to the -mm tree.  Its filename is
     agp-amd64-fix-pci-reference-leaks.patch

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
Subject: agp: amd64, fix pci reference leaks
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found pci reference leaks in uli_agp_init and nforce3_agp_init
initialization functions.

The PCI devices are bridges, so it's not critical, but still worth fixing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/char/agp/amd64-agp.c~agp-amd64-fix-pci-reference-leaks drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~agp-amd64-fix-pci-reference-leaks
+++ a/drivers/char/agp/amd64-agp.c
@@ -383,7 +383,7 @@ static int __devinit uli_agp_init(struct
 {
 	u32 httfea,baseaddr,enuscr;
 	struct pci_dev *dev1;
-	int i;
+	int i, ret;
 	unsigned size = amd64_fetch_size();
 
 	dev_info(&pdev->dev, "setting up ULi AGP\n");
@@ -399,15 +399,18 @@ static int __devinit uli_agp_init(struct
 
 	if (i == ARRAY_SIZE(uli_sizes)) {
 		dev_info(&pdev->dev, "no ULi size found for %d\n", size);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	/* shadow x86-64 registers into ULi registers */
 	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
-	if ((httfea & 0x7fff) >> (32 - 25))
-		return -ENODEV;
+	if ((httfea & 0x7fff) >> (32 - 25)) {
+		ret = -ENODEV;
+		goto put;
+	}
 
 	httfea = (httfea& 0x7fff) << 25;
 
@@ -419,9 +422,10 @@ static int __devinit uli_agp_init(struct
 	enuscr= httfea+ (size * 1024 * 1024) - 1;
 	pci_write_config_dword(dev1, ULI_X86_64_HTT_FEA_REG, httfea);
 	pci_write_config_dword(dev1, ULI_X86_64_ENU_SCR_REG, enuscr);
-
+	ret = 0;
+put:
 	pci_dev_put(dev1);
-	return 0;
+	return ret;
 }
 
 
@@ -440,7 +444,7 @@ static int nforce3_agp_init(struct pci_d
 {
 	u32 tmp, apbase, apbar, aplimit;
 	struct pci_dev *dev1;
-	int i;
+	int i, ret;
 	unsigned size = amd64_fetch_size();
 
 	dev_info(&pdev->dev, "setting up Nforce3 AGP\n");
@@ -457,7 +461,8 @@ static int nforce3_agp_init(struct pci_d
 
 	if (i == ARRAY_SIZE(nforce3_sizes)) {
 		dev_info(&pdev->dev, "no NForce3 size found for %d\n", size);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	pci_read_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, &tmp);
@@ -471,7 +476,8 @@ static int nforce3_agp_init(struct pci_d
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
 		dev_info(&pdev->dev, "aperture base > 4G\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put;
 	}
 
 	apbase = (apbase & 0x7fff) << 25;
@@ -487,9 +493,11 @@ static int nforce3_agp_init(struct pci_d
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APBASE2, apbase);
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APLIMIT2, aplimit);
 
+	ret = 0;
+put:
 	pci_dev_put(dev1);
 
-	return 0;
+	return ret;
 }
 
 static int __devinit agp_amd64_probe(struct pci_dev *pdev,
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
agp-amd64-fix-pci-reference-leaks.patch
isdn-misdn-dont-compile-unused-stuff.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch


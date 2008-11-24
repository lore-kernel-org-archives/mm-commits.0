From: akpm@linux-foundation.org
Subject: + drivers-char-agp-add-missing-pci_dev_get.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:39:31 -0800
Message-ID: <200811242239.mAOMdVfd031607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbYKXWjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:39:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, airlied@linux.ie


The patch titled
     drivers/char/agp: add missing pci_dev_get
has been added to the -mm tree.  Its filename is
     drivers-char-agp-add-missing-pci_dev_get.patch

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
Subject: drivers/char/agp: add missing pci_dev_get
From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case.

In the first three cases, it might also be possible to move the call to
pci_get_slot downwards below the error handling code.

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
local idexpression *n;
statement S1,S2;
expression E,E1;
expression *ptr != NULL;
type T,T1;
@@

(
if (!(n = pci_get_slot(...))) S1
|
n = pci_get_slot(...)
)
<... when != pci_dev_put(n)
    when != if (...) { <+... pci_dev_put(n) ...+> }
    when != true !n  || ...
    when != n = (T)E
    when != E = n
if (!n || ...) S2
...>
(
  return \(0\|<+...n...+>\|ptr\);
|
+ pci_dev_put(n);
return ...;
|
pci_dev_put(n);
|
n = (T1)E1
|
E1 = n
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd64-agp.c~drivers-char-agp-add-missing-pci_dev_get drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~drivers-char-agp-add-missing-pci_dev_get
+++ a/drivers/char/agp/amd64-agp.c
@@ -393,6 +393,7 @@ static int __devinit uli_agp_init(struct
 
 	if (i == ARRAY_SIZE(uli_sizes)) {
 		dev_info(&pdev->dev, "no ULi size found for %d\n", size);
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}
 
@@ -400,8 +401,10 @@ static int __devinit uli_agp_init(struct
 	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
-	if ((httfea & 0x7fff) >> (32 - 25))
+	if ((httfea & 0x7fff) >> (32 - 25)) {
+		pci_dev_put(dev1);
 		return -ENODEV;
+	}
 
 	httfea = (httfea& 0x7fff) << 25;
 
@@ -451,6 +454,7 @@ static int nforce3_agp_init(struct pci_d
 
 	if (i == ARRAY_SIZE(nforce3_sizes)) {
 		dev_info(&pdev->dev, "no NForce3 size found for %d\n", size);
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}
 
@@ -465,6 +469,7 @@ static int nforce3_agp_init(struct pci_d
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
 		dev_info(&pdev->dev, "aperture base > 4G\n");
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-add-missing-pci_dev_get.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-pci-hotplug-add-missing-pci_dev_get.patch


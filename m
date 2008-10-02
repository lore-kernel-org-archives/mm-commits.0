From: akpm@linux-foundation.org
Subject: + drivers-usb-host-use-an-is_err-test-rather-than-a-null-test.patch added to -mm tree
Date: Thu, 02 Oct 2008 00:18:34 -0700
Message-ID: <200810020718.m927IYVW026181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbYJBHSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 03:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brunel@diku.dk, julia@diku.dk


The patch titled
     drivers/usb/host: use an IS_ERR test rather than a NULL test
has been added to the -mm tree.  Its filename is
     drivers-usb-host-use-an-is_err-test-rather-than-a-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/host: use an IS_ERR test rather than a NULL test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function isp1760_register returns an ERR
pointer, but never returns a NULL pointer. So after a call to this
function, a NULL test should be replaced by an IS_ERR test. Moreover,
we have noticed that:

(1) the result of isp1760_register is assigned through the function
    pci_set_drvdata without an error test,

(2) if the call to isp1760_register fails, the current function
    (isp1761_pci_probe) returns 0, and if it succeeds, it returns -ENOMEM,
    which seems odd.

Thus, we suggest to move the test before the call to pci_set_drvdata to
correct (1), and to turn it into a non IS_ERR test to correct (2).

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@bad_null_test@
expression x,E;
statement S1, S2;
@@
x =  isp1760_register(...)
... when != x = E
* if (x == NULL)
S1 else S2
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp1760-if.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/isp1760-if.c~drivers-usb-host-use-an-is_err-test-rather-than-a-null-test drivers/usb/host/isp1760-if.c
--- a/drivers/usb/host/isp1760-if.c~drivers-usb-host-use-an-is_err-test-rather-than-a-null-test
+++ a/drivers/usb/host/isp1760-if.c
@@ -232,9 +232,10 @@ static int __devinit isp1761_pci_probe(s
 	hcd = isp1760_register(pci_mem_phy0, length, dev->irq,
 		IRQF_SHARED | IRQF_DISABLED, &dev->dev, dev_name(&dev->dev),
 		devflags);
-	pci_set_drvdata(dev, hcd);
-	if (!hcd)
+	if (!IS_ERR(hcd)) {
+		pci_set_drvdata(dev, hcd);
 		return 0;
+	}
 clean:
 	status = -ENODEV;
 	iounmap(iobase);
_

Patches currently in -mm which might be from brunel@diku.dk are

git-sound.patch
git-gfs2.patch
git-ubifs.patch
drivers-usb-host-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch


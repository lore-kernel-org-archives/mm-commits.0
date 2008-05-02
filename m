From: akpm@linux-foundation.org
Subject: - pnp-fix-printk-format-warnings.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:47 -0700
Message-ID: <200805021942.m42JglsF011224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649AbYEBTnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bjorn.helgaas@hp.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     PNP: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     pnp-fix-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'

[joe@perches.com: fix it]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Joe Perches <joe@perches.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/rsparser.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,8 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode irq %llu\n",
+		(unsigned long long)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +603,8 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode dma %llu\n",
+		(unsigned long long)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
pnp-fix-missing-kernel-doc-notation.patch
x86-fix-setup-printk-format-warning.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-sched.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch


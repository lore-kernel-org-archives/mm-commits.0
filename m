From: akpm@linux-foundation.org
Subject: + pnp-fix-printk-format-warnings.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:20:54 -0700
Message-ID: <200804302120.m3ULKs9W003691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760326AbYD3VVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bjorn.helgaas@hp.com


The patch titled
     PNP: fix printk format warnings
has been added to the -mm tree.  Its filename is
     pnp-fix-printk-format-warnings.patch

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
Subject: PNP: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/rsparser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode irq %d\n", (int)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode dma %d\n", (int)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch


From: akpm@linux-foundation.org
Subject: + pnp-fix-printk-format-warnings-fix.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:27:46 -0700
Message-ID: <200804302127.m3ULRkRA004059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764935AbYD3V2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bjorn.helgaas@hp.com, randy.dunlap@oracle.com


The patch titled
     pnp-fix-printk-format-warnings-fix
has been added to the -mm tree.  Its filename is
     pnp-fix-printk-format-warnings-fix.patch

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
Subject: pnp-fix-printk-format-warnings-fix
From: Joe Perches <joe@perches.com>

On Wed, 2008-04-30 at 13:56 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
> next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'

resource_size_t can be u64
I think you need %llu/(unsigned long long)

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/rsparser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings-fix drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings-fix
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %d\n", (int)res->start);
+	dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long long)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %d\n", (int)res->start);
+	dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long long)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
pnp-fix-printk-format-warnings-fix.patch
git-cifs.patch
git-kvm.patch
git-unionfs.patch


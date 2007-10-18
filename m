From: akpm@linux-foundation.org
Subject: - avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:25 -0700
Message-ID: <200710180655.l9I6tPaY030607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760437AbXJRHPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnp: avoid a small unlikely memory leak in proc_read_escd()
has been removed from the -mm tree.  Its filename was
     avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pnp: avoid a small unlikely memory leak in proc_read_escd()
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a small and unlikely memory leak in
drivers/pnp/pnpbios/proc.c::proc_read_escd().  It's inside a sanity check,
so it probably won't trigger often (if at all), however it *is* a potential
leak and it's easy to avoid, so let's just fix it :)

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/proc.c~avoid-a-small-unlikely-memory-leak-in-proc_read_escd drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~avoid-a-small-unlikely-memory-leak-in-proc_read_escd
+++ a/drivers/pnp/pnpbios/proc.c
@@ -94,8 +94,9 @@ static int proc_read_escd(char *buf, cha
 
 	/* sanity check */
 	if (escd_size > MAX_SANE_ESCD_SIZE) {
-		printk(KERN_ERR
-		       "PnPBIOS: proc_read_escd: ESCD size reported by BIOS read_escd call is too great\n");
+		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by"
+				" BIOS read_escd call is too great\n");
+		kfree(tmpbuf);
 		return -EFBIG;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch

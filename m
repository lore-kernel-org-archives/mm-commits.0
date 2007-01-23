From: akpm@osdl.org
Subject: + fix-ppc64s-writing-to-struct-file_operations.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:28:15 -0800
Message-ID: <200701231928.l0NJSFbg028867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108AbXAWT3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:29:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, arjan@infradead.org, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Fix ppc64's writing to struct file_operations
has been added to the -mm tree.  Its filename is
     fix-ppc64s-writing-to-struct-file_operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix ppc64's writing to struct file_operations
From: Stephen Rothwell <sfr@canb.auug.org.au>

In preparation for marking file_operations as const.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/lparcfg.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/lparcfg.c~fix-ppc64s-writing-to-struct-file_operations arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~fix-ppc64s-writing-to-struct-file_operations
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -439,6 +439,10 @@ static ssize_t lparcfg_write(struct file
 
 	ssize_t retval = -ENOMEM;
 
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR) ||
+			firmware_has_feature(FW_FEATURE_ISERIES))
+		return -EINVAL;
+
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
 		goto out;
@@ -517,7 +521,7 @@ static int pseries_lparcfg_data(struct s
 static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 			     size_t count, loff_t * off)
 {
-	return count;
+	return -EINVAL;
 }
 
 #endif				/* CONFIG_PPC_PSERIES */
@@ -570,6 +574,7 @@ static int lparcfg_open(struct inode *in
 struct file_operations lparcfg_fops = {
 	.owner		= THIS_MODULE,
 	.read		= seq_read,
+	.write		= lparcfg_write,
 	.open		= lparcfg_open,
 	.release	= single_release,
 };
@@ -581,10 +586,8 @@ int __init lparcfg_init(void)
 
 	/* Allow writing if we have FW_FEATURE_SPLPAR */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR) &&
-			!firmware_has_feature(FW_FEATURE_ISERIES)) {
-		lparcfg_fops.write = lparcfg_write;
+			!firmware_has_feature(FW_FEATURE_ISERIES))
 		mode |= S_IWUSR;
-	}
 
 	ent = create_proc_entry("ppc64/lparcfg", mode, NULL);
 	if (ent) {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

fix-ppc64s-writing-to-struct-file_operations.patch

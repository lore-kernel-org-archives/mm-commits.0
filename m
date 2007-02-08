From: akpm@linux-foundation.org
Subject: - fix-ppc64s-writing-to-struct-file_operations.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:47:52 -0800
Message-ID: <200702080947.l189lq77010983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423133AbXBHJsP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, arjan@infradead.org, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Fix ppc64's writing to struct file_operations
has been removed from the -mm tree.  Its filename was
     fix-ppc64s-writing-to-struct-file_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix ppc64's writing to struct file_operations
From: Stephen Rothwell <sfr@canb.auug.org.au>

In preparation for marking file_operations as const.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/lparcfg.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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

git-powerpc.patch

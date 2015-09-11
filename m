From: akpm@linux-foundation.org
Subject: [merged] wil6210-use-seq_hex_dump-to-dump-buffers.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:13:16 -0700
Message-ID: <55f319bc.kPpJ2osl3Ge7C2Wu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbIKSNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/wireless/ath/wil6210: use seq_hex_dump() to dump buffers
has been removed from the -mm tree.  Its filename was
     wil6210-use-seq_hex_dump-to-dump-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/net/wireless/ath/wil6210: use seq_hex_dump() to dump buffers

Instead of custom approach let's use recently introduced seq_hex_dump()
helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/wil6210/debugfs.c |   35 +++----------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN drivers/net/wireless/ath/wil6210/debugfs.c~wil6210-use-seq_hex_dump-to-dump-buffers drivers/net/wireless/ath/wil6210/debugfs.c
--- a/drivers/net/wireless/ath/wil6210/debugfs.c~wil6210-use-seq_hex_dump-to-dump-buffers
+++ a/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -156,6 +156,12 @@ static const struct file_operations fops
 	.llseek		= seq_lseek,
 };
 
+static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
+			    const char *prefix)
+{
+	seq_hex_dump(s, prefix, DUMP_PREFIX_NONE, 16, 1, p, len, false);
+}
+
 static void wil_print_ring(struct seq_file *s, const char *prefix,
 			   void __iomem *off)
 {
@@ -212,8 +218,6 @@ static void wil_print_ring(struct seq_fi
 				   le16_to_cpu(hdr.seq), len,
 				   le16_to_cpu(hdr.type), hdr.flags);
 			if (len <= MAX_MBOXITEM_SIZE) {
-				int n = 0;
-				char printbuf[16 * 3 + 2];
 				unsigned char databuf[MAX_MBOXITEM_SIZE];
 				void __iomem *src = wmi_buffer(wil, d.addr) +
 					sizeof(struct wil6210_mbox_hdr);
@@ -223,16 +227,7 @@ static void wil_print_ring(struct seq_fi
 				 * reading header
 				 */
 				wil_memcpy_fromio_32(databuf, src, len);
-				while (n < len) {
-					int l = min(len - n, 16);
-
-					hex_dump_to_buffer(databuf + n, l,
-							   16, 1, printbuf,
-							   sizeof(printbuf),
-							   false);
-					seq_printf(s, "      : %s\n", printbuf);
-					n += l;
-				}
+				wil_seq_hexdump(s, databuf, len, "      : ");
 			}
 		} else {
 			seq_puts(s, "\n");
@@ -867,22 +862,6 @@ static const struct file_operations fops
 	.open  = simple_open,
 };
 
-static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
-			    const char *prefix)
-{
-	char printbuf[16 * 3 + 2];
-	int i = 0;
-
-	while (i < len) {
-		int l = min(len - i, 16);
-
-		hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
-				   sizeof(printbuf), false);
-		seq_printf(s, "%s%s\n", prefix, printbuf);
-		i += l;
-	}
-}

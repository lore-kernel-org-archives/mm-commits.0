From: akpm@linux-foundation.org
Subject: - proc-switch-proc-excite-unit_id-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:16 -0700
Message-ID: <200804300546.m3U5kGxd029604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758232AbYD3Frf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, ralf@linux-mips.org, thomas.koeller@baslerweb.com, mm-commits@vger.kernel.org


The patch titled
     proc: switch /proc/excite/unit_id to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-switch-proc-excite-unit_id-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch /proc/excite/unit_id to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/basler/excite/excite_procfs.c |   28 +++++++++++++++-------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN arch/mips/basler/excite/excite_procfs.c~proc-switch-proc-excite-unit_id-to-seq_file-interface arch/mips/basler/excite/excite_procfs.c
--- a/arch/mips/basler/excite/excite_procfs.c~proc-switch-proc-excite-unit_id-to-seq_file-interface
+++ a/arch/mips/basler/excite/excite_procfs.c
@@ -18,8 +18,9 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
+#include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <asm/page.h>
 #include <asm/io.h>
@@ -28,14 +29,25 @@
 
 #include <excite.h>
 
-static int excite_get_unit_id(char *buf, char **addr, off_t offs, int size)
+static int excite_unit_id_proc_show(struct seq_file *m, void *v)
 {
-	const int len = snprintf(buf, PAGE_SIZE, "%06x", unit_id);
-	const int w = len - offs;
-	*addr = buf + offs;
-	return w < size ? w : size;
+	seq_printf(m, "%06x", unit_id);
+	return 0;
 }
 
+static int excite_unit_id_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, excite_unit_id_proc_show, NULL);
+}
+
+static const struct file_operations excite_unit_id_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= excite_unit_id_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int
 excite_bootrom_read(char *page, char **start, off_t off, int count,
 		  int *eof, void *data)
@@ -69,8 +81,8 @@ void excite_procfs_init(void)
 	if (pdir) {
 		struct proc_dir_entry * e;
 
-		e = create_proc_info_entry("unit_id", S_IRUGO, pdir,
-					   excite_get_unit_id);
+		e = proc_create("unit_id", S_IRUGO, pdir,
+				&excite_unit_id_proc_fops);
 		if (e) e->size = 6;
 
 		e = create_proc_read_entry("bootrom", S_IRUGO, pdir,
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch


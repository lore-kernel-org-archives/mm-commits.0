From: akpm@linux-foundation.org
Subject: + proc-switch-proc-excite-unit_id-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:51 -0700
Message-ID: <200804102134.m3ALYpMN018475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbYDJVgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, ralf@linux-mips.org, thomas.koeller@baslerweb.com


The patch titled
     proc: switch /proc/excite/unit_id to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-switch-proc-excite-unit_id-to-seq_file-interface.patch

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

git-x86.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
proc-switch-proc-apm-to-seq_file-interface.patch
proc-remove-proc-mac_iop.patch
proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
proc-switch-proc-irda-irnet-to-seq_file-interface.patch
proc-convert-proc-bus-nubus-to-seq_file-interface.patch
proc-switch-proc-ip2mem-to-seq_file-interface.patch
proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
proc-remove-get_info-infrastructure.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch


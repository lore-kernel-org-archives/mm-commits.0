From: akpm@linux-foundation.org
Subject: + rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:24:25 -0700
Message-ID: <200803120424.m2C4OPBI009857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYCLEYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com


The patch titled
     rapidio: add RapidIO proc fs for memory mapping debugging
has been added to the -mm tree.  Its filename is
     rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch

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
Subject: rapidio: add RapidIO proc fs for memory mapping debugging
From: Zhang Wei <wei.zhang@freescale.com>

Get RapidIO space resource by catting /proc/riores.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig |    8 ++
 drivers/rapidio/rio.c   |  121 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)

diff -puN drivers/rapidio/Kconfig~rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging
+++ a/drivers/rapidio/Kconfig
@@ -9,4 +9,12 @@ config RAPIDIO_DISC_TIMEOUT
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
 
+config RAPIDIO_PROC_FS
+	bool "I/O and Memory resource debug"
+	depends on RAPIDIO && PROC_FS
+	default y
+	---help---
+	  Enable this option, it will create a /proc/riores node for
+	  monitoring the RapidIO I/O and Memory resource.
+
 source "drivers/rapidio/sallocator/Kconfig"
diff -puN drivers/rapidio/rio.c~rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging
+++ a/drivers/rapidio/rio.c
@@ -31,6 +31,9 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/dma-mapping.h>
 #include <linux/hardirq.h>
 
@@ -872,3 +875,121 @@ EXPORT_SYMBOL_GPL(rio_request_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_request_outb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_outb_mbox);
+
+#ifdef CONFIG_RAPIDIO_PROC_FS
+enum { MAX_IORES_LEVEL = 5 };
+
+struct riors {
+	struct rio_mport *mp;
+	int res;
+	struct resource *p;
+} riomres;
+
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	struct riors *rs = m->private;
+
+	(*pos)++;
+	if (p->child)
+		return p->child;
+	while (!p->sibling && p->parent)
+		p = p->parent;
+	if (p->sibling)
+		return p->sibling;
+	else {
+		rs->res++;
+		if (rs->res >= RIO_MAX_MPORT_RESOURCES) {
+			rs->mp = list_entry(rs->mp->node.next, struct rio_mport,
+					node);
+			rs->res = 0;
+			if (&rs->mp->node == &rio_mports)
+				return NULL;
+		}
+		seq_printf(m, "%2d: ", rs->res);
+		rs->p = &rs->mp->riores[rs->res];
+		p = rs->p;
+
+		return p;
+	}
+}
+
+static void *r_start(struct seq_file *m, loff_t *pos)
+{
+	struct riors *rs = m->private;
+	struct resource *p;
+
+	if (*pos) {
+		*pos = 0;
+		return NULL;
+	}
+
+	rs->mp = list_entry(rio_mports.next, struct rio_mport, node);
+	rs->res = -1;
+	rs->p = &rs->mp->iores;
+	p = rs->p;
+
+	seq_printf(m, "IO: ");
+
+	return p;
+}
+
+static void r_stop(struct seq_file *m, void *v)
+{
+}
+
+static int r_show(struct seq_file *m, void *v)
+{
+	struct riors *rs = m->private;
+	struct resource *root = rs->p;
+	struct resource *r = v, *p;
+	int width = root->end < 0x10000 ? 4 : 8;
+	int depth;
+
+	for (depth = 0, p = r; p->parent && depth < MAX_IORES_LEVEL; depth++,
+					p = p->parent)
+		if (p == root)
+			break;
+	seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
+			depth * 2, "",
+			width, (unsigned long long) r->start,
+			width, (unsigned long long) r->end,
+			r->name ? r->name : "<BAD>");
+	return 0;
+}
+
+static const struct seq_operations resource_op = {
+	.start	= r_start,
+	.next	= r_next,
+	.stop	= r_stop,
+	.show	= r_show,
+};
+
+static int riores_open(struct inode *inode, struct file *file)
+{
+	int res = seq_open(file, &resource_op);
+	if (!res) {
+		struct seq_file *m = file->private_data;
+		m->private = &riomres;
+	}
+	return res;
+}
+
+static const struct file_operations proc_riores_operations = {
+	.open		= riores_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init rioresources_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("riores", 0, NULL);
+	if (entry)
+		entry->proc_fops = &proc_riores_operations;
+	return 0;
+}
+__initcall(rioresources_init);
+#endif
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

rapidio-change-rio-function-mpc85xx_-to-fsl_.patch
rapidio-add-rapidio-option-to-kernel-configuration.patch
rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch
rapidio-add-rapidio-multi-mport-support.patch
rapidio-add-of-tree-support-to-rapidio-controller-driver.patch
rapidio-change-the-kernel-configurated-rapidio-system-size-to-auto-probing.patch
rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch
rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch
rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch
rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
git-async-tx.patch


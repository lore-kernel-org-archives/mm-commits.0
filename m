From: akpm@linux-foundation.org
Subject: - rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:31 -0700
Message-ID: <200804302225.m3UMPVYw006697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761029AbYD3W0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: add RapidIO proc fs for memory mapping debugging
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch

This patch was dropped because an updated version will be merged

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

origin.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch


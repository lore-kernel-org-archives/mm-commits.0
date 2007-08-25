From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:01 -0700
Message-ID: <200708250519.l7P5J1R8031929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938AbXHYFcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure: simplify statistics' debugfs read functions
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure: simplify statistics' debugfs read functions
From: Martin Peschke <mp3@de.ibm.com>

This patch replaces some ugly code implementing debugfs files.  The cleaned up
code uses seq_file.  File contents remains unchanged.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |  588 +++++++++++++++++++++-------------------------
 1 files changed, 275 insertions(+), 313 deletions(-)

diff -puN lib/statistic.c~statistics-infrastructure-simplify-statistics-debugfs-read-functions lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-simplify-statistics-debugfs-read-functions
+++ a/lib/statistic.c
@@ -57,31 +57,20 @@
 #include <linux/cpu.h>
 #include <linux/percpu.h>
 #include <linux/mutex.h>
+#include <linux/seq_file.h>
 #include <linux/statistic.h>
 
 #include <asm/bug.h>
 #include <asm/uaccess.h>
 
-struct statistic_file_private {
-	struct list_head read_seg_lh;
-	size_t w_offset;
-	char *w_buf;
-};
-
-struct statistic_merge_private {
-	struct statistic *stat;
-	spinlock_t lock;
-	void *dst;
-};
-
 /**
  * struct statistic_discipline - description of a data processing mode
  * @parse: parses additional attributes specific to this mode (if any)
  * @size: sizes a data area prior to allocation (mandatory)
  * @reset: discards content of a data area (mandatory)
  * @merge: merges content of a data area into another data area (mandatory)
- * @fdata: prints content of a data area into buffer (mandatory)
- * @fdef: prints additional attributes specific to this mode (if any)
+ * @def: prints additional attributes specific to this mode (if any)
+ * @data: prints content of a data area into buffer (mandatory)
  * @add: updates a data area for a statistic fed incremental data (mandatory)
  * @set: updates a data area for a statistic fed total numbers (mandatory)
  * @name: pointer to name string (mandatory)
@@ -104,9 +93,9 @@ struct statistic_discipline {
 	size_t (*size)(struct statistic * stat);
 	void (*reset)(struct statistic *stat, void *ptr);
 	void (*merge)(struct statistic *stat, void *dst, void *src);
-	int (*fdata)(struct statistic *stat, const char *name,
-		     struct statistic_file_private *fpriv, void *data);
-	int (*fdef)(struct statistic *stat, char *line);
+	void (*def)(struct statistic *stat, struct seq_file *seq);
+	void (*data)(struct statistic *stat, struct seq_file *seq,
+		     const char *name);
 	void (*add)(struct statistic *stat, s64 value, u64 incr);
 	void (*set)(struct statistic *stat, s64 value, u64 total);
 	char *name;
@@ -248,7 +237,13 @@ static int statistic_reset(struct statis
 	return 0;
 }
 
-static void statistic_merge(void *__mpriv)
+struct statistic_merge_private {
+	struct statistic *stat;
+	spinlock_t lock;
+	void *dst;
+};
+
+static void _statistic_merge(void *__mpriv)
 {
 	struct statistic_merge_private *mpriv = __mpriv;
 	struct statistic *stat = mpriv->stat;
@@ -260,121 +255,26 @@ static void statistic_merge(void *__mpri
 	spin_unlock(&mpriv->lock);
 }
 
-struct sgrb_seg {
-	struct list_head list;
-	char *address;
-	int offset;
-	int size;
-};
-
-static struct sgrb_seg *sgrb_seg_find(struct list_head *lh, int size)
-{
-	struct sgrb_seg *seg;
-
-	/* only the last buffer, if any, may have spare bytes */
-	list_for_each_entry_reverse(seg, lh, list) {
-		if (likely((PAGE_SIZE - seg->offset) >= size))
-			return seg;
-		break;
-	}
-	seg = kzalloc(sizeof(struct sgrb_seg), GFP_KERNEL);
-	if (unlikely(!seg))
-		return NULL;
-	seg->size = PAGE_SIZE;
-	seg->address = (void*)__get_free_page(GFP_KERNEL);
-	if (unlikely(!seg->address)) {
-		kfree(seg);
-		return NULL;
-	}
-	list_add_tail(&seg->list, lh);
-	return seg;
-}
-
-static void sgrb_seg_release_all(struct list_head *lh)
-{
-	struct sgrb_seg *seg, *tmp;
-
-	list_for_each_entry_safe(seg, tmp, lh, list) {
-		list_del(&seg->list);
-		free_page((unsigned long)seg->address);
-		kfree(seg);
-	}
-}
-
-static char *statistic_state_strings[] = {
-	"undefined(BUG)",
-	"unconfigured",
-	"released",
-	"off",
-	"on",
-};
-
-static int statistic_fdef(struct statistic_interface *interface, int i,
-			  struct statistic_file_private *private)
-{
-	struct statistic *stat = &interface->stat[i];
-	struct statistic_info *info = &interface->info[i];
-	struct statistic_discipline *disc = &statistic_discs[stat->type];
-	struct sgrb_seg *seg;
-	char t0[TIMESTAMP_SIZE], t1[TIMESTAMP_SIZE], t2[TIMESTAMP_SIZE];
-
-	seg = sgrb_seg_find(&private->read_seg_lh, 512);
-	if (unlikely(!seg))
-		return -ENOMEM;
-
-	seg->offset += sprintf(seg->address + seg->offset,
-			       "name=%s state=%s units=%s/%s",
-			       info->name, statistic_state_strings[stat->state],
-			       info->x_unit, info->y_unit);
-	if (stat->state == STATISTIC_STATE_UNCONFIGURED) {
-		seg->offset += sprintf(seg->address + seg->offset, "\n");
-		return 0;
-	}
-
-	seg->offset += sprintf(seg->address + seg->offset, " type=%s",
-			       disc->name);
-	if (info->flags & STATISTIC_FLAGS_NOFLEX)
-		seg->offset += sprintf(seg->address + seg->offset, "(fix)");
-
-	if (disc->fdef)
-		seg->offset += disc->fdef(stat, seg->address + seg->offset);
-	if (stat->state == STATISTIC_STATE_RELEASED) {
-		seg->offset += sprintf(seg->address + seg->offset, "\n");
-		return 0;
-	}
-
-	nsec_to_timestamp(t0, stat->age);
-	nsec_to_timestamp(t1, stat->started);
-	nsec_to_timestamp(t2, stat->stopped);
-	seg->offset += sprintf(seg->address + seg->offset,
-			       " data=%s started=%s stopped=%s\n", t0, t1, t2);
-	return 0;
-}
-
-static int statistic_fdata(struct statistic_interface *interface, int i,
-			   struct statistic_file_private *fpriv)
+static void *statistic_merge(struct statistic_interface *interface, int i)
 {
 	struct statistic *stat = &interface->stat[i];
 	struct statistic_info *info = &interface->info[i];
 	struct statistic_discipline *disc = &statistic_discs[stat->type];
 	struct statistic_merge_private mpriv;
 	size_t size = disc->size(stat);
-	int retval;
 
-	if (unlikely(stat->state < STATISTIC_STATE_OFF))
-		return 0;
-	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR))
-		return disc->fdata(stat, info->name, fpriv, stat->data);
 	mpriv.dst = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!mpriv.dst))
-		return -ENOMEM;
+		return NULL;
 	disc->reset(stat, mpriv.dst);
-	spin_lock_init(&mpriv.lock);
-	mpriv.stat = stat;
-	on_each_cpu(statistic_merge, &mpriv, 0, 1);
-	retval = disc->fdata(stat, info->name, fpriv, mpriv.dst);
-	kfree(mpriv.dst);
-	return retval;
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR))
+		disc->merge(stat, &mpriv.dst, stat->data);
+	else {
+		spin_lock_init(&mpriv.lock);
+		mpriv.stat = stat;
+		on_each_cpu(_statistic_merge, &mpriv, 0, 1);
+	}
+	return mpriv.dst;
 }
 
 /* cpu hotplug handling for per-cpu data */
@@ -578,150 +478,258 @@ static void statistic_parse_line(struct 
 
 /* sequential files comprising user interface */
 
-static int statistic_generic_open(struct inode *inode,
-		struct file *file, struct statistic_interface **interface,
-		struct statistic_file_private **private)
-{
-	*interface = inode->i_private;
-	BUG_ON(!interface);
-	*private = kzalloc(sizeof(struct statistic_file_private), GFP_KERNEL);
-	if (unlikely(!*private))
-		return -ENOMEM;
-	INIT_LIST_HEAD(&(*private)->read_seg_lh);
-	file->private_data = *private;
+struct statistic_seq_private {
+	struct statistic_interface *interface;
+	int i;
+	size_t w_offset;
+	char *w_buf;
+	struct statistic *stat;
+};
+
+static void *statistic_seq_traverse(struct seq_file *seq, loff_t *pos, int inc,
+				    struct statistic_seq_private *seq_priv)
+{
+	*pos += inc;
+	if (*pos >= seq_priv->interface->number)
+		return NULL;
+	seq_priv->i = *pos;
+	return seq_priv;
+}
+
+static void *statistic_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return statistic_seq_traverse(seq, pos, 0, seq->private);
+}
+
+static void *statistic_seq_next(struct seq_file *seq, void *_seq_priv, loff_t *pos)
+{
+	return statistic_seq_traverse(seq, pos, 1, _seq_priv);
+}
+
+static void statistic_seq_stop(struct seq_file *seq, void *_seq_priv)
+{
+}
+
+static char *statistic_state_strings[] = {
+	"undefined(BUG)",
+	"unconfigured",
+	"released",
+	"off",
+	"on",
+};
+
+static int statistic_seq_show_def(struct seq_file *seq, void *_seq_priv)
+{
+	struct statistic_seq_private *seq_priv = _seq_priv;
+	struct statistic_interface *interface = seq_priv->interface;
+	struct statistic *stat = &interface->stat[seq_priv->i];
+	struct statistic_info *info = &interface->info[seq_priv->i];
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	char t0[TIMESTAMP_SIZE], t1[TIMESTAMP_SIZE], t2[TIMESTAMP_SIZE];
+
+	seq_printf(seq, "name=%s", info->name);
+	seq_printf(seq, " state=%s", statistic_state_strings[stat->state]);
+	seq_printf(seq, " units=%s/%s", info->x_unit, info->y_unit);
+
+	if (stat->state == STATISTIC_STATE_UNCONFIGURED) {
+		seq_printf(seq, "\n");
+		return 0;
+	}
+
+	seq_printf(seq, " type=%s", disc->name);
+	if (info->flags & STATISTIC_FLAGS_NOFLEX)
+		seq_printf(seq, "(fix)");
+
+	if (disc->def)
+		disc->def(stat, seq);
+
+	if (stat->state == STATISTIC_STATE_RELEASED) {
+		seq_printf(seq, "\n");
+		return 0;
+	}
+
+	nsec_to_timestamp(t0, stat->age);
+	nsec_to_timestamp(t1, stat->started);
+	nsec_to_timestamp(t2, stat->stopped);
+	seq_printf(seq, " data=%s started=%s stopped=%s\n", t0, t1, t2);
 	return 0;
 }
 
-static int statistic_generic_close(struct inode *inode, struct file *file)
+static int statistic_seq_show_data(struct seq_file *seq, void *_seq_priv)
 {
-	struct statistic_file_private *private = file->private_data;
-	BUG_ON(!private);
-	sgrb_seg_release_all(&private->read_seg_lh);
-	kfree(private);
+	struct statistic_seq_private *seq_priv = _seq_priv;
+	struct statistic_interface *interface = seq_priv->interface;
+	struct statistic *stat = &seq_priv->stat[seq_priv->i];
+	struct statistic_info *info = &interface->info[seq_priv->i];
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+
+	if (stat->state >= STATISTIC_STATE_OFF)
+		disc->data(stat, seq, info->name);
 	return 0;
 }
 
-static ssize_t statistic_generic_read(struct file *file,
-				char __user *buf, size_t len, loff_t *offset)
+static struct seq_operations statistic_seq_ops_def = {
+	.start	= statistic_seq_start,
+	.stop	= statistic_seq_stop,
+	.next	= statistic_seq_next,
+	.show	= statistic_seq_show_def,
+};
+
+static struct seq_operations statistic_seq_ops_data = {
+	.start	= statistic_seq_start,
+	.stop	= statistic_seq_stop,
+	.next	= statistic_seq_next,
+	.show	= statistic_seq_show_data,
+};
+
+static int statistic_open_def(struct inode *inode, struct file *file)
 {
-	struct statistic_file_private *private = file->private_data;
-	struct sgrb_seg *seg;
-	size_t seg_offset, seg_residual, seg_transfer;
-	size_t transfered = 0;
-	loff_t pos = 0;
-
-	BUG_ON(!private);
-	list_for_each_entry(seg, &private->read_seg_lh, list) {
-		if (unlikely(!len))
-			break;
-		if (*offset >= pos && *offset <= (pos + seg->offset)) {
-			seg_offset = *offset - pos;
-			seg_residual = seg->offset - seg_offset;
-			seg_transfer = min(len, seg_residual);
-			if (unlikely(copy_to_user(buf + transfered,
-						  seg->address + seg_offset,
-						  seg_transfer)))
-				return -EFAULT;
-			transfered += seg_transfer;
-			*offset += seg_transfer;
-			pos += seg_transfer + seg_offset;
-			len -= seg_transfer;
-		} else
-			pos += seg->offset;
+	struct statistic_seq_private *seq_priv;
+	struct seq_file *seq;
+	int retval;
+
+	seq_priv = kzalloc(sizeof(struct statistic_seq_private), GFP_KERNEL);
+	if (!seq_priv)
+		return -ENOMEM;
+	seq_priv->interface = inode->i_private;
+	retval = seq_open(file, &statistic_seq_ops_def);
+	if (!retval) {
+		seq = file->private_data;
+		seq->private = seq_priv;
+	} else
+		kfree(seq_priv);
+	return retval;
+}
+
+static int statistic_release_def(struct inode *inode, struct file *file)
+{
+	struct statistic_interface *interface = inode->i_private;
+	struct seq_file *seq = file->private_data;
+	struct statistic_seq_private *seq_priv = seq->private;
+	char *p, *q = seq_priv->w_buf;
+
+	if (seq_priv->w_buf) {
+		while ((p = strsep(&q, "\n")))
+			statistic_parse_line(interface, p);
+		kfree(seq_priv->w_buf);
 	}
-	return transfered;
+	return seq_release_private(inode, file);
 }
 
-static ssize_t statistic_def_write(struct file *file, const char __user *buf,
+static ssize_t statistic_write_def(struct file *file, const char __user *buf,
 				   size_t len, loff_t *offset)
 {
-	struct statistic_file_private *private = file->private_data;
+	struct seq_file *seq = file->private_data;
+	struct statistic_seq_private *seq_priv = seq->private;
 	char *larger;
 
-	if (unlikely(*offset != private->w_offset))
+	if (unlikely(*offset != seq_priv->w_offset))
 		return -EPIPE;
 	if (*offset + len > 16 * PAGE_SIZE)
 		return -ENOMEM;
 	larger = kmalloc(*offset + len, GFP_KERNEL);
 	if (!larger)
 		return -ENOMEM;
-	memcpy(larger, private->w_buf, *offset);
+	memcpy(larger, seq_priv->w_buf, *offset);
 	if (copy_from_user(larger + *offset, buf, len))
 		return -EFAULT;
 	*offset += len;
-	kfree(private->w_buf);
-	private->w_buf = larger;
-	private->w_offset = *offset;
+	kfree(seq_priv->w_buf);
+	seq_priv->w_buf = larger;
+	seq_priv->w_offset = *offset;
 	return len;
 }
 
-static int statistic_def_close(struct inode *inode, struct file *file)
+static struct file_operations statistic_def_fops = {
+	.owner		= THIS_MODULE,
+	.open		= statistic_open_def,
+	.release	= statistic_release_def,
+	.write		= statistic_write_def,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static int statistic_open_data(struct inode *inode, struct file *file)
 {
 	struct statistic_interface *interface = inode->i_private;
-	struct statistic_file_private *private = file->private_data;
-	char *p, *q = private->w_buf;
+	struct statistic *stat;
+	struct statistic_discipline *disc;
+	struct statistic_seq_private *seq_priv;
+	struct seq_file *seq;
+	int size, i, j, retval = -ENOMEM;
 
-	while ((p = strsep(&q, "\n")))
-		statistic_parse_line(interface, p);
-	kfree(private->w_buf);
-	return 0;
-}
+	if (interface->pull)
+		interface->pull(interface->pull_private);
 
-static int statistic_def_open(struct inode *inode, struct file *file)
-{
-	struct statistic_interface *interface;
-	struct statistic_file_private *private;
-	int retval = 0;
-	int i;
+	size = interface->number * sizeof(struct statistic);
+	seq_priv = kzalloc(sizeof(struct statistic_seq_private), GFP_KERNEL);
+	if (!seq_priv)
+		goto failed_priv;
+
+	seq_priv->interface = interface;
+	seq_priv->stat = stat = kmalloc(size, GFP_KERNEL);
+	if (!stat)
+		goto failed_stat;
 
-	retval = statistic_generic_open(inode, file, &interface, &private);
-	if (unlikely(retval))
-		return retval;
+	memcpy(stat, interface->stat, size);
 	for (i = 0; i < interface->number; i++) {
-		retval = statistic_fdef(interface, i, private);
-		if (unlikely(retval)) {
-			statistic_def_close(inode, file);
-			break;
-		}
+		if (stat[i].state < STATISTIC_STATE_OFF)
+			continue;
+		stat[i].data = statistic_merge(interface, i);
+		if (!stat[i].data)
+			goto failed_merge;
 	}
+
+	retval = seq_open(file, &statistic_seq_ops_data);
+	if (retval)
+		goto failed_open;
+
+	seq = file->private_data;
+	seq->private = seq_priv;
+	return 0;
+
+failed_open:
+	for (j = 0; j < i; j++) {
+		if (stat[j].state < STATISTIC_STATE_OFF)
+			continue;
+		disc = &statistic_discs[stat[j].type];
+		disc->reset(&stat[j], stat[j].data);
+		kfree(stat[j].data);
+	}
+failed_merge:
+	kfree(stat);
+failed_stat:
+	kfree(seq_priv);
+failed_priv:
 	return retval;
 }
 
-static int statistic_data_open(struct inode *inode, struct file *file)
+static int statistic_release_data(struct inode *inode, struct file *file)
 {
-	struct statistic_interface *interface;
-	struct statistic_file_private *private;
-	int retval = 0;
+	struct seq_file *seq = file->private_data;
+	struct statistic_seq_private *seq_priv = seq->private;
+	struct statistic_interface *interface = seq_priv->interface;
+	struct statistic *stat = seq_priv->stat;
+	struct statistic_discipline *disc;
 	int i;
 
-	retval = statistic_generic_open(inode, file, &interface, &private);
-	if (unlikely(retval))
-		return retval;
-	if (interface->pull)
-		interface->pull(interface->pull_private);
 	for (i = 0; i < interface->number; i++) {
-		retval = statistic_fdata(interface, i, private);
-		if (unlikely(retval)) {
-			statistic_generic_close(inode, file);
-			break;
-		}
+		if (stat[i].state < STATISTIC_STATE_OFF)
+			continue;
+		disc = &statistic_discs[stat[i].type];
+		disc->reset(&stat[i], stat[i].data);
+		kfree(stat[i].data);
 	}
-	return retval;
+	kfree(stat);
+	return seq_release_private(inode, file);
 }
 
-static struct file_operations statistic_def_fops = {
-	.owner		= THIS_MODULE,
-	.read		= statistic_generic_read,
-	.write		= statistic_def_write,
-	.open		= statistic_def_open,
-	.release	= statistic_def_close,
-};
-
 static struct file_operations statistic_data_fops = {
 	.owner		= THIS_MODULE,
-	.read		= statistic_generic_read,
-	.open		= statistic_data_open,
-	.release	= statistic_generic_close,
+	.open		= statistic_open_data,
+	.release	= statistic_release_data,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
 };
 
 /* code concerned with single value statistics */
@@ -770,17 +778,10 @@ static void statistic_merge_counter(stru
 	*(u64*)dst += *(u64*)src;
 }
 
-static int statistic_fdata_counter(struct statistic *stat, const char *name,
-				   struct statistic_file_private *fpriv,
-				   void *data)
-{
-	struct sgrb_seg *seg;
-	seg = sgrb_seg_find(&fpriv->read_seg_lh, 128);
-	if (unlikely(!seg))
-		return -ENOMEM;
-	seg->offset += sprintf(seg->address + seg->offset, "%s %Lu\n",
-			       name, *(unsigned long long *)data);
-	return 0;
+static void statistic_data_counter(struct statistic *stat, struct seq_file *seq,
+				   const char *name)
+{
+	seq_printf(seq, "%s %Lu\n", name, *(unsigned long long *)stat->data);
 }
 
 /* code concerned with utilisation indicator statistic */
@@ -863,34 +864,21 @@ static int statistic_div(signed long lon
 	return 0;
 }
 
-static int statistic_fdata_util(struct statistic *stat, const char *name,
-				struct statistic_file_private *fpriv,
-				void *data)
+static void statistic_data_util(struct statistic *stat, struct seq_file *seq,
+				const char *name)
 {
-	struct sgrb_seg *seg;
-	struct statistic_entry_util *util = data;
+	struct statistic_entry_util *util = stat->data;
 	unsigned long long mean_w = 0, mean_d = 0, var_w = 0, var_d = 0,
 			   num = util->num, acc = util->acc, sqr = util->sqr;
 	signed long long min = num ? util->min : 0,
 			 max = num ? util->max : 0;
 
-	seg = sgrb_seg_find(&fpriv->read_seg_lh, 512);
-	if (unlikely(!seg))
-		return -ENOMEM;
 	statistic_div(&mean_w, &mean_d, acc, num, 3);
 	statistic_div(&var_w, &var_d, sqr - mean_w * mean_w, num, 3);
-	seg->offset += sprintf(seg->address + seg->offset,
-			       "%s samples %Lu\n"
-			       "%s minimum %Ld\n"
-			       "%s average %Ld.%03Ld\n"
-			       "%s maximum %Ld\n"
-			       "%s variance %Ld.%03Ld\n",
-			       name, num,
-			       name, min,
-			       name, mean_w, mean_d,
-			       name, max,
-			       name, var_w, var_d);
-	return 0;
+	seq_printf(seq, "%s samples %Lu\n%s minimum %Ld\n"
+		   "%s average %Ld.%03Ld\n%s maximum %Ld\n"
+		   "%s variance %Ld.%03Ld\n", name, num, name, min,
+		   name, mean_w, mean_d, name, max, name, var_w, var_d);
 }
 
 /* code concerned with histogram statistics */
@@ -985,43 +973,28 @@ static void statistic_merge_histogram(st
 		dst[i] += src[i];
 }
 
-static int statistic_fdata_histogram_line(const char *name,
-					struct statistic_file_private *private,
-					const char *prefix, s64 bound, u64 hits)
-{
-	struct sgrb_seg *seg;
-	seg = sgrb_seg_find(&private->read_seg_lh, 256);
-	if (unlikely(!seg))
-		return -ENOMEM;
-	seg->offset += sprintf(seg->address + seg->offset, "%s %s%Ld %Lu\n",
-			       name, prefix, (signed long long)bound,
-			       (unsigned long long)hits);
-	return 0;
-}
-
-static int statistic_fdata_histogram(struct statistic *stat, const char *name,
-				     struct statistic_file_private *fpriv,
-				     void *data)
+static void statistic_data_histogram(struct statistic *stat,
+				     struct seq_file *seq, const char *name)
 {
-	int i, retval;
-	s64 bound = 0;
+	int i;
+	signed long long bound = 0;
+	unsigned long long hits = 0;
+
 	for (i = 0; i < (stat->u.histogram.last_index); i++) {
 		bound = statistic_histogram_calc_value(stat, i);
-		retval = statistic_fdata_histogram_line(name, fpriv, "<=",
-							bound, ((u64*)data)[i]);
-		if (unlikely(retval))
-			return retval;
+		hits = ((u64*)stat->data)[i];
+		seq_printf(seq, "%s <=%Ld %Lu\n", name, bound, hits);
 	}
-	return statistic_fdata_histogram_line(name, fpriv, ">",
-					      bound, ((u64*)data)[i]);
+	seq_printf(seq, "%s >%Ld %Lu\n", name, bound, hits);
 }
 
-static int statistic_fdef_histogram(struct statistic *stat, char *line)
+static void statistic_def_histogram(struct statistic *stat,
+				    struct seq_file *seq)
 {
-	return sprintf(line, " range_min=%Li entries=%Li base_interval=%Lu",
-		       (signed long long)stat->u.histogram.range_min,
-		       (unsigned long long)(stat->u.histogram.last_index + 1),
-		       (unsigned long long)stat->u.histogram.base_interval);
+	seq_printf(seq, " range_min=%Li entries=%Li base_interval=%Lu",
+		   (signed long long)stat->u.histogram.range_min,
+		   (unsigned long long)(stat->u.histogram.last_index + 1),
+		   (unsigned long long)stat->u.histogram.base_interval);
 }
 
 static match_table_t statistic_match_histogram = {
@@ -1191,34 +1164,23 @@ static void statistic_merge_sparse(struc
 		_statistic_add_sparse(dst, entry->value, entry->hits);
 }
 
-static int statistic_fdata_sparse(struct statistic *stat, const char *name,
-				  struct statistic_file_private *fpriv,
-				  void *data)
+static void statistic_data_sparse(struct statistic *stat, struct seq_file *seq,
+				  const char *name)
 {
-	struct sgrb_seg *seg;
-	struct statistic_sparse_list *slist = data;
+	struct statistic_sparse_list *slist = stat->data;
 	struct statistic_entry_sparse *entry;
 
-	seg = sgrb_seg_find(&fpriv->read_seg_lh, 256);
-	if (unlikely(!seg))
-		return -ENOMEM;
-	seg->offset += sprintf(seg->address + seg->offset, "%s missed 0x%Lu\n",
-			       name, (unsigned long long)slist->hits_missed);
-	list_for_each_entry(entry, &slist->entry_lh, list) {
-		seg = sgrb_seg_find(&fpriv->read_seg_lh, 256);
-		if (unlikely(!seg))
-			return -ENOMEM;
-		seg->offset += sprintf(seg->address + seg->offset,
-				       "%s 0x%Lx %Lu\n", name,
-				       (signed long long)entry->value,
-				       (unsigned long long)entry->hits);
-	}
-	return 0;
+	seq_printf(seq, "%s missed 0x%Lu\n", name,
+		   (unsigned long long)slist->hits_missed);
+	list_for_each_entry(entry, &slist->entry_lh, list)
+		seq_printf(seq, "%s 0x%Lx %Lu\n", name,
+			   (signed long long)entry->value,
+			   (unsigned long long)entry->hits);
 }
 
-static int statistic_fdef_sparse(struct statistic *stat, char *line)
+static void statistic_def_sparse(struct statistic *stat, struct seq_file *seq)
 {
-	return sprintf(line, " entries=%u", stat->u.sparse.entries_max);
+	seq_printf(seq, " entries=%u", stat->u.sparse.entries_max);
 }
 
 static match_table_t statistic_match_sparse = {
@@ -1249,7 +1211,7 @@ static struct statistic_discipline stati
 		.size	= statistic_size_counter,
 		.reset	= statistic_reset_counter,
 		.merge	= statistic_merge_counter,
-		.fdata	= statistic_fdata_counter,
+		.data	= statistic_data_counter,
 		.add	= statistic_add_counter_inc,
 		.set	= statistic_set_counter_inc,
 		.name	= "counter_inc",
@@ -1258,7 +1220,7 @@ static struct statistic_discipline stati
 		.size	= statistic_size_counter,
 		.reset	= statistic_reset_counter,
 		.merge	= statistic_merge_counter,
-		.fdata	= statistic_fdata_counter,
+		.data	= statistic_data_counter,
 		.add	= statistic_add_counter_prod,
 		.set	= statistic_set_counter_prod,
 		.name	= "counter_prod",
@@ -1267,7 +1229,7 @@ static struct statistic_discipline stati
 		.size	= statistic_size_util,
 		.reset	= statistic_reset_util,
 		.merge	= statistic_merge_util,
-		.fdata	= statistic_fdata_util,
+		.data	= statistic_data_util,
 		.add	= statistic_add_util,
 		.set	= statistic_set_util,
 		.name	= "utilisation",
@@ -1277,8 +1239,8 @@ static struct statistic_discipline stati
 		.size	= statistic_size_histogram,
 		.reset	= statistic_reset_histogram,
 		.merge	= statistic_merge_histogram,
-		.fdata	= statistic_fdata_histogram,
-		.fdef	= statistic_fdef_histogram,
+		.def	= statistic_def_histogram,
+		.data	= statistic_data_histogram,
 		.add	= statistic_add_histogram_lin,
 		.set	= statistic_set_histogram_lin,
 		.name	= "histogram_lin",
@@ -1288,8 +1250,8 @@ static struct statistic_discipline stati
 		.size	= statistic_size_histogram,
 		.reset	= statistic_reset_histogram,
 		.merge	= statistic_merge_histogram,
-		.fdata	= statistic_fdata_histogram,
-		.fdef	= statistic_fdef_histogram,
+		.def	= statistic_def_histogram,
+		.data	= statistic_data_histogram,
 		.add	= statistic_add_histogram_log2,
 		.set	= statistic_set_histogram_log2,
 		.name	= "histogram_log2",
@@ -1299,8 +1261,8 @@ static struct statistic_discipline stati
 		.size	= statistic_size_sparse,
 		.reset	= statistic_reset_sparse,
 		.merge	= statistic_merge_sparse,
-		.fdata	= statistic_fdata_sparse,
-		.fdef	= statistic_fdef_sparse,
+		.def	= statistic_def_sparse,
+		.data	= statistic_data_sparse,
 		.add	= statistic_add_sparse,
 		.set	= statistic_set_sparse,
 		.name	= "sparse",
_

Patches currently in -mm which might be from mp3@de.ibm.com are

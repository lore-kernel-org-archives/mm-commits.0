From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-simplify-statistics-debugfs-write-function.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:04 -0700
Message-ID: <200708250519.l7P5J4YR031939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbXHYFcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     simplify statistics' debugfs write function
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-simplify-statistics-debugfs-write-function.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: simplify statistics' debugfs write function
From: Martin Peschke <mp3@de.ibm.com>

The old code was unnecessarily complex and hard to maintain.

This rewrite disposes of an issue in the old code (probably an
off-by-one bug), seen with the readahead statistics prototype patch
reported by Fengguang Wu.

Patch is against 2.6.21-rc3-mm2.

# uname -a
Linux intel 2.6.21-rc3-mm2 #3 SMP Thu Mar 8 23:28:58 CST 2007 x86_64 GNU/Linux
# echo state=on > /debug/statistics/readahead/definition
[  694.286926] Unable to handle kernel paging request at ffff80ffa7457a5a RIP:
[  694.287378]  [<ffffffff8115228c>] strnchr+0x2c/0x40
[  694.287946] PGD 0
[  694.288117] Oops: 0000 [1] SMP
[  694.288345] last sysfs file: block/hda/dev
[  694.288624] CPU 0
[  694.288785] Modules linked in:
[  694.289026] Pid: 1051, comm: zsh Not tainted 2.6.21-rc3-mm2 #3
[  694.289367] RIP: 0010:[<ffffffff8115228c>]  [<ffffffff8115228c>] strnchr+0x2c/0x40
[  694.289835] RSP: 0018:ffff810002669e28  EFLAGS: 00000217
[  694.290147] RAX: ffff81000260bca8 RBX: ffff81000260bca8 RCX: 000000005aa5a5ae
[  694.290456] RDX: 000000000000000a RSI: 000000005aa5a5af RDI: ffff80ffa7457a5a
[  694.290784] RBP: ffff810002669e28 R08: 0000000000000001 R09: 0000000000000000
[  694.291107] R10: ffff81000260bca8 R11: 0000000000000020 R12: 0000000000000008
[  694.291452] R13: 00000000a55a5a5a R14: ffff81000260bd18 R15: ffff810002669e68
[  694.291791] FS:  00002b33b4955e90(0000) GS:ffffffff81420000(0000) knlGS:0000000000000000
[  694.292156] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  694.292420] CR2: ffff80ffa7457a5a CR3: 00000000026b6000 CR4: 00000000000006e0
[  694.292768] Process zsh (pid: 1051, threadinfo ffff810002668000, task ffff81000262a100)
[  694.293123] Stack:  ffff810002669ea8 ffffffff8116561c 0000000000000009 ffff8100026bbe58
[  694.293576]  ffff810001ee37f8 ffff810002674e60 ffffffff813eb280 0000000000000000
[  694.293972]  ffff810002669e68 ffff810002669e68 0000000800000000 0000000000000008
[  694.294341] Call Trace:
[  694.294495]  [<ffffffff8116561c>] statistic_def_close+0x9c/0x180
[  694.294793]  [<ffffffff81013582>] __fput+0xd2/0x1b0
[  694.295026]  [<ffffffff8102fdd4>] fput+0x14/0x20
[  694.295253]  [<ffffffff81025ca3>] filp_close+0x73/0x90
[  694.295498]  [<ffffffff8104baf8>] sys_dup2+0x148/0x190
[  694.295752]  [<ffffffff8106411e>] system_call+0x7e/0x83

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |  111 ++++++++++------------------------------------
 1 file changed, 26 insertions(+), 85 deletions(-)

diff -puN lib/statistic.c~statistics-infrastructure-simplify-statistics-debugfs-write-function lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-simplify-statistics-debugfs-write-function
+++ a/lib/statistic.c
@@ -64,8 +64,8 @@
 
 struct statistic_file_private {
 	struct list_head read_seg_lh;
-	struct list_head write_seg_lh;
-	size_t write_seg_total_size;
+	size_t w_offset;
+	char *w_buf;
 };
 
 struct statistic_merge_private {
@@ -576,30 +576,6 @@ static void statistic_parse_line(struct 
 	kfree(name);
 }
 
-static void statistic_parse(struct statistic_interface *interface,
-			    struct list_head *line_lh, size_t line_size)
-{
-	struct sgrb_seg *seg, *tmp;
-	char *buf;
-	int offset = 0;
-
-	if (unlikely(!line_size))
-		return;
-	buf = kmalloc(line_size + 2, GFP_KERNEL);
-	if (unlikely(!buf))
-		return;
-	buf[line_size] = ' ';
-	buf[line_size + 1] = '\0';
-	list_for_each_entry_safe(seg, tmp, line_lh, list) {
-		memcpy(buf + offset, seg->address, seg->size);
-		offset += seg->size;
-		list_del(&seg->list);
-		kfree(seg);
-	}
-	statistic_parse_line(interface, buf);
-	kfree(buf);
-}
-
 /* sequential files comprising user interface */
 
 static int statistic_generic_open(struct inode *inode,
@@ -612,7 +588,6 @@ static int statistic_generic_open(struct
 	if (unlikely(!*private))
 		return -ENOMEM;
 	INIT_LIST_HEAD(&(*private)->read_seg_lh);
-	INIT_LIST_HEAD(&(*private)->write_seg_lh);
 	file->private_data = *private;
 	return 0;
 }
@@ -622,7 +597,6 @@ static int statistic_generic_close(struc
 	struct statistic_file_private *private = file->private_data;
 	BUG_ON(!private);
 	sgrb_seg_release_all(&private->read_seg_lh);
-	sgrb_seg_release_all(&private->write_seg_lh);
 	kfree(private);
 	return 0;
 }
@@ -658,72 +632,39 @@ static ssize_t statistic_generic_read(st
 	return transfered;
 }
 
-static ssize_t statistic_generic_write(struct file *file,
-			const char __user *buf, size_t len, loff_t *offset)
+static ssize_t statistic_def_write(struct file *file, const char __user *buf,
+				   size_t len, loff_t *offset)
 {
 	struct statistic_file_private *private = file->private_data;
-	struct sgrb_seg *seg;
-	size_t seg_residual, seg_transfer;
-	size_t transfered = 0;
+	char *larger;
 
-	BUG_ON(!private);
-	if (unlikely(*offset != private->write_seg_total_size))
+	if (unlikely(*offset != private->w_offset))
 		return -EPIPE;
-	while (len) {
-		seg = sgrb_seg_find(&private->write_seg_lh, 1);
-		if (unlikely(!seg))
-			return -ENOMEM;
-		seg_residual = seg->size - seg->offset;
-		seg_transfer = min(len, seg_residual);
-		if (unlikely(copy_from_user(seg->address + seg->offset,
-					    buf + transfered, seg_transfer)))
-			return -EFAULT;
-		private->write_seg_total_size += seg_transfer;
-		seg->offset += seg_transfer;
-		transfered += seg_transfer;
-		*offset += seg_transfer;
-		len -= seg_transfer;
-	}
-	return transfered;
+	if (*offset + len > 16 * PAGE_SIZE)
+		return -ENOMEM;
+	larger = kmalloc(*offset + len, GFP_KERNEL);
+	if (!larger)
+		return -ENOMEM;
+	memcpy(larger, private->w_buf, *offset);
+	if (copy_from_user(larger + *offset, buf, len))
+		return -EFAULT;
+	*offset += len;
+	kfree(private->w_buf);
+	private->w_buf = larger;
+	private->w_offset = *offset;
+	return len;
 }
 
 static int statistic_def_close(struct inode *inode, struct file *file)
 {
 	struct statistic_interface *interface = inode->i_private;
 	struct statistic_file_private *private = file->private_data;
-	struct sgrb_seg *seg, *seg_nl;
-	int offset;
-	LIST_HEAD(line_lh);
-	char *nl;
-	size_t line_size = 0;
-
-	list_for_each_entry(seg, &private->write_seg_lh, list) {
-		for (offset = 0; offset < seg->offset; offset += seg_nl->size) {
-			seg_nl = kmalloc(sizeof(struct sgrb_seg), GFP_KERNEL);
-			if (unlikely(!seg_nl))
-				goto out;
-			seg_nl->address = seg->address + offset;
-			nl = strnchr(seg_nl->address,
-				     seg->offset - offset, '\n');
-			if (nl) {
-				seg_nl->offset = nl - seg_nl->address;
-				if (seg_nl->offset)
-					seg_nl->offset--;
-			} else
-				seg_nl->offset = seg->offset - offset;
-			seg_nl->size = seg_nl->offset + 1;
-			line_size += seg_nl->size;
-			list_add_tail(&seg_nl->list, &line_lh);
-			if (nl) {
-				statistic_parse(interface, &line_lh, line_size);
-				line_size = 0;
-			}
-		}
-	}
-out:
-	if (!list_empty(&line_lh))
-		statistic_parse(interface, &line_lh, line_size);
-	return statistic_generic_close(inode, file);
+	char *p, *q = private->w_buf;
+
+	while ((p = strsep(&q, "\n")))
+		statistic_parse_line(interface, p);
+	kfree(private->w_buf);
+	return 0;
 }
 
 static int statistic_def_open(struct inode *inode, struct file *file)
@@ -771,7 +712,7 @@ static int statistic_data_open(struct in
 static struct file_operations statistic_def_fops = {
 	.owner		= THIS_MODULE,
 	.read		= statistic_generic_read,
-	.write		= statistic_generic_write,
+	.write		= statistic_def_write,
 	.open		= statistic_def_open,
 	.release	= statistic_def_close,
 };
_

Patches currently in -mm which might be from mp3@de.ibm.com are

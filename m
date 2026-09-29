Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8442D3B83F9
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790716407; cv=none; b=c954jilQE6jcAJ19Hh0T2JVLMHb6PHwsHAwXhnqSRub0gCzHYcy79A4a/bVN1o32uCTMqV/qeU0JxqEA/ZcxFZHNwCkcLEOszaJgmzPMNXTpFm4vX7pRGL5KgLHhBDuOtP5NLKvZqAYJCPrjbxJjkSRhYNHWNLO1B1D70sdoRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790716407; c=relaxed/simple;
	bh=sxE6EwYzus1GssTUTr/E/NrFQUzeS5swqpU+L1xa3PA=;
	h=Date:To:From:Subject:Message-Id; b=qKRdV6ibeFjz2RJsu6m4nshBZLX8on9jaAqBrDyc7yI3Kp0WR0aJfoYZzPWmBa4SdYMKjJ1hTblFGlBnfQ0W5/wC1hWvYqj4MbRs/aVZKbcqQohIT5H8DAnSjUDSMazwpj+PUjPIN7FZ6A+6NfTtk10aOOR9jXILNfvwg/eSsys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nynqS5k+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nynqS5k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8461F000FF;
	Tue, 29 Sep 2026 21:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790716405;
	bh=XeR3cIKEhwZ0mU6II0gc/g8MeFa9Ksw6H6n+iU+hfgw=;
	h=Date:To:From:Subject;
	b=nynqS5k+6as2Oa9B/rnAddhqZe2KDP2cmFamPu3jDJwp+BDFnRPorEEmOIiVqMFhq
	 PjNVdIg+ZPqI9l2ccB5bN9F2X68Z5/KsCzSz6SPkoJQ+cVLco+hANDttJbt9QgrWej
	 sAHlie/icgy0U9xZ8CoODl8N6orY265GXD3UfMZo=
Date: Tue, 29 Sep 2026 14:13:24 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,pooyan.azadparvar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-short-reads-from-block_state.patch added to mm-new branch
Message-Id: <20260929211324.EE8461F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix short reads from block_state
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-short-reads-from-block_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-short-reads-from-block_state.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pooyan Azad <pooyan.azadparvar@gmail.com>
Subject: zram: fix short reads from block_state
Date: Tue, 29 Sep 2026 09:18:46 +0200

read_block_state() formats each entry directly into the buffer supplied by
read().  If the remaining buffer is too small for one complete record,
snprintf() returns the full record length and the function stops without
copying data or advancing the file position.  A read from this debugfs
file which is smaller than a record therefore returns zero at a non-EOF
position and cannot make progress.

Convert block_state to seq_file so formatted records are buffered
independently of the userspace read size.  Keep dev_lock held across each
seq_file iteration and continue to protect individual entries with their
slot locks.

Link: https://lore.kernel.org/20260929071846.24829-1-pooyan.azadparvar@gmail.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Pooyan Azad <pooyan.azadparvar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/r/CANC3H+LdtoydSp+o2ecErAw7k6R2+gRf9LyxcaoHv_mGhJmyQQ@mail.gmail.com/
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---

 drivers/block/zram/zram_drv.c |  104 ++++++++++++++++----------------
 1 file changed, 53 insertions(+), 51 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-short-reads-from-block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -1553,68 +1553,70 @@ static void zram_debugfs_destroy(void)
 	debugfs_remove_recursive(zram_debugfs_root);
 }
 
-static ssize_t read_block_state(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+static void *zram_block_state_start(struct seq_file *seq, loff_t *pos)
 {
-	char *kbuf;
-	unsigned long index;
-	ssize_t written = 0;
-	struct zram *zram = file->private_data;
+	struct zram *zram = seq->private;
 	unsigned long nr_pages;
 
-	kbuf = kvmalloc(count, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-
-	guard(rwsem_read)(&zram->dev_lock);
-	if (!init_done(zram)) {
-		kvfree(kbuf);
-		return -EINVAL;
-	}
+	down_read(&zram->dev_lock);
+	if (!init_done(zram))
+		return ERR_PTR(-EINVAL);
 
 	nr_pages = zram->disksize >> PAGE_SHIFT;
+	if (*pos >= nr_pages)
+		return NULL;
 
-	for (index = *ppos; index < nr_pages; index++) {
-		int copied;
+	return pos;
+}
 
-		slot_lock(zram, index);
-		if (!slot_allocated(zram, index))
-			goto next;
-
-		copied = snprintf(kbuf + written, count,
-			"%12lu %12u.%06d %c%c%c%c%c%c\n",
-			index, zram->table[index].attr.ac_time, 0,
-			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
-			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
-			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-			test_slot_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
-			get_slot_comp_priority(zram, index) ? 'r' : '.',
-			test_slot_flag(zram, index,
-				       ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
-
-		if (count <= copied) {
-			slot_unlock(zram, index);
-			break;
-		}
-		written += copied;
-		count -= copied;
-next:
-		slot_unlock(zram, index);
-		*ppos += 1;
-	}
+static void *zram_block_state_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct zram *zram = seq->private;
+	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+
+	++*pos;
+	if (*pos >= nr_pages)
+		return NULL;
+
+	return pos;
+}
 
-	if (copy_to_user(buf, kbuf, written))
-		written = -EFAULT;
-	kvfree(kbuf);
+static void zram_block_state_stop(struct seq_file *seq, void *v)
+{
+	struct zram *zram = seq->private;
+
+	up_read(&zram->dev_lock);
+}
+
+static int zram_block_state_show(struct seq_file *seq, void *v)
+{
+	struct zram *zram = seq->private;
+	unsigned long index = *(loff_t *)v;
+
+	slot_lock(zram, index);
+	if (slot_allocated(zram, index)) {
+		seq_printf(seq, "%12lu %12u.%06d %c%c%c%c%c%c\n",
+			   index, zram->table[index].attr.ac_time, 0,
+			   test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
+			   test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
+			   test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
+			   test_slot_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
+			   get_slot_comp_priority(zram, index) ? 'r' : '.',
+			   test_slot_flag(zram, index,
+					  ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
+	}
+	slot_unlock(zram, index);
 
-	return written;
+	return 0;
 }
 
-static const struct file_operations proc_zram_block_state_op = {
-	.open = simple_open,
-	.read = read_block_state,
-	.llseek = default_llseek,
+static const struct seq_operations zram_block_state_sops = {
+	.start = zram_block_state_start,
+	.next = zram_block_state_next,
+	.stop = zram_block_state_stop,
+	.show = zram_block_state_show,
 };
+DEFINE_SEQ_ATTRIBUTE(zram_block_state);
 
 static void zram_debugfs_register(struct zram *zram)
 {
@@ -1624,7 +1626,7 @@ static void zram_debugfs_register(struct
 	zram->debugfs_dir = debugfs_create_dir(zram->disk->disk_name,
 						zram_debugfs_root);
 	debugfs_create_file("block_state", 0400, zram->debugfs_dir,
-				zram, &proc_zram_block_state_op);
+				zram, &zram_block_state_fops);
 }
 
 static void zram_debugfs_unregister(struct zram *zram)
_

Patches currently in -mm which might be from pooyan.azadparvar@gmail.com are

zram-fix-short-reads-from-block_state.patch


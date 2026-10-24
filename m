Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832324;
	b=Q5/Td8X534YsxSAFaqL/QMvi45DhuXSn7r6YW/O61GY8bof1JEoUf22NPeTGskL/9jpS
	 kcbCcgxg3a+alRNVLvmV2Ogik2uq4Pbwm000LIOJbgxnP5GoC6BxMXLYQSdkPUbtBzp40
	 47QjghiP9gb1kztZlveHxMRbqnArZmO/5k2fpSz0MLIPH4H2vF1+qYn1HY0FQbF+CtoPV
	 pFpZy/S9RfQ6WS3LX2Rqp2SDLnqQiU309vRCs3gUTIRtDHYQtzEpxCuKoIvGyldXh2Pxp
	 s1ZlWp5ZQ42xFNCnAevojsJC/I7HDDgTNYPQJQ8owRCc2dSLA/AJwZYZ6IsnpVaug5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832324;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oumnyuDbKTthBXdcGyW7g35jNxYwG//GLTjfRJ6RmYg=;
	b=SFNGBXTwWl3EmObBP+u2iMcPgZPPUtGEH+Vej3IYJSpeZhExcRt2TGc+AfbV0EqCjaLs
	 gGjGXwS9HNXGmKSJZCILfD/4Cd3QVh2jr5PmEnbc4vcELLAUYpdhLf0igV7K7orHHfTVU
	 HspaKzB+LTdbYadng3r/Jvh9enys9oJbFioM9sS3WSZlZOOre6K7DKFjUEfDUEZZh/z+0
	 KrQEg04WYd/OghDRHfIY2/JXn+CLTmhgj1ny1AfKh+ijls5j5/oqqOjKlHvAy0hmmhHC/
	 68xoLrpDBuAB/WSVXJ0KAwBMRwe4YA+s9m59v+7/GOmaZLzpz7K6E3VRnhxvu/XsygA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FNSGFlrr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F121E606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FNSGFlrr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1301F01825;
	Sat, 24 Oct 2026 08:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832323;
	bh=oumnyuDbKTthBXdcGyW7g35jNxYwG//GLTjfRJ6RmYg=;
	h=Date:To:From:Subject;
	b=FNSGFlrrmFI2JCQ2VzCfXfZs4wqEdOmYcOpo3bMrn6ty00YYAuYJjLKS9MYIkMRKd
	 bAIM9QcdATcKQtRLYga9jSKkUqD3uG0R6w+I3eQzXYuRLTI016wRIJKG0qb5XvuUIg
	 x6W6rNtn/Oq7KL97RFdlTFuwwroMFUx6iVY245aU=
Date: Sat, 24 Oct 2026 01:58:43 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,pooyan.azadparvar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-short-reads-from-block_state.patch removed from -mm tree
Message-Id: <20261024085843.BB1301F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: zram: fix short reads from block_state
has been removed from the -mm tree.  Its filename was
     zram-fix-short-reads-from-block_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE13480968;
	Tue,  4 Aug 2026 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785874258; cv=none; b=AjfAyqRHdbFAOH+TgmHhMgDBqh0As0biwB5YvStMm8PiufTqAo0qLEKW8Q7IWmtP4/Zyc+7uI+VLOlRI+VBpml5oXF00LlfQ1Ce3Z4sU0jmi7IvzDWfLYTKtrioMmsFkTjYVtKQRavAqftZA7DInuYgWmBzXPiauJ+vZFTCq+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785874258; c=relaxed/simple;
	bh=cmhvBq4fKuDwtPrRzX+lcSI89jAJ6FvcxY9NPdoruXM=;
	h=Date:To:From:Subject:Message-Id; b=K9tH+cxfIMjx6RAduqRyviPckAr6pWPdZP+edCyAMd08GwFZrBQYvNonq59II5tvJ2dmLxX8M4nwRqBgFV8xf0MoP0IwEe89Faf7Y0TpnF5euuS6Ai5aWNaKjNxAWwsCzOP9zfCeFbNpue5hYNsieCznXCnSTYG8VsYzKzCCYhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fq8+C5m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fq8+C5m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435221F000E9;
	Tue,  4 Aug 2026 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785874256;
	bh=JtKQl9rMaeDAkHwjE/v8QG/2z4gNzwJW0qDcVxf3LZc=;
	h=Date:To:From:Subject;
	b=fq8+C5m0QDXifHPkYM7kQ8kVKNG2B+0+UnLrrE5AazU0qXzBLsk9rI22POJWPMgHA
	 /BK6G0Q4BRIPSockepYPChwufoflIFdcLfWTRyBaEFEnzFpOhvC8T6gnweHQzXlfKT
	 FHW0UfvvJPHsxQ7HC1NZ1Ku9vjCnhoyxIyiiCCA4=
Date: Tue, 04 Aug 2026 13:10:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-out-of-bounds-access-in-read_block_state.patch added to mm-new branch
Message-Id: <20260804201056.435221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix out-of-bounds access in read_block_state()
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-out-of-bounds-access-in-read_block_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-out-of-bounds-access-in-read_block_state.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zram: fix out-of-bounds access in read_block_state()
Date: Tue, 4 Aug 2026 14:59:19 +0800

read_block_state() calculates nr_pages before taking dev_lock.  If the
device is reset and reinitialized with a smaller disksize before lock
acquisition, nr_pages still describes the old table.  The subsequent loop
can then call slot_lock() past the end of the newly allocated table.

Read disksize after acquiring dev_lock and checking that the device is
initialized.  The read lock then keeps the table and its bound stable for
the duration of the scan.

Link: https://lore.kernel.org/20260804065919.3970386-3-xialonglong2025@163.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-out-of-bounds-access-in-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -1543,7 +1543,7 @@ static ssize_t read_block_state(struct f
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -1555,6 +1555,8 @@ static ssize_t read_block_state(struct f
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch


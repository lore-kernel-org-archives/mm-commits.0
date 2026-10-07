Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00172931E9;
	Wed,  7 Oct 2026 02:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338714; cv=none; b=fTJsU/eSjws/G6538+rtbh8wVV13UupmHkBPS1MITECeFT/50YT4koxEuMGHL3+wba6v8TfGGKLMbuE0eowhTXK7s+x3EYtyPoqF0aq9DoYL3lr+v92bCikqBGclFpkOKh4Orgqwj6kX284bwhPamF2DGclijuAFIiHQR7PdRCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338714; c=relaxed/simple;
	bh=YDMGHpHhJ0m6/XFmfIsjhZcd+wrnhpLzayLLJ5fU08o=;
	h=Date:To:From:Subject:Message-Id; b=XqVe1ARYYUcGPbctxYjyTS1gopCICZy0vnhbjRE46mILQmAzGBtVZcUdITJ51NG7NvZ42CJj9JWGSxPO9VmA/6qPE2zqhJFlhpxpCKKaMSnw0ln4A4EQxYtgX/k1cAHmhX92Gaw81UkcJr6agSlH1WnDYKpsLMXM7fT0SbnMFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7d8MK/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7d8MK/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742411F0089B;
	Wed,  7 Oct 2026 02:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338712;
	bh=7tkVZjhCmJhwEz653oINyCw1T2JrfPscHzyA8L7FLMA=;
	h=Date:To:From:Subject;
	b=K7d8MK/SPh1gkPe9lkYad5uaqcZ52cnvNUbB6fcBQR48bqgrS3UyEh/EetRZ+gPIH
	 XV07QmMFf9NrE4IzjCn6TSX/EhBjoYZjU8fiHd8+rCwDVpM6Ml3JmHlVybtUFV10+m
	 TcETL2x0Ex7+2yoCI4VRxSAAOjL2RyMctCWbTlLw=
Date: Tue, 06 Oct 2026 19:05:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,r772577952@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-chunk-number-of-the-first-chunk-in-a-local-quota-file.patch removed from -mm tree
Message-Id: <20261007020512.742411F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix chunk number of the first chunk in a local quota file
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-chunk-number-of-the-first-chunk-in-a-local-quota-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaming Zhang <r772577952@gmail.com>
Subject: ocfs2: fix chunk number of the first chunk in a local quota file
Date: Mon, 14 Sep 2026 11:49:40 +0800

Mounting a crafted OCFS2 image can corrupt kernel memory.  When the
local quota file header of such an image claims zero chunks, the first
quota entry allocated during the mount gets a chunk number taken from a
kernel pointer, and releasing that entry clears a bit far outside the
chunk bitmap.

The write will corrupt the data stored at that address, and the
corruption may lead to a system crash or damage unrelated data. 
Mounting requires CAP_SYS_ADMIN, so it takes an untrusted image, such
as removable media or a loop mount of a file from elsewhere.

Since the chunk number comes from a kernel pointer, the address of the
bit that gets cleared differs from boot to boot, and the issue has been
reported under several titles:

- BUG: unable to handle kernel paging request in ocfs2_local_release_dquot
- KASAN: use-after-free Write in ocfs2_local_release_dquot
- KASAN: slab-out-of-bounds Write in ocfs2_local_release_dquot
- KASAN: slab-use-after-free Write in ocfs2_local_release_dquot
- KFENCE: use-after-free write in ocfs2_local_release_dquot

Note that none of these is a use-after-free in the quota code: the
chunk and its buffer head are alive.  The bit that gets cleared lies
far outside the bitmap.  KASAN and KFENCE name each report based on the
object occupying that address, which explains why the same issue is
reported under so many different titles.  In the report I sent, the
address fell in a free page, which KASAN labels use-after-free.

There are known reproducers.  Both a syzkaller and a C reproducer are
available from the Google Drive link [1] in my report thread.  The
issue was found by our modified syzkaller, not a theoretical thing
found by an LLM.  I have not seen it outside fuzzing, so it is not
affecting me in the real world.

The local quota file in OCFS2 is divided into chunks, and each chunk
begins with a header block holding a bitmap of the quota entries that
chunk has handed out.  Chunks are numbered from zero, and that number is
used to convert the file offset of an entry back into a bit position in
the bitmap.  ocfs2_local_quota_add_chunk() appends a new chunk to the
in-memory list and numbers it one past the chunk that was last:

	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
				   struct ocfs2_quota_chunk,
				   qc_chunk)->qc_num + 1;

The predecessor is looked up after the new chunk is added to the list, so
if the list was empty, the prev pointer is the list head itself.  The head
is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a chunk, so
reading qc_num through it lands 16 bytes past the start of the head, on
the dqi_gqinode pointer that follows it.  The first chunk of the file is
then numbered with the lower half of a kernel pointer instead of 0.

The list is empty when the local quota file header claims the file has no
chunks.  ocfs2_local_read_info() takes dqi_chunks from that header without
validating it, so an image with dqi_chunks == 0 takes this path when the
first quota entry is allocated.

ocfs2_create_local_dquot() turns the bad number into a file offset with
ol_dqblk_off(), which shifts a 32-bit block number left by the block size
bits, so the top bits of such a large block number are lost. 
ocfs2_local_release_dquot() turns the offset back into a bit index with
ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
that index far outside the bitmap, and clearing it corrupts unrelated
memory.

Compute the chunk number before putting the chunk on the list, and use 0
when the list is empty.

Link: https://lore.kernel.org/20260914034940.4070970-1-r772577952@gmail.com
Link: https://drive.google.com/drive/folders/1-LzPTgOALEc3eOjmgM6oOfRKkYXJ-bnO?usp=drive_link [1]
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: Claude Code:claude-opus-5
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/quota_local.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-fix-chunk-number-of-the-first-chunk-in-a-local-quota-file
+++ a/fs/ocfs2/quota_local.c
@@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk *ocfs2_l
 		goto out;
 	}
 
+	if (list_empty(&oinfo->dqi_chunk))
+		chunk->qc_num = 0;
+	else
+		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
+					   struct ocfs2_quota_chunk,
+					   qc_chunk)->qc_num + 1;
 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
-	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
-				   struct ocfs2_quota_chunk,
-				   qc_chunk)->qc_num + 1;
 	chunk->qc_headerbh = bh;
 	*offset = 0;
 	return chunk;
_

Patches currently in -mm which might be from r772577952@gmail.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A688A39FCF
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307077; cv=none; b=B8/69Ga5WjkWRc/EdzGKIn5Tbs9fvJNbeX9LomRtjt7ywOZos6Io1tbyoN9GWIU+ACVzt1xv4NHzWwo3NfLYSAgRuGCqzaV13vZ6EaHuG93J3/yMTQPkHyZ83LyuMWWHQUrRz5UarQYaIrJNGvK4Nic3rL8C6wXmBHyx4FWoOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307077; c=relaxed/simple;
	bh=vjAQ5l0Ef5Usf0UpMg3U/pvxTJH7a/QNnrbfF/dus3Q=;
	h=Date:To:From:Subject:Message-Id; b=qnTRvpc3oz1f1/vXaIWS+YVbIgUCYCPj+/t/y4HEaPI//0jwIXLYKVhjQTGvHRF2I9d5NHgnaR3gyCGrtNbgoqNaF1ODXyqKOTEpGzbX+ZMxk3txayIPty/rj+MtY3GVcUuAnHz4rlrwkWK/rMpmC8Sv3etTKFQDeP1RUHlIdN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4Q4l1zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4Q4l1zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9A6C113CE;
	Tue, 16 Apr 2024 22:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307077;
	bh=vjAQ5l0Ef5Usf0UpMg3U/pvxTJH7a/QNnrbfF/dus3Q=;
	h=Date:To:From:Subject:From;
	b=Q4Q4l1zhKi7vxXgnRNPxfdMFWU7fXBFSwZ4A8PYWYHX9pVV6K87BmnmdhODjklpeC
	 BH0Q8Hm2wViZDYee6ZT5VHb1mb/STbU+Snhu1YuJYy3sEBEU0VOo4ZmlOkDsfAL1D1
	 bUOcDs2GUahmwoQjfWv+hTQJdE/zNBBF7re8TxUA=
Date: Tue, 16 Apr 2024 15:37:56 -0700
To: mm-commits@vger.kernel.org,bugreport@ubisectech.com,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch removed from -mm tree
Message-Id: <20240416223757.0A9A6C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
has been removed from the -mm tree.  Its filename was
     squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2.patch

This patch was dropped because it was folded into squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
Date: Tue, 9 Apr 2024 21:47:23 +0100

whitespace fix

Link: https://lkml.kernel.org/r/20240409204723.446925-1-phillip@squashfs.org.uk
Reported-by: "Ubisectech Sirius" <bugreport@ubisectech.com>
Closes: https://lore.kernel.org/lkml/87f5c007-b8a5-41ae-8b57-431e924c5915.bugreport@ubisectech.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero-v2
+++ a/fs/squashfs/inode.c
@@ -49,7 +49,7 @@ static int squashfs_new_inode(struct sup
 	int err;
 
 	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
-	if(inode->i_ino == 0)
+	if (inode->i_ino == 0)
 		return -EINVAL;
 
 	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch
squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch


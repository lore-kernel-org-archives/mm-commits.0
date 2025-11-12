Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB95514B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908591; cv=none; b=ikjax29caj0PdW4sLHpISe72K7zWGJR7eATG5yfEjYm7qsL/LFitjDNmPt8TwhwO6Ez6LpF0f8IXzOUrodCSmNz0IPQk5SqGF3tUD/up6WHAGzpvjDiP8BVkJtxVAgPRu5y6rUSoTkhPrrQcnVuOIUrIFFiMor9fia0vbRGFqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908591; c=relaxed/simple;
	bh=BG0pHSH4EGvtSAE59eaj+euqLGGAIOLwgpZZ6SJpN94=;
	h=Date:To:From:Subject:Message-Id; b=gxI+Ao3oSTJHgln41dFGrosnWzgzykUbyADorANRfEISf19MjfLmB5t/meABXjS9b/c3rSNIk09DESX4imfMdtR/OPS0Uc46GQ5dXpo4k/OV11mOuEDQATfNtGKFmu996ZhLSLPZhj74ON29i9URLunEqugIYR+GInn4eH9yRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpJqqB40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpJqqB40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9273EC16AAE;
	Wed, 12 Nov 2025 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908591;
	bh=BG0pHSH4EGvtSAE59eaj+euqLGGAIOLwgpZZ6SJpN94=;
	h=Date:To:From:Subject:From;
	b=mpJqqB40BQL+BqinqbzNxMwSbiXCxPRSQyP2IX3X6pDig9V/cWSkfmaF42fg+FGqp
	 QSeZ6nvE2aAxOR83rWUwGfX0/U4+6LCaxU4RVHD+y7UZuGw/IIW7Nc6Vb/4Ppt3GpM
	 uz+wVh4I9jdmns3LmYVhTJGDcmf4aJV4LPhSKmlo=
Date: Tue, 11 Nov 2025 16:49:51 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch removed from -mm tree
Message-Id: <20251112004951.9273EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add directory size check to ocfs2_find_dir_space_id()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add directory size check to ocfs2_find_dir_space_id()
Date: Mon, 13 Oct 2025 13:37:09 +0300

Fix a null-pointer-deref which was detected by UBSAN:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5317 Comm: syz-executor310 Not tainted 6.15.0-syzkaller-12141-gec7714e49479 #0 PREEMPT(full) 

In 'ocfs2_find_dir_space_id()', add extra check whether the directory data
block is large enough to hold at least one directory entry, and raise
'ocfs2_error()' if the former is unexpectedly small.

Link: https://lkml.kernel.org/r/20251013103709.146001-1-dmantipov@yandex.ru
Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id
+++ a/fs/ocfs2/dir.c
@@ -3431,6 +3431,14 @@ static int ocfs2_find_dir_space_id(struc
 		offset += le16_to_cpu(de->rec_len);
 	}
 
+	if (!last_de) {
+		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
+				  "is unexpectedly short",
+				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				  i_size_read(dir));
+		goto out;
+	}
+
 	/*
 	 * We're going to require expansion of the directory - figure
 	 * out how many blocks we'll need so that a place for the
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch


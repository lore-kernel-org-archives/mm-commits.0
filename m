Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A2D176AB9;
	Thu, 24 Oct 2024 06:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750530; cv=none; b=Lq/LLeMLQhbTeHpnKUpCs0460L/BtGO/cFaZmt0yDtQAQTBHEO3dEXBVcvecc/IVEbT0jmjlCpHAXrh9OMi6yYVuD0WjL7yoTNY8cor5e8gZnW5MOZac/GN5FBga3CEj4rakn9n58j8SbGNT8YsIb9QTrNLVzb1wLwOFE62xuLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750530; c=relaxed/simple;
	bh=mFcx4HuQIBNd2QxMGzin/o4vfwNfSuJprlh+eg1HnNA=;
	h=Date:To:From:Subject:Message-Id; b=iS1pSBjSe9L1/Hj3Bx5TU3kdkgkCqfbme1lH9ETA/cZ+kMzqBF2KywaxYWw1LH6gbIIkPL6UnL/WtECRrpe7XkjKVk5OlB+UJZeuhmbKcxaUwVfuvZGOgMhnsYMrWT+CaVpA9Jd2Tg2/1qIDq7DRy7NhgUPHnuWS2wQtx+sornE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XrQlLlAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XrQlLlAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D57C4CECC;
	Thu, 24 Oct 2024 06:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750529;
	bh=mFcx4HuQIBNd2QxMGzin/o4vfwNfSuJprlh+eg1HnNA=;
	h=Date:To:From:Subject:From;
	b=XrQlLlABq9i2giZpnVENhq/pJ7HAMivvPMEbYfszOkbrNjH3dSmqtK1Aup5s6LGmu
	 nELE7ZT8GKI74IG2a1oo7/R1sJGHfYAsekFUs+joKmDY5Nq6F6fymRzctdLm74KnLb
	 UEV8xdbge4adaCThkhNcXY6+OSjv8Imqlbv9hW0o=
Date: Wed, 23 Oct 2024 23:15:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch removed from -mm tree
Message-Id: <20241024061529.81D57C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
has been removed from the -mm tree.  Its filename was
     ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Adam Davis <eadavis@qq.com>
Subject: ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed, 16 Oct 2024 19:43:47 +0800

Syzbot reported a kernel BUG in ocfs2_truncate_inline.  There are two
reasons for this: first, the parameter value passed is greater than
ocfs2_max_inline_data_with_xattr, second, the start and end parameters of
ocfs2_truncate_inline are "unsigned int".

So, we need to add a sanity check for byte_start and byte_len right before
ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
than ocfs2_max_inline_data_with_xattr return -EINVAL.

Link: https://lkml.kernel.org/r/tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com
Fixes: 1afc32b95233 ("ocfs2: Write support for inline data")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/file.c~ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow
+++ a/fs/ocfs2/file.c
@@ -1784,6 +1784,14 @@ int ocfs2_remove_inode_range(struct inod
 		return 0;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		int id_count = ocfs2_max_inline_data_with_xattr(inode->i_sb, di);
+
+		if (byte_start > id_count || byte_start + byte_len > id_count) {
+			ret = -EINVAL;
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
 					    byte_start + byte_len, 0);
 		if (ret) {
_

Patches currently in -mm which might be from eadavis@qq.com are



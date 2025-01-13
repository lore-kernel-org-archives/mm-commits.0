Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003E325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742260; cv=none; b=F37zNGePXLtV1oFH0QYmFsLc6OFuWoaDd4F3brbQBJMvF3XPL3U8SVd8l/6sMBWaiYFfcgYlXSygMTHVJlyMWYamZYDCheggYLFrdseeej+Ld4mq9x5f7tTrhxCf9IZ4057GwGw2szlGCVwwUe8CTyB/DXIhLKHs9yKkod8FaPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742260; c=relaxed/simple;
	bh=U4S3NUKK6afa8tvM0qSvKoIleDRtwbd2z0QA+IcUsfw=;
	h=Date:To:From:Subject:Message-Id; b=A/KKGDvD7UFVFx9/eDFJl2F1w2fY6OmYtk3+SyOqmvKZSqcaPQmDt9BLHRyglpFuJNp7rQ/EQ7N3cfLQyjXMl7bSNhzUP2eY2K5Nvl8d53Iwa7ZpW/e2A9nULecgev0L5hVQaQjgtybe4ycSLDNFkGRffdRGjG/j5YEmcf9fIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0NxfYDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0NxfYDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3997C4CED6;
	Mon, 13 Jan 2025 04:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742259;
	bh=U4S3NUKK6afa8tvM0qSvKoIleDRtwbd2z0QA+IcUsfw=;
	h=Date:To:From:Subject:From;
	b=J0NxfYDA2CDGG7j8+faIkDD0BPLR2mnsuorEc9FMUp/AETYLMo73aGQ/NIuB5G8dT
	 Ne+Z39CltQFIugcm7V7wNaTJ3pcU6gwoNfzkJH16zcCVM8whKtrwZyb7UMsxx3ro9C
	 DDCUX8Nf47B8KlIMAd9TCUmCN7vIvaCdAph4gM4o=
Date: Sun, 12 Jan 2025 20:24:19 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch removed from -mm tree
Message-Id: <20250113042419.C3997C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
has been removed from the -mm tree.  Its filename was
     ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julian Sun <sunjunchao2870@gmail.com>
Subject: ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Mon, 6 Jan 2025 10:34:31 +0800

Recently syzbot reported a use-after-free issue[1].

The root cause of the problem is that the journal inode recorded in this
file system image is corrupted.  The value of
"di->id2.i_list.l_next_free_rec" is 8193, which is greater than the value
of "di->id2.i_list.l_count" (19).

To solve this problem, an additional check should be added within
ocfs2_get_clusters_nocache().  If the check fails, an error will be
returned and the file system will be set to read-only.

[1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/

Link: https://lkml.kernel.org/r/20250106023432.1320904-1-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reported-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
Tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/extent_map.c~ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache
+++ a/fs/ocfs2/extent_map.c
@@ -435,6 +435,16 @@ static int ocfs2_get_clusters_nocache(st
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
+			    inode->i_ino,
+			    le16_to_cpu(el->l_next_free_rec),
+			    le16_to_cpu(el->l_count));
+		ret = -EROFS;
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are



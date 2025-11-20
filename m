Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7523723A9B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676257; cv=none; b=hmxmWKJGk33FUN9NHIcocXSgnwADSf7dF7ewC07uNRxKGU78ltMJcm0OHUiC2woWPGV779+LQnvF7yet2zYeg9+gIYJ56CuIP5hwa874LCQT78ePBc45ccEOYVeNpcUNSj8yxrFyWEClx+d/TS2BMkjSUxR4XCVGaXyyCMqjl1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676257; c=relaxed/simple;
	bh=1t+t/IGd5/Sj+uzYszlrN76RPWyryL9v6XUktTvMqq4=;
	h=Date:To:From:Subject:Message-Id; b=FMKvMVN7OIwyZxvpOLdjHUbEwHbK6USCYTXos1YG7ACE+miEJUwm3H/trMeliBMX+36Wb1WpuxwGqJbiElOoXv0hzYsHLOzqkQGgHnl63IXOZbQwAsoQe97dpn9dOpEP5qPPxD6sY6YzZZXuWx7p8GdXSbuZcTh16rqK37evrxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSpb/EuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSpb/EuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B56C4CEF1;
	Thu, 20 Nov 2025 22:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676256;
	bh=1t+t/IGd5/Sj+uzYszlrN76RPWyryL9v6XUktTvMqq4=;
	h=Date:To:From:Subject:From;
	b=jSpb/EuBTM+RApihnPzI3lYddsKREHzcqH2SMsiWJdUyErF8ltLPgVkx3FQcgQ/23
	 v9TA56hZVZ4EOhrMU1JwziXP2MzoK4I7k0GsRpXFh3f4I6XpYEA/aDeFsu3J/kn4Vn
	 SMVYk1dIl+Fm+LnTllV625PLxjA4VtOaac+z7yuY=
Date: Thu, 20 Nov 2025 14:04:16 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kartikey406@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch removed from -mm tree
Message-Id: <20251120220416.D0B56C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add extra consistency checks for chain allocator dinodes
has been removed from the -mm tree.  Its filename was
     ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add extra consistency checks for chain allocator dinodes
Date: Thu, 30 Oct 2025 18:30:02 +0300

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the valid
range.

Link: https://lkml.kernel.org/r/20251030153003.1934585-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes
+++ a/fs/ocfs2/inode.c
@@ -1513,6 +1513,23 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from dmantipov@yandex.ru are



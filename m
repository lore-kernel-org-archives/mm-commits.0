Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AA11D279F;
	Wed, 16 Oct 2024 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729118376; cv=none; b=kGl5f68q6qRm49YmqMmi/KXErjR5BFKNPGd6KIfbrs1nNC31IyUQ4syWcUQcZphQ0y4D1tF2Owsh1eBoFvccKTEi9naBN2Jye0V8d0NnX7/kFWldONhmoFzbqDCUS0t+f8b94pRKgxa+0OVsdOQ1uLZWiT3gMb4pbuIlNvwe/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729118376; c=relaxed/simple;
	bh=Iz8bVR4MDDpnjhsTXEpxJpT6/iH7sl2W0mOZIwRWqDk=;
	h=Date:To:From:Subject:Message-Id; b=pCW8E65iYvqJnxx5v9w4sqnrpeyR0WR95w/Mb+ug4Ri5c9UV0y/E+qTzlZY3xLyprrdqq+16Xhi6CEXF5TvkGf3Dx+gUXTGkjQQdv7R7qLmyw9BztUVlCCakeYgMUe4ZPB3nuGL9043qyBUO0OaYO6hkG3FPUXagbw6/Cg7NnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n/YKhbex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n/YKhbex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B74C4CEC5;
	Wed, 16 Oct 2024 22:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729118375;
	bh=Iz8bVR4MDDpnjhsTXEpxJpT6/iH7sl2W0mOZIwRWqDk=;
	h=Date:To:From:Subject:From;
	b=n/YKhbexuAe1NS58VIR0zDSf9f7YszjcwUjYlJGl3GzKJlTLMBeW5wuA4zs7hVZre
	 z6kZfwAYRVWx5E4cCe0ugzUkjHrSHJLclsdWMPa8wxtxYgXRazhWhJviwreVxvJ17n
	 xsUI+a5H4vp67k5/DKBnitvkd17jiBqwdd2McrtU=
Date: Wed, 16 Oct 2024 15:39:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016223935.D1B74C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-pass-u64-to-ocfs2_truncate_inline-maybe-overflow.patch


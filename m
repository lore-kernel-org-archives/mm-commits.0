Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EFA2FBDFA
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966362; cv=none; b=lyOxAFIFtSuJH1GbchiaMKFRUW1N5GcZ2+pqEIRU7vuwn+0wqsHtonGaVABD9jLPkfhxgL9mywZQg+JkZp2MIYamu8tKNHt9ugN87Ce9YCa7QlTjMxtUfB9UzX5AoWWo3jQVde5QqIicLMM+mTlC3+97hcWn5VVhQX0aAZDVgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966362; c=relaxed/simple;
	bh=Rpw9SDPESyxp53nX15sEQx9gd+Kz/0W+KsD6RCGjV7I=;
	h=Date:To:From:Subject:Message-Id; b=XIlSUCB09WA4zKdEC41e7yWHSOUy11Pzgby9ZtpApUcp5wpkhTrY8nMi+FwNYYe0FrIv/WXU3OmmAxb4P36fiUbskxq2o6wfPvmDfxaoqWtjB1Y03t51/xtzCL2AyoYswCKBTuzXtl2EsHadMBe4Ph1C/z15KwXeANfN+q7NM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rbUz8ZZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rbUz8ZZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2796CC16AAE;
	Wed, 21 Jan 2026 03:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966361;
	bh=Rpw9SDPESyxp53nX15sEQx9gd+Kz/0W+KsD6RCGjV7I=;
	h=Date:To:From:Subject:From;
	b=rbUz8ZZcsmPQbqBCqkP9VKQToZpHYnuQx3ai5rlIHMiU53SvwaelgSMcud8nAXyr/
	 qwvFEmLsEsnlY1EOrx/aNxHa/H8cPHMAd3KUo/rqhSKJVhIWDUmAmc14tvreMPx0MC
	 cowdhHYbSHj57dJ9KFmQYDrr93K4O4Uw8ViUwm3o=
Date: Tue, 20 Jan 2026 19:32:40 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,glass.su@suse.com,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch removed from -mm tree
Message-Id: <20260121033241.2796CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix uninitialized variable in ocfs2_test_suballoc_bit()
has been removed from the -mm tree.  Its filename was
     ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch

This patch was dropped because it was folded into ocfs2-detect-released-suballocator-bg-for-fh_to_.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: fix uninitialized variable in ocfs2_test_suballoc_bit()
Date: Thu, 18 Dec 2025 10:48:12 +0300

The ocfs2_read_hint_group_descriptor() function sets "*released = 1;" but
nothing ever sets it to zero so it's used without being initialized. 
Initialize it to zero.

Link: https://lkml.kernel.org/r/dc37519fd2470909f8c65e26c5131b8b6dde2a5c.1766043917.git.dan.carpenter@linaro.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Su Yue <glass.su@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-detect-released-suballocator-bg-for-fh_to_-fix
+++ a/fs/ocfs2/suballoc.c
@@ -3163,7 +3163,7 @@ static int ocfs2_test_suballoc_bit(struc
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status, quiet = 0, released;
+	int status, quiet = 0, released = 0;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

ocfs2-detect-released-suballocator-bg-for-fh_to_.patch


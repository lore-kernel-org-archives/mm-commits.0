Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009722C11CF
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766099260; cv=none; b=UG0STkpLEph1Zmq4qTvTMnvV08RjWEj1Z6PdNQUMicrstHQExOkfB/pkd+fSHc6dDWQr7oahMx10zBnp9Xc47s2apfDyDvJPZhqmwU/Oum/F63dztf0NZFcO8ryxogzeaiJhp0akar9kzaqG8x7P4qNru4glLnQdvSJg4xaogQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766099260; c=relaxed/simple;
	bh=0AYIHquJqf9x6k0bMAY/gmDHvxk0rsNWhJ/l1My1Jvk=;
	h=Date:To:From:Subject:Message-Id; b=VkmR8ql4ibwnLZq6+FMjNA+IvgTFPOVl7iQIM13/Tm0fxPGP5aEWZ6uW675bV3r418xPR0CacuDO9mcYT5Fvj1rAGQAZtx6Mu3t6CSlcA/6Ac6ZZW4JS5baYJhKyZq979KuISufAIJhzUevJGRovDvdWeT1ptCV8ZNnFPaO4mvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XC16qyW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XC16qyW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68143C116C6;
	Thu, 18 Dec 2025 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766099259;
	bh=0AYIHquJqf9x6k0bMAY/gmDHvxk0rsNWhJ/l1My1Jvk=;
	h=Date:To:From:Subject:From;
	b=XC16qyW+ASAj9w3I2TzeSRHwxa/n3p6qv5Di/ooJ6XNPCYOLOjlo+cgrn8hhxqIRG
	 jk5+DbWAeUVDP9LE4DSrdEA7COpukA4/Lm2I0MpHwrR8N99iCS2mJdc8ez7JTKXep6
	 eH2MX230luK4njGB+MJxs1wmMEAd6VwYKe6aSu6I=
Date: Thu, 18 Dec 2025 15:07:38 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,glass.su@suse.com,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251218230739.68143C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix uninitialized variable in ocfs2_test_suballoc_bit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: fix uninitialized variable in ocfs2_test_suballoc_bit()
Date: Thu, 18 Dec 2025 10:48:12 +0300

The ocfs2_read_hint_group_descriptor() function sets "*released = 1;" but
nothing ever sets it to zero so it's used without being initialized. 
Initialize it to zero.

Link: https://lkml.kernel.org/r/dc37519fd2470909f8c65e26c5131b8b6dde2a5c.1766043917.git.dan.carpenter@linaro.org
Fixes: acb8a8335a64 ("ocfs2: detect released suballocator BG for fh_to_[dentry|parent]")
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

ocfs2-detect-released-suballocator-bg-for-fh_to_-fix.patch


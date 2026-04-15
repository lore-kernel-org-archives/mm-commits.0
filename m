Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9193264D4
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244601; cv=none; b=Ph9sR5m5rWzeGkR5CG/M92pvOkabcUErTDCHPXYsNpyMDDgWkHpLbRaP8vlaKMAWyJsE/00HcXE0LflKJGFJa58KsUKGULcUymGH+W4HKVuwVeSwQwjahKq3+G068T+oGDoUqXEAhac/W1pmiYKYwaAGdIAv7qfd+ivuANT9RqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244601; c=relaxed/simple;
	bh=NiSxQYds05dJH7AWIRGZNv1c7mFdoShButD1iV4BhPc=;
	h=Date:To:From:Subject:Message-Id; b=dY07DM06EaGZGmYr78EBZrQNeASMj8gklQr26v93Swbd0Dgk2MIuf/9bjYJrqLitSJObdEjPFzwjDJkUoZm6v20uGUrwLItX5TwTEiPHD3+nIVShvYL6vjzQMTyoMW+OoXeycMIEmeBWSx+hk9SKO7cTyN0uIwIJrDjySf4vtt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qjc4SaTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qjc4SaTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEB6C2BCB5;
	Wed, 15 Apr 2026 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244601;
	bh=NiSxQYds05dJH7AWIRGZNv1c7mFdoShButD1iV4BhPc=;
	h=Date:To:From:Subject:From;
	b=qjc4SaTbnl9wt46745/yz+HYB6Gl7eIpC5cla/v3fc+iod5C0QQUzKuM29XCe6w9C
	 EqCYM7YR46anzNBwdelOEl4uNUvx7K+7ehRfiBQ+DQXsObY2wLmvZkJfpgYxB/oFWh
	 1gjDSg1ehJAwM+v4xmaPD9XfbLBYkVgYtADynvuQ=
Date: Wed, 15 Apr 2026 02:16:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-get_random_u32-where-appropriate.patch removed from -mm tree
Message-Id: <20260415091640.CBEB6C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use get_random_u32() where appropriate
has been removed from the -mm tree.  Its filename was
     ocfs2-use-get_random_u32-where-appropriate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: ocfs2: use get_random_u32() where appropriate
Date: Sun, 5 Apr 2026 16:47:20 +0100

Use the typed random integer helpers instead of get_random_bytes() when
filling a single integer variable.  The helpers return the value directly,
require no pointer or size argument, and better express intent.

Link: https://lkml.kernel.org/r/20260405154720.4732-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c~ocfs2-use-get_random_u32-where-appropriate
+++ a/fs/ocfs2/super.c
@@ -2124,7 +2124,7 @@ static int ocfs2_initialize_super(struct
 		osb->osb_cluster_stack[0] = '\0';
 	}
 
-	get_random_bytes(&osb->s_next_generation, sizeof(u32));
+	osb->s_next_generation = get_random_u32();
 
 	/*
 	 * FIXME
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch


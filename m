Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D9CFC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610194; cv=none; b=PnR2orEQ3law9CgwxVdN38I4TjBf57ld1+lTtHdfWkAGCVtN6hnXE7ECVsNYnyB4TAOT6C0A9uG8G7DS6yA0EyQgaQuv4K3ouJ2s1St1xZ6BighNfIJiNMeunwm8rC9381Yoq9yxOodln4rPviTE5SMaz9gAttRr050Hpvxd54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610194; c=relaxed/simple;
	bh=4V3T+VUd3Dw5zCixBcSvAWhX2BLS8b9V33qX3HZepH0=;
	h=Date:To:From:Subject:Message-Id; b=M1VbE9u5IRp64CtcKJe5WN/0KX5UD00a0WHuGzEKwcrLqEOa+x36sk5BgAvT+Tnb9/ddVt+igAWqbD59W+B9uYFAmHnV5t6wUJYDrAGepeylAxK7JqXuTlq1aQ3gx5moThf4EVz+IcyPx2RSG/3Qjl2IS6urTiWLtgUpEpAHWuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zSegFoRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zSegFoRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D8FC4CED2;
	Tue, 31 Dec 2024 01:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610193;
	bh=4V3T+VUd3Dw5zCixBcSvAWhX2BLS8b9V33qX3HZepH0=;
	h=Date:To:From:Subject:From;
	b=zSegFoRBY1pN09VpZbPYbDSeUWQweXit77sH3RYxKVn/N23yh1kVTlu5p3SYSsLck
	 h/a75BOF4jQK6UvEmkYERZkLuY5fGezMw4LnvHc44Y353lJCjSqL/8H5AZEQ7UWLvr
	 RUfe9Oq9xhsVoavYZZhpHjJMT9GeAvU7McXIAtpc=
Date: Mon, 30 Dec 2024 17:56:33 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dennis.lamerice@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20241231015633.D6D8FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch

This patch was dropped because it was folded into ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes
Date: Wed Dec 18 07:52:38 PM PST 2024

WARNING: Possible repeated word: 'to'
#11: 
set as null leaving it to to be accessed.  Additionally, the read-only

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: fatal: not a ("nux-next'")'
#21: 
Fixes: 8f9e8f5fcc05 ("ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas")

WARNING: Reported-by: should be immediately followed by Closes: with a URL to the report
#23: 
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com

ERROR: space required before the open brace '{'
#47: FILE: fs/ocfs2/quota_global.c:896:
+	if (!sb_has_quota_active(sb, type)){

total: 1 errors, 3 warnings, 15 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Changwei Ge <gechangwei@live.cn>
Cc: Dennis Lam <dennis.lamerice@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes
+++ a/fs/ocfs2/quota_global.c
@@ -893,7 +893,7 @@ static int ocfs2_get_next_id(struct supe
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_active(sb, type)){
+	if (!sb_has_quota_active(sb, type)) {
 		status = -ESRCH;
 		goto out;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv.patch
percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D43154727
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734580416; cv=none; b=On8dTDyHNHnX9FcT2Tn4mjJ/Hyrthas6c5iLeD68AmCaaSvggfEl0btvim9eiT0me94aMdbW5mLV7Ts6RnhA88tPsSVVBShBA83C6bQHaX1IYkVuczJUZ8ysr7050TFBztTBN37HQwkNJMs5a/J1qOKsbVEHZZe/4rIHMS2i9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734580416; c=relaxed/simple;
	bh=1JyyOIVRaz1V+BQkh5tSNdQ/+9CzxZEVSYoBSl9he/Q=;
	h=Date:To:From:Subject:Message-Id; b=CJ4UrMLZnSzN78Dka7xhE2TI8NsID6++sY1/W9gMF+CZ37M/tPFQuZtA9DhTPCzy36t0Am2M84U0scGqMPqEcOMKawIA9ZGWj1lmrGCaoQXqho7QOVjorwXtW1wgXc8wJH7HD3M09NrPzVxZ161e0oyHQH0ISIJOtbgLzcVRswQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uoxk7Z5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uoxk7Z5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9628C4CED4;
	Thu, 19 Dec 2024 03:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734580415;
	bh=1JyyOIVRaz1V+BQkh5tSNdQ/+9CzxZEVSYoBSl9he/Q=;
	h=Date:To:From:Subject:From;
	b=uoxk7Z5ZHqM9oLcxUkRhFeRUJNuB/CoRYxHSoxNTHslNcP7X+V0MTY1TomGCFxFkV
	 pqbXyCDwpTWtAlXG1wy3QW73tWWmnkpcTxK/NVnNHoLm1WEYZezmg5dVvcZBGxxm4A
	 6XShrIz5aBlxOekuiRKwW9I4Q8QZChFCr2Sdx0Y4=
Date: Wed, 18 Dec 2024 19:53:35 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dennis.lamerice@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch added to mm-hotfixes-unstable branch
Message-Id: <20241219035335.B9628C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch

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

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch
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


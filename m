Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB86376
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 03:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173147; cv=none; b=WebAO3ZOJKH6Yz0n3EW3Zx52iNIbKp7ofHCDr3Ia7NT9ZS/xQWPAZ7xVbTjcIHfsVG3z3TlL+68ysa2NI1xPM0Rx0WWTlKKA4E2crGYJ3/5QcxjAtzgfX5bgH86nf3vC7MT/aCVkZivOJ4KtwnZOJ8uVu7lq7HIedvTs/oJC98k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173147; c=relaxed/simple;
	bh=fPJLIGqfs/nAPPT6Lwc9njpmhUpPpAawSKNWZjYQsdE=;
	h=Date:To:From:Subject:Message-Id; b=Xa8CFMmUBz5RPyJsFVvIgv0nKhH13ZbemoJ/mzPHZ5lR5N/0eMhknZSUnp8oDdzxX/AUU8oCKU7L58a1Dl0qJ5fhmUBpzIfXThmKfnuzDvOAi7iqqckIXDQd9W3Dabno0oCewpbgVpCehDEFKS1umleNdEE1mBBnEBhqB014Ank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aO51bKCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aO51bKCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DA7C4CECD;
	Tue, 29 Oct 2024 03:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730173146;
	bh=fPJLIGqfs/nAPPT6Lwc9njpmhUpPpAawSKNWZjYQsdE=;
	h=Date:To:From:Subject:From;
	b=aO51bKCP2zXpNxRAx4Pvyc7P44+QNIpyaXwkHqMffFRIYqz67w+tjCgz5jvmSjJYw
	 VQQRzfR5+f68Uw9eJyx4NCdjHuvUzXiaAsgH14ysOqCoQdhm/mFJbtiHSU7sVHsRQ+
	 uSo1VT/HwY1V+Xdkck+1/hjxvY3FwCzI8vnlTgmg=
Date: Mon, 28 Oct 2024 20:39:05 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,algonell@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-fix-a-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20241029033906.96DA7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: cluster: fix a typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-fix-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-fix-a-typo.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Kreimer <algonell@gmail.com>
Subject: ocfs2: cluster: fix a typo
Date: Sun, 27 Oct 2024 15:35:18 +0200

Fix a typo: panicing -> panicking.

Via codespell.

Link: https://lkml.kernel.org/r/20241027133540.22090-1-algonell@gmail.com
Signed-off-by: Andrew Kreimer <algonell@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/quorum.c~ocfs2-cluster-fix-a-typo
+++ a/fs/ocfs2/cluster/quorum.c
@@ -60,7 +60,7 @@ static void o2quo_fence_self(void)
 	switch (o2nm_single_cluster->cl_fence_method) {
 	case O2NM_FENCE_PANIC:
 		panic("*** ocfs2 is very sorry to be fencing this system by "
-		      "panicing ***\n");
+		      "panicking ***\n");
 		break;
 	default:
 		WARN_ON(o2nm_single_cluster->cl_fence_method >=
_

Patches currently in -mm which might be from algonell@gmail.com are

ocfs2-cluster-fix-a-typo.patch


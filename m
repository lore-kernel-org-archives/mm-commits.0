Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4203AC0E7
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019227; cv=none; b=KVJDQ22UrDI0CnfvXe6M7sAb0Qx6nSondAfadO8LeHj/QOJ7H7mUssxkG6mt6DTbbH5TCZAquavu8lfVfIHQcl+bc4JQFDR5Mi27Q00kzHnEKdBx58iW5Xegs/DmOwM01H5W48w3tlVLEcWtClzDlMx0rv0/IMzLkgk1gEmNgsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019227; c=relaxed/simple;
	bh=sIpu428VZPkhR/pUZQwzayqhyBWtVp6ZYZaPuUcE8Bk=;
	h=Date:To:From:Subject:Message-Id; b=nYD0o90IPaiNjLsql+lfUMqXguPyqd6puQJfYz3Pcelfu/N43jkkzeCingkKetCvD+URvj+8NZ+deuVIAzL4UFU5vNqeeR2CO1DL4P9k/ZkOlup9LgP5unKrUem/PCALwXDOMXbtNM9gcvFUI3d3OQpf/L+/tyYtDTT5Ws0pcNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2PCittkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2PCittkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8161F000FF;
	Mon, 21 Sep 2026 19:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019225;
	bh=QQtNRhvBmoy5v/xpsHX1Mk92Jpc3vazb2IQjxw3mF3I=;
	h=Date:To:From:Subject;
	b=2PCittkMjAbfovhXxy5XovvbTUWN+99CDhulVk+TKMKedUXO3Idj3kM3qARkadTgd
	 ihOAIa6f/Va93s2aQnq1gZxMrpw6lOTfWAreyKYmdec2Tf2iOOFUs6PvjCbj05p8S0
	 Dy1/p7jRBhrkU50dozoFD0sV1yITbbdZyrd5YuJY=
Date: Mon, 21 Sep 2026 12:33:45 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,sj@kernel.org,karthiproffesional@gmail.com,aethernet65535@gmail.com,adrianhuang0701@gmail.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch added to mm-new branch
Message-Id: <20260921193345.6E8161F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: propagate damon_call() error in turn_damon_on
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: mm/damon/sysfs: propagate damon_call() error in turn_damon_on
Date: Mon, 21 Sep 2026 08:15:44 -0700

damon_sysfs_turn_damon_on() ignored the return value of damon_call() for
the repeat call control registration and always returned the stale result
of damon_start() (0 at that point).  When damon_call() fails, e.g., the
kdamond is already exiting, the user still gets success from the state
file write while monitoring is not actually on.

Save and return the damon_call() result instead.  No rollback of
damon_start() is needed since a failed damon_call() guarantees the context
is stopped.

Link: https://lore.kernel.org/20260921151547.78472-3-sj@kernel.org
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on
+++ a/mm/damon/sysfs.c
@@ -2607,7 +2607,8 @@ static int damon_sysfs_turn_damon_on(str
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	if (damon_call(ctx, repeat_call_control))
+	err = damon_call(ctx, repeat_call_control);
+	if (err)
 		kfree(repeat_call_control);
 	return err;
 }
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF7A3C10B9
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219107; cv=none; b=V1Oxdo1qMBlCOfP0XBt+ygn3AY+gwAc8dlSRXyYqgtSaS61t3gBLwnkGHl7Mz7ZHlxl1raDPSG9wGNvc54oPFNeshi58PZQ/Ntr4fecabvLbIIc2NVvmiUnPRFaHDJxnrmss5y8VQ0cwZGtA5yXJ0SsRTns0fs0Ah1ov0sNxyTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219107; c=relaxed/simple;
	bh=ZjS3N5ttbKW/dgUc/q1vsScEoR5EDVKaZHsZY4cL1cs=;
	h=Date:To:From:Subject:Message-Id; b=WAyyuEUZeVVdrk23ES0p+MKN7TydDxIjbW3BwWkaooFcfz7pZO2FjYhVUpxXm6SKGLk/7acGl5b56cqBwxzRYwVu1rKIwWg5zGkygL2OUsWyy+6/7WiDjSsXRX1esJOuOezSNCDlfUba9iDSVFCbASctOwbeZDM/P4gb9asH8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g2ABGu5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2ABGu5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F265C1F000E9;
	Mon, 31 Aug 2026 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219106;
	bh=VcgZtM8om4BD08f4mbAxBjzESNUX+zxGBLxqq1AH+8U=;
	h=Date:To:From:Subject;
	b=g2ABGu5KvsTAv6za4+ZxM+8JEkhgAC2PKhY3rKQkYiEbZRrntdWGqlD/yh7BtUky8
	 voHfkomXCXkKGNqaBgtOFDJLWc70FEeVkl35m0AQ6klr0FDcpDKjx321Eyqo4NVUzT
	 k0wTYvSz4POXP6q7d1Ji3Py5deNf4C3AKzSsocBo=
Date: Mon, 31 Aug 2026 16:31:45 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch added to mm-new branch
Message-Id: <20260831233145.F265C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove declaration of __damon_commit_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/damon/core: remove declaration of __damon_commit_ctx()
Date: Mon, 31 Aug 2026 07:26:03 -0700

Patch series "mm/damon: misc cleanups".

Cleanup the code, tests and samples for clarifications and readability.

The patches are individually sent by the authors.  I'm reposting those as
one series for convenience of handling.  For this reason, changelog is on
each patch's commentary section.


This patch (of 7):

__damon_commit_ctx() was added by commit b1471afe4d10 ("mm/damon/core: do
parameter testing commit on damon_start()") but is actually not needed. 
Remove it.

Link: https://lore.kernel.org/20260831142611.77572-1-sj@kernel.org
Link: https://lore.kernel.org/20260831142611.77572-2-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-declaration-of-__damon_commit_ctx
+++ a/mm/damon/core.c
@@ -1935,8 +1935,6 @@ static int __damon_start(struct damon_ct
 	return err;
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
-
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEA333987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810124; cv=none; b=AMZjPxJXWcu8Zjcug2SlDDv4vgUgqIocZdqvnty7maFquZhsI57gUKhcsrzWhN1aArf2IimCZb2GuLy+rAOR7WaOFLBgUxDpm6Oca122JCo3N8Dxa8YbsZdZZA0k5oquirBBuc727IxpWe2NuY5uzmlWraQz81jB/lOPgm09Hy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810124; c=relaxed/simple;
	bh=M/ZtHM4orXaOaJUDzoDh2J3hVDEkIiAeNNBeemk9FDI=;
	h=Date:To:From:Subject:Message-Id; b=tQJkuK3yCHa7CAIynl6+HQ713F98sSsIX5BZi0cKBsddAHyX4Mx9R5mmtGCm9OYdJc0J5ln7vT+yLxR2DorJ1ZcOB03LTgZqJmEX0LjMRYRTAF7AD1C4JyGJX2HVd/Kwgk0WXQJqdND0OAMCkLp+JS/MDwF40KXtnCdecE2wI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xYrtuBzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xYrtuBzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA47C4CEEB;
	Sun, 14 Sep 2025 00:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810124;
	bh=M/ZtHM4orXaOaJUDzoDh2J3hVDEkIiAeNNBeemk9FDI=;
	h=Date:To:From:Subject:From;
	b=xYrtuBzXz8MORgWJCdNVlwRNHOhu1UPclcT9C0pl9td6wFtzYJZMT36OJ93RHyEyk
	 /ZPnSxAFp2yEHm76W4xBSI4y28BaSRlL6kzGuczf8lR+oZw/cWlyScnBHJ5sYXWl3r
	 bHWI8T8tG1NqmuTEcexCZv9AGZ/La1vCm6tXGtnQ=
Date: Sat, 13 Sep 2025 17:35:23 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-remove-ifdef-config_lockdep-in-copy_process.patch removed from -mm tree
Message-Id: <20250914003524.6CA47C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: remove #ifdef CONFIG_LOCKDEP in copy_process()
has been removed from the -mm tree.  Its filename was
     fork-remove-ifdef-config_lockdep-in-copy_process.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tio Zhang <tiozhang@didiglobal.com>
Subject: fork: remove #ifdef CONFIG_LOCKDEP in copy_process()
Date: Wed, 20 Aug 2025 18:18:46 +0800

lockdep_init_task() is defined as an empty when CONFIG_LOCKDEP is not set.
So the #ifdef here is redundant, remove it.

Link: https://lkml.kernel.org/r/20250820101826.GA2484@didi-ThinkCentre-M930t-N000
Signed-off-by: Tio Zhang <tiozhang@didiglobal.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/fork.c~fork-remove-ifdef-config_lockdep-in-copy_process
+++ a/kernel/fork.c
@@ -2124,9 +2124,7 @@ __latent_entropy struct task_struct *cop
 
 	p->pagefault_disabled = 0;
 
-#ifdef CONFIG_LOCKDEP
 	lockdep_init_task(p);
-#endif
 
 	p->blocked_on = NULL; /* not blocked yet */
 
_

Patches currently in -mm which might be from tiozhang@didiglobal.com are



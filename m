Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2F2287519
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755724583; cv=none; b=LE+Ijw2a4VWYfej//g6k4HfCbIX7LCfgTi/tdaqNCvzs8k2GzbohoPeXCGyALBv/bK+IT0Mob178pZjpD6WeXNFuxsa95hdbIitt4Al6RvpLQvG67sUzk/Yi//b6gUGz/Bz4AtroEEprJJuS/9nUYxoooGpZn60Txrvw4HdWxUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755724583; c=relaxed/simple;
	bh=U3k/G/4vojW7ux7vntddrfmuIs1McEIZrpbAEppiB8w=;
	h=Date:To:From:Subject:Message-Id; b=V0pgvfDlr2ivRMAkRrXZ/fSJ154BhrNX+Zyk2PBqDY+2CmNqlSgvyaX8fivgnr8lX5groDepIZN6LEGEhOL0gHot4FiKQXWAeunRPOrI720yefpKAP8xObdutFoeb13DhEVkZbNT6fp9jzec2d6ZnyTuZsxuNe40EcN+oq8g4BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RR3KYuVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RR3KYuVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DC0C4CEE7;
	Wed, 20 Aug 2025 21:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755724582;
	bh=U3k/G/4vojW7ux7vntddrfmuIs1McEIZrpbAEppiB8w=;
	h=Date:To:From:Subject:From;
	b=RR3KYuVYHQgxyavG7j3CO2q76ZC+39GzcdZn9oYxsyDr0Gj/5OTi4a15i6zK1c+BV
	 MZ9eZivN4o1lCIyxSHWT4ZnAuC5h/QK5oL7qaMlte89r1eOVq6UWPySsmPQQDxNLUH
	 fKGavUjASuTKBB1EkdNO7FLYt84cLhySX5POpoFE=
Date: Wed, 20 Aug 2025 14:16:21 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-remove-ifdef-config_lockdep-in-copy_process.patch added to mm-nonmm-unstable branch
Message-Id: <20250820211622.47DC0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: remove #ifdef CONFIG_LOCKDEP in copy_process()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-remove-ifdef-config_lockdep-in-copy_process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-remove-ifdef-config_lockdep-in-copy_process.patch

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
@@ -2127,9 +2127,7 @@ __latent_entropy struct task_struct *cop
 
 	p->pagefault_disabled = 0;
 
-#ifdef CONFIG_LOCKDEP
 	lockdep_init_task(p);
-#endif
 
 	p->blocked_on = NULL; /* not blocked yet */
 
_

Patches currently in -mm which might be from tiozhang@didiglobal.com are

fork-remove-ifdef-config_lockdep-in-copy_process.patch


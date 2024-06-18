Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C63B1779A9
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718748678; cv=none; b=sFIyDUt4qVKXCH7tXj3Gf4FJNvkwdQ2Ep7TmqZgMDvqzNFM98mS7Z5nAAGsCHZ65U27nlBXFYVQeSwWFaC7wqAOqLuoiJOpGirabpa2ixQ/xennSgyPQ4ORNMGJU1ktSuBBFS3LbxoY16jk4WzAu1adF7TTra3fkKoC6JXB6sMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718748678; c=relaxed/simple;
	bh=X+9oryXm0cSkksH4gt1ovwxhZqGa/FBMnZGUwLTiUsQ=;
	h=Date:To:From:Subject:Message-Id; b=UhUJAWrP+33PNp3LA4naeKcWQAmxhowhr7izA0NXY4dpjJQAf/DhIKIgS2s43XGZU0WTi0af0QNVIzoWAM1CyyVAhgCLHXe6F7oldWbctrp5Bg/jPOyeMrrEYqV7hIVniYLTMYl2j9tU97wEUHr0HsHmDKfMsmTBDRNPD5vIT/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HTulBaR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HTulBaR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC241C3277B;
	Tue, 18 Jun 2024 22:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718748677;
	bh=X+9oryXm0cSkksH4gt1ovwxhZqGa/FBMnZGUwLTiUsQ=;
	h=Date:To:From:Subject:From;
	b=HTulBaR0kv+kDjR+QGQ4JPzmjrGyAjcg0N+95xlS6no7U6dxGMqxNT+C7kKf2nunB
	 yhKYzHyExM+QroEhxC7BuPCh0JFwJO00+r4ZzRTBTualzxRNZyn4qxSgeUwezWb02n
	 OH3uMU01nB/QR400BcXbXwJ/kUZepSy1Fqjc9BSA=
Date: Tue, 18 Jun 2024 15:11:17 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch added to mm-unstable branch
Message-Id: <20240618221117.CC241C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document target_nid file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document target_nid file
Date: Tue, 18 Jun 2024 14:36:30 -0700

Document target_nid DAMON sysfs file that introduced for
DAMOS_MIGRATE_{HOT,COLD}.

Link: https://lkml.kernel.org/r/20240618213630.84846-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -155,6 +155,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the action
 		of the scheme.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_nid
+Date:		Jun 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Action's target NUMA node id.  Supported by only relevant
+		actions.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
 Date:		Sep 2023
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch
docs-damon-document-damos_migrate_hotcold-fix.patch
mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch


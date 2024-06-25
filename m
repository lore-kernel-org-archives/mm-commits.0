Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E251428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291730; cv=none; b=OsGNKQB0vHUi6ur2lBO7EXwN/V1FAA8j1uHlgvfqPqCrqQqdEJW0cgQVCmxys1b/ixFNfI6Y7mvuKwWwL45JPYOK8Dq/qyPYAOlfZQ3Qu4GSYO10jUu/Us0ovsWRXx4PmfBLLaJwR4ml/luFqMFzBDddce/WFtHErmuO1V9GgDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291730; c=relaxed/simple;
	bh=1zpr1V1Pf+8o5o4rQNc3sjCXBsc5IIXXM59l0F8W35E=;
	h=Date:To:From:Subject:Message-Id; b=uD7wKJ2/CyaDrBHEfUoAEJCADWuy3Ubjlt8pco6t9L6Rt56U+22wBBW/PpyxVpi4ha1JnOVspCB0pNHO0EBSDYarSZbFcYsJ/uePhkSudLiyCi0afzyt2nrAPvx+ZzrgJFcqhIkQwdome+ssIWtO9iSmJ50IpUM4/e17J+SMjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czL581S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czL581S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9F3C32782;
	Tue, 25 Jun 2024 05:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291730;
	bh=1zpr1V1Pf+8o5o4rQNc3sjCXBsc5IIXXM59l0F8W35E=;
	h=Date:To:From:Subject:From;
	b=czL581S4nAMtLQRgp5t4uijcPir+yiAxjzyFVxdf1FSiEheF75sxbdXksR3ooZX70
	 PtD+FETWrcIHxJbDNGsvHyj8QfC7vf4inYyKZIjsJw6cMQkamxMuHEhydFWbOCW4Ja
	 s3vyyXAa4pbgmgQF2bEZvAGy5McBrTJhHdfpcxD0=
Date: Mon, 24 Jun 2024 22:02:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,honggyu.kim@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,hyeongtak.ji@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch removed from -mm tree
Message-Id: <20240625050210.4A9F3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: introduce DAMOS_MIGRATE_HOT action for promotion
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeongtak Ji <hyeongtak.ji@sk.com>
Subject: mm/damon/paddr: introduce DAMOS_MIGRATE_HOT action for promotion
Date: Fri, 14 Jun 2024 12:00:08 +0900

This patch introduces DAMOS_MIGRATE_HOT action, which is similar to
DAMOS_MIGRATE_COLD, but proritizes hot pages.

It migrates pages inside the given region to the 'target_nid' NUMA node
in the sysfs.

Here is one of the example usage of this 'migrate_hot' action.

  $ cd /sys/kernel/mm/damon/admin/kdamonds/<N>
  $ cat contexts/<N>/schemes/<N>/action
  migrate_hot
  $ echo 0 > contexts/<N>/schemes/<N>/target_nid
  $ echo commit > state
  $ numactl -p 2 ./hot_cold 500M 600M &
  $ numastat -c -p hot_cold

  Per-node process memory usage (in MBs)
  PID             Node 0 Node 1 Node 2 Total
  --------------  ------ ------ ------ -----
  701 (hot_cold)     501      0    601  1101

Link: https://lkml.kernel.org/r/20240614030010.751-7-honggyu.kim@sk.com
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/paddr.c         |    3 +++
 mm/damon/sysfs-schemes.c |    1 +
 3 files changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion
+++ a/include/linux/damon.h
@@ -105,6 +105,7 @@ struct damon_target {
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
+ * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
  * @DAMOS_MIGRATE_COLD:	Migrate the regions prioritizing colder regions.
  * @DAMOS_STAT:		Do nothing but count the stat.
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
@@ -123,6 +124,7 @@ enum damos_action {
 	DAMOS_NOHUGEPAGE,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
+	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
 	NR_DAMOS_ACTIONS,
--- a/mm/damon/paddr.c~mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion
+++ a/mm/damon/paddr.c
@@ -486,6 +486,7 @@ static unsigned long damon_pa_apply_sche
 		return damon_pa_mark_accessed(r, scheme);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r, scheme);
+	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, scheme);
 	case DAMOS_STAT:
@@ -508,6 +509,8 @@ static int damon_pa_scheme_score(struct
 		return damon_hot_score(context, r, scheme);
 	case DAMOS_LRU_DEPRIO:
 		return damon_cold_score(context, r, scheme);
+	case DAMOS_MIGRATE_HOT:
+		return damon_hot_score(context, r, scheme);
 	case DAMOS_MIGRATE_COLD:
 		return damon_cold_score(context, r, scheme);
 	default:
--- a/mm/damon/sysfs-schemes.c~mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion
+++ a/mm/damon/sysfs-schemes.c
@@ -1458,6 +1458,7 @@ static const char * const damon_sysfs_da
 	"nohugepage",
 	"lru_prio",
 	"lru_deprio",
+	"migrate_hot",
 	"migrate_cold",
 	"stat",
 };
_

Patches currently in -mm which might be from hyeongtak.ji@sk.com are



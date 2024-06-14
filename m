Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76319FA96
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391222; cv=none; b=B0E/lD4MfuxGuWTszxqf9HiIOEVuojBQ1oV68RD41SMjtGY3WX+ha0h/bnhp2O2LXtrOHaojL61asvRDwGUP2bPt5/e1tx/+Hhu9L/TuXeo3HRYFQjYRhnYGVevEt3Qp94aiqWoKclrEqnibthx1q+KQdYu0URnWdMAzB+OTLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391222; c=relaxed/simple;
	bh=zwoYdm9DUSyzJbGT3icjpFoLrll7YOloIPGCfvc9WZg=;
	h=Date:To:From:Subject:Message-Id; b=daFpUWT19nDLG6gdUFvc2LloM/RF8NrSyLn8WfQnSJuV10tAbHGGr5/WBuod4jp1IRpwoLGn61xgs4GF1aWfLzkXc6JfPVVTOFU9ohAfFUHWnPTTYleRXzgLmj6/BbEfWd2+6U0VGbQJcGIk0+aufsXhapyng1hhBKMKUXNkY9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCaTMtn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCaTMtn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0364EC4AF1A;
	Fri, 14 Jun 2024 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718391222;
	bh=zwoYdm9DUSyzJbGT3icjpFoLrll7YOloIPGCfvc9WZg=;
	h=Date:To:From:Subject:From;
	b=yCaTMtn7SAWl4VwvNrgx6yKXa2+LC+oautWoQ4OzuGgwNtDIIGW/Huitfn8THG6f8
	 1PvPiMVh9IR3YS2mI1XH5w/5UT768z/PiQihH4aeWKgzFU3n4+osnKVVWzyJx8t3f7
	 B8JYkV7gHqELmHBcQrCbUVz7oLDC4aLrUqlSMVsI=
Date: Fri, 14 Jun 2024 11:53:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,honggyu.kim@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,hyeongtak.ji@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch added to mm-unstable branch
Message-Id: <20240614185342.0364EC4AF1A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: introduce DAMOS_MIGRATE_HOT action for promotion
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch

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

mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes.patch
mm-damon-paddr-introduce-damos_migrate_hot-action-for-promotion.patch


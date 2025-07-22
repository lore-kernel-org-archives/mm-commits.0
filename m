Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891982737F6;
	Tue, 22 Jul 2025 02:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153031; cv=none; b=kCZfuwKFaLP9O9fyhSS+BhKnjnp+YD8n97ZboNGX6prroovvWs4AUZckCQr9MJvjnEfs6WfVpE4iMRJ/KUyBOw11+A8A+RvqkRjsqcm3Np8H54jGe12ca1xp14lE0mHtg8iIuKxNcRlUKnPcw5axcj8ALRphsbZJhyIfQn9wLQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153031; c=relaxed/simple;
	bh=F+Fe16xskdHJesHepYpbzw/3QBq5jhHr7vH7iGrX69A=;
	h=Date:To:From:Subject:Message-Id; b=ftScE4nfC5s+/CV2Ekg3/xY6yujjVpdQ2DSAVgngovxuGuImjaFBfsC59lwONad0X+Cnjt8Lzp6GFoSXC2Oyg9X+M1V5O25Ltbrk5+M582MLmbVthkpIGYe9358yr9HtzDRqMnGSnLIyqA0qSOCcSU6bGDSrTAEv5hryv+n5xGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dDSB5rhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dDSB5rhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122A0C4CEED;
	Tue, 22 Jul 2025 02:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153031;
	bh=F+Fe16xskdHJesHepYpbzw/3QBq5jhHr7vH7iGrX69A=;
	h=Date:To:From:Subject:From;
	b=dDSB5rhssNog0xqTIrmCG6h6kD8/BZJeOC7nxC3eaZ/POmjGYCh5jRDEmarukDYoF
	 NHv2h/uVJFhewtp/ybtlB+kouXLoTQJSAb2kLxzBltAvZ/HZ8mcO8x4IPmg/8yzhdb
	 DX3FIndd77v77+NFpFXHuLvTIN8avZPC8EZ4T6h0=
Date: Mon, 21 Jul 2025 19:57:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch added to mm-unstable branch
Message-Id: <20250722025711.122A0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: ignore migration request to invalid nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch

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
Subject: mm/damon/ops-common: ignore migration request to invalid nodes
Date: Sun, 20 Jul 2025 11:58:22 -0700

damon_migrate_pages() tries migration even if the target node is invalid. 
If users mistakenly make such invalid requests via
DAMOS_MIGRATE_{HOT,COLD} action, the below kernel BUG can happen.

    [ 7831.883495] BUG: unable to handle page fault for address: 0000000000001f48
    [ 7831.884160] #PF: supervisor read access in kernel mode
    [ 7831.884681] #PF: error_code(0x0000) - not-present page
    [ 7831.885203] PGD 0 P4D 0
    [ 7831.885468] Oops: Oops: 0000 [#1] SMP PTI
    [ 7831.885852] CPU: 31 UID: 0 PID: 94202 Comm: kdamond.0 Not tainted 6.16.0-rc5-mm-new-damon+ #93 PREEMPT(voluntary)
    [ 7831.886913] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
    [ 7831.887777] RIP: 0010:__alloc_frozen_pages_noprof (include/linux/mmzone.h:1724 include/linux/mmzone.h:1750 mm/page_alloc.c:4936 mm/page_alloc.c:5137)
    [...]
    [ 7831.895953] Call Trace:
    [ 7831.896195]  <TASK>
    [ 7831.896397] __folio_alloc_noprof (mm/page_alloc.c:5183 mm/page_alloc.c:5192)
    [ 7831.896787] migrate_pages_batch (mm/migrate.c:1189 mm/migrate.c:1851)
    [ 7831.897228] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
    [ 7831.897735] migrate_pages (mm/migrate.c:2078)
    [ 7831.898141] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
    [ 7831.898664] damon_migrate_folio_list (mm/damon/ops-common.c:321 mm/damon/ops-common.c:354)
    [ 7831.899140] damon_migrate_pages (mm/damon/ops-common.c:405)
    [...]

Add a target node validity check in damon_migrate_pages().  The validity
check is stolen from that of do_pages_move(), which is being used for the
move_pages() system call.

Link: https://lkml.kernel.org/r/20250720185822.1451-1-sj@kernel.org
Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")	[6.11.x]
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-ignore-migration-request-to-invalid-nodes
+++ a/mm/damon/ops-common.c
@@ -383,6 +383,10 @@ unsigned long damon_migrate_pages(struct
 	if (list_empty(folio_list))
 		return nr_migrated;
 
+	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
+			!node_state(target_nid, N_MEMORY))
+		return nr_migrated;
+
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nid = folio_nid(lru_to_folio(folio_list));
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch


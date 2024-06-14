Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BC91A0AE3
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391212; cv=none; b=hq7fZ8SKpsN1gLYCXhaQnL4xVCeCTyjl7rU03vZiQrA3/Yz4B7s37Vch2fpz3UXyVcLIEe2oVJFstuIaxwlFWnbVaiSOj6nNoCeIZ2orHSe1NZYffKvtDm9OAoizNHVD5eoNIxcTCLppakTgWiW/kDeW+sYbGer6usnPS2w+KYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391212; c=relaxed/simple;
	bh=qDoJYo8wQsN0C/0VA9H0wiZ5KxiNLCov0/+Fz8jrWRs=;
	h=Date:To:From:Subject:Message-Id; b=BOm6omrMAn/Trw1ybUYY0PlhSS3UWLGuFaJ8DsY7iU4uruQGcYJG1IRZ6bmthu5Ocnzp5AVF0BbTQ6vGk85hIuV7cp90wEOP6YWoLehq8LsG+y12awlQ4xWrr/THZKCQLDxie2absplnOwdMUb29qvYOVRluciOdGpWo8tNzX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AF6+TrIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AF6+TrIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECABC2BD10;
	Fri, 14 Jun 2024 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718391211;
	bh=qDoJYo8wQsN0C/0VA9H0wiZ5KxiNLCov0/+Fz8jrWRs=;
	h=Date:To:From:Subject:From;
	b=AF6+TrIPYdc88wukm8oMgKzajsCyMfzH6EnkJQWHxf8aGGShwAD9ATGWzcNnifVay
	 b4m4BPbgAKAzYvVR7Z3ykV9+UwklEvSJ410HlaFuiKpYxEQba1oE4ZgGm870cjA9x7
	 IVlpWaVczz4gJXB/jPTrQNajNk2SEYKgI86CZlzk=
Date: Fri, 14 Jun 2024 11:53:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch added to mm-unstable branch
Message-Id: <20240614185331.0ECABC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename alloc_demote_folio to alloc_migrate_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

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
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm: rename alloc_demote_folio to alloc_migrate_folio
Date: Fri, 14 Jun 2024 12:00:04 +0900

The alloc_demote_folio can also be used for general migration including
both demotion and promotion so it'd be better to rename it from
alloc_demote_folio to alloc_migrate_folio.

Link: https://lkml.kernel.org/r/20240614030010.751-3-honggyu.kim@sk.com
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/vmscan.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/internal.h
@@ -1094,7 +1094,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private);
+struct folio *alloc_migrate_folio(struct folio *src, unsigned long private);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/vmscan.c~mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/vmscan.c
@@ -919,7 +919,7 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private)
+struct folio *alloc_migrate_folio(struct folio *src, unsigned long private)
 {
 	struct folio *dst;
 	nodemask_t *allowed_mask;
@@ -982,7 +982,7 @@ static unsigned int demote_folio_list(st
 	node_get_allowed_targets(pgdat, &allowed_mask);
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	migrate_pages(demote_folios, alloc_demote_folio, NULL,
+	migrate_pages(demote_folios, alloc_migrate_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
mm-migrate-add-mr_damon-to-migrate_reason.patch
mm-damon-paddr-introduce-damos_migrate_cold-action-for-demotion.patch
docs-damon-document-damos_migrate_hotcold.patch


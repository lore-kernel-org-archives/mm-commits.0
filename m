Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9721A01B6
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391217; cv=none; b=Bh5wVPv0CMXkOIEnm8pUmmVOpT13Eyn5RCgsibUWgz/m2yxX1unBLfeGIXDlKboKR7SbFHze+sNTFTUORh1U356IWUsoBnQHWzJPkqXCeYcMAq1kC9vlyuGKQ+lIM5zw/kwE2QhkEVIUIsQ38yhmTltYLG7NXuQDmdhzOMGEnik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391217; c=relaxed/simple;
	bh=GlIaWpicN01IiO0vFEj/6SA0UF716snmqu/z7wGG2Pk=;
	h=Date:To:From:Subject:Message-Id; b=h7icwqy9ZxGZfFLaxc38UQHTQluXxAGHFPbEPJ8wyY2xYZSivv1R5hzWzM20JEHnqEFGCFNlAUOG9MwxdY9otIhYW1JOBdpPtJzxcnWVAB4zVwV7SHQbpDV/XtmUHcUjmWSWcsmApQvJ2oN/6JlHyuZybMdVFPHkaH4NGQEIC1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xtTjMBp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xtTjMBp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FFBC2BD10;
	Fri, 14 Jun 2024 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718391217;
	bh=GlIaWpicN01IiO0vFEj/6SA0UF716snmqu/z7wGG2Pk=;
	h=Date:To:From:Subject:From;
	b=xtTjMBp5qkOxUaBg/HFMqgb81tFBmOqQB4swmXbIktbTSUCk3FwxbWRbPt4DD0XEq
	 4Eekc5HS7gGofJxBlIrFNMA4X0qnqBD60SDjUnyp6IL8tkjE7M6Horm8HdQcojJG98
	 HEfqGlxek+r45W1OrMEfd5SApC45GkOy5QuQ2I9A=
Date: Fri, 14 Jun 2024 11:53:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-mr_damon-to-migrate_reason.patch added to mm-unstable branch
Message-Id: <20240614185337.09FFBC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: add MR_DAMON to migrate_reason
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-mr_damon-to-migrate_reason.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-mr_damon-to-migrate_reason.patch

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
Subject: mm/migrate: add MR_DAMON to migrate_reason
Date: Fri, 14 Jun 2024 12:00:06 +0900

The current patch series introduces DAMON based migration across NUMA
nodes so it'd be better to have a new migrate_reason in trace events.

Link: https://lkml.kernel.org/r/20240614030010.751-5-honggyu.kim@sk.com
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate_mode.h   |    1 +
 include/trace/events/migrate.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/migrate_mode.h~mm-migrate-add-mr_damon-to-migrate_reason
+++ a/include/linux/migrate_mode.h
@@ -24,6 +24,7 @@ enum migrate_reason {
 	MR_CONTIG_RANGE,
 	MR_LONGTERM_PIN,
 	MR_DEMOTION,
+	MR_DAMON,
 	MR_TYPES
 };
 
--- a/include/trace/events/migrate.h~mm-migrate-add-mr_damon-to-migrate_reason
+++ a/include/trace/events/migrate.h
@@ -22,7 +22,8 @@
 	EM( MR_NUMA_MISPLACED,	"numa_misplaced")		\
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
 	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
-	EMe(MR_DEMOTION,	"demotion")
+	EM( MR_DEMOTION,	"demotion")			\
+	EMe(MR_DAMON,		"damon")
 
 /*
  * First define the enums in the above macros to be exported to userspace
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
mm-migrate-add-mr_damon-to-migrate_reason.patch
mm-damon-paddr-introduce-damos_migrate_cold-action-for-demotion.patch
docs-damon-document-damos_migrate_hotcold.patch


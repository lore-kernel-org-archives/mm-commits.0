Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379DF142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291728; cv=none; b=mekWuV3kBN6GnOUqHwJ1QJexmJf+5CK3mnkFtVeTat5UfFJ3Tjs3m51iVIRjFHRoo/5vnLZTjtg+wHQMVUW7Aw5klqBNy2K/kEoR/IANStnLKzzB7G/N2sSTSEGeHASqAiSDXj/ODdS43D0KbPmIHL/eBXduZu2eu6Z2+muhzYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291728; c=relaxed/simple;
	bh=iqmwM0oR/V7NU2XC9XvsjoAJlnW8UqKcuomoMpyxcaU=;
	h=Date:To:From:Subject:Message-Id; b=ReOH0oe5T1ZDWxP3AHamYgd3tj+HY3hm7KitMCwAuEm8aeZD1XMrlYs6JFeP8/7KTF1oFsg5YuDrvIfgq7Mwe0YH+qcLK0Xm7aeXAxU/IG9jiz1zqtwbBq5uMSe/QqHHPit5lBj2rLfR+NvT+UEw7ouzUEugQGssNxm+Ejk8MoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHwHAXml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHwHAXml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEA3C32782;
	Tue, 25 Jun 2024 05:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291728;
	bh=iqmwM0oR/V7NU2XC9XvsjoAJlnW8UqKcuomoMpyxcaU=;
	h=Date:To:From:Subject:From;
	b=GHwHAXml0bvpBFsb8/DZQkyD4+K/W/NRXjyDTatays/afbwtr8in1gSYjOkzUVHyB
	 0dyyrANGpxSRPQrBzl8i7b8NCU/WWeOKy8QM6HYWIrFuU3mN6/sM7oi0gw5V5mPIx8
	 7Mn0yrzbyvGJRTRwkisC3g13VOubR2VbZl7eH6Kg=
Date: Mon, 24 Jun 2024 22:02:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-add-mr_damon-to-migrate_reason.patch removed from -mm tree
Message-Id: <20240625050208.0CEA3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: add MR_DAMON to migrate_reason
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-mr_damon-to-migrate_reason.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



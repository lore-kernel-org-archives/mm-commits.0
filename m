Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3881428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291731; cv=none; b=geRncUcUzGkyNTiMxuFh56AExzJ5M3SInBCQr06lgKiYx/9m1bPgYCuCg96NxTjX9zJbAOBdd2943BuPAMa0VEV1X52Rx/S1LPOIJLJh3b3vW1PvNV6KIyQiPCpCU0klL91RY4re7E6e5qE7KlEjsAgUM+01HnxA/7t39FwXYJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291731; c=relaxed/simple;
	bh=LyiJAagFoxHq/EL+29fdg21W0CtqEhRYeUgoPHjrTmo=;
	h=Date:To:From:Subject:Message-Id; b=pUVTVFEV8LL27N58tiP52m+xQG6phFghHKEGhpz1zHPOANfXSR6xS4o6hr0beNEP/bl/IZPsb4LiE1scMeTQine9d8AtEk5ZUcG6pgF4I8bv11SXBgzd1JzQwLydiPTUcgfxeUwbOb56dszAJTaiBUTKFUD1m7tj5XsERspoLFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M0z/E8pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M0z/E8pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C10C32782;
	Tue, 25 Jun 2024 05:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291731;
	bh=LyiJAagFoxHq/EL+29fdg21W0CtqEhRYeUgoPHjrTmo=;
	h=Date:To:From:Subject:From;
	b=M0z/E8pgclTMchE5kLwXNMde6sDOJTRdNiR4IQshYkvod9BITpLz1CP1zofKRbrxz
	 tprInNNgjK1rj2+kpodgU0g2cuaqEyxaEi/N4T1PFbIRu/Wkw5Vfq5d2QYa9mSYFZm
	 NDmmJ6FkPzBlRleNgqUmWbjpGSLOT/hxmD59ER7E=
Date: Mon, 24 Jun 2024 22:02:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-damon-document-damos_migrate_hotcold.patch removed from -mm tree
Message-Id: <20240625050211.64C10C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon: document damos_migrate_{hot,cold}
has been removed from the -mm tree.  Its filename was
     docs-damon-document-damos_migrate_hotcold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: Docs/damon: document damos_migrate_{hot,cold}
Date: Fri, 14 Jun 2024 12:00:09 +0900

This patch adds damon description for "migrate_hot" and "migrate_cold"
actions for both usage and design documents as long as a new
"target_nid" knob to set the migration target node.

[sj@kernel.org: trivial fixups for DAMOS_MIGRATE_{HOT,COLD} documentation]
  Link: https://lkml.kernel.org/r/20240618213630.84846-2-sj@kernel.org
Link: https://lkml.kernel.org/r/20240614030010.751-8-honggyu.kim@sk.com
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: SeongJae Park <sj@kernel.org>Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   10 +++++++---
 Documentation/mm/damon/design.rst            |    4 ++++
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-document-damos_migrate_hotcold
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`schemes <sysfs_schemes>`/nr_schemes
-    │ │ │ │ │ │ :ref:`0 <sysfs_scheme>`/action,apply_interval_us
+    │ │ │ │ │ │ :ref:`0 <sysfs_scheme>`/action,target_nid,apply_interval_us
     │ │ │ │ │ │ │ :ref:`access_pattern <sysfs_access_pattern>`/
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
@@ -289,14 +289,18 @@ schemes/<N>/
 ------------
 
 In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and two files
-(``action`` and ``apply_interval``) exist.
+``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and three files
+(``action``, ``target_nid`` and ``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
 from the file and their meaning are same to those of the list on
 :ref:`design doc <damon_design_damos_action>`.
 
+The ``target_nid`` file is for setting the migration target node, which is
+only meaningful when the ``action`` is either ``migrate_hot`` or
+``migrate_cold``.
+
 The ``apply_interval_us`` file is for setting and getting the scheme's
 :ref:`apply_interval <damon_design_damos>` in microseconds.
 
--- a/Documentation/mm/damon/design.rst~docs-damon-document-damos_migrate_hotcold
+++ a/Documentation/mm/damon/design.rst
@@ -325,6 +325,10 @@ that supports each action are as below.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
+ - ``migrate_hot``: Migrate the regions prioritizing warmer regions.
+   Supported by ``paddr`` operations set.
+ - ``migrate_cold``: Migrate the regions prioritizing colder regions.
+   Supported by ``paddr`` operations set.
  - ``stat``: Do nothing but count the statistics.
    Supported by all operations sets.
 
_

Patches currently in -mm which might be from honggyu.kim@sk.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689819FA96
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391224; cv=none; b=qXZ8/6OlD/jttCSeSdaxc5CQVVFbsZl8yKEqC/dfkZYzs2hAqC2nnMNs1NF6vVDUkyqZGKX/LAzbKKWkLzafn8IwVxcaSOxzV9FTYKJntceRxyzW9SX+CSLIkw76nZAvC9mAua3+GB4X8IknYpSMHdlH7hufzOUhmtn4VaZlUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391224; c=relaxed/simple;
	bh=Ty3Me6F+0dQtJo8do/HxcQCEAP/meWCVsvhIYCNSZC4=;
	h=Date:To:From:Subject:Message-Id; b=FBwwZTkVAl/KsT1m9YmB6XiAl0yKIoJ7zA6XtFHh2gf940DFfpTywnxalXSvu67vr1OxiWTvpRCOkzEjgCIUgTF658J0kWJxEX/LtPCDocdKa4C9xEEcED5KgH7GWCInwJe26FtLhXvLrrDPDdJDDzQFELKBYpJV+QDg3kXWIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H2a6UfVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H2a6UfVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F42BC4AF1A;
	Fri, 14 Jun 2024 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718391224;
	bh=Ty3Me6F+0dQtJo8do/HxcQCEAP/meWCVsvhIYCNSZC4=;
	h=Date:To:From:Subject:From;
	b=H2a6UfVcf0PKoujXvAvXORtFWB+7HsDZuj6nFi09C072Rjd1K6L1oa4oibz22g+yM
	 BF6ttiNToW9s1Lw/BSCENAGyEvj9vDZTb1O2Yitr90zdSv2Mt0ppHe6D0/6MEwn5FH
	 nVnj/WMmlXZOpfZHzrlN+apqeGAO031F2aByjXTc=
Date: Fri, 14 Jun 2024 11:53:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-document-damos_migrate_hotcold.patch added to mm-unstable branch
Message-Id: <20240614185344.7F42BC4AF1A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon: document damos_migrate_{hot,cold}
has been added to the -mm mm-unstable branch.  Its filename is
     docs-damon-document-damos_migrate_hotcold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-document-damos_migrate_hotcold.patch

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
Subject: Docs/damon: document damos_migrate_{hot,cold}
Date: Fri, 14 Jun 2024 12:00:09 +0900

This patch adds damon description for "migrate_hot" and "migrate_cold"
actions for both usage and design documents as long as a new
"target_nid" knob to set the migration target node.

Link: https://lkml.kernel.org/r/20240614030010.751-8-honggyu.kim@sk.com
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

 Documentation/admin-guide/mm/damon/usage.rst |    4 ++++
 Documentation/mm/damon/design.rst            |    4 ++++
 2 files changed, 8 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-document-damos_migrate_hotcold
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -300,6 +300,10 @@ from the file and their meaning are same
 The ``apply_interval_us`` file is for setting and getting the scheme's
 :ref:`apply_interval <damon_design_damos>` in microseconds.
 
+The ``target_nid`` file is for setting the migration target node, which is
+only meaningful when the ``action`` is either ``migrate_hot`` or
+``migrate_cold``.
+
 .. _sysfs_access_pattern:
 
 schemes/<N>/access_pattern/
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

mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
mm-migrate-add-mr_damon-to-migrate_reason.patch
mm-damon-paddr-introduce-damos_migrate_cold-action-for-demotion.patch
docs-damon-document-damos_migrate_hotcold.patch


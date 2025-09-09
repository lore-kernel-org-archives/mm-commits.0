Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A6E248F47;
	Tue,  9 Sep 2025 02:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757385464; cv=none; b=Ui0zZ3gRPDhxnuh2vU3hYuvFF2tgeFdX/nY5aOZtBFzBKFHiCw+qsUUR6LtCO+BwOPMU1+DfAlC6z+XHR6bzznXZgi9zdVh6UIxJZPu8DdqnOYu+rtB84KYgwN7O6YFhV7ojjiFXxSGRmbB8QdoX2vrZxaJ2w+7FU/Y//tYPIqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757385464; c=relaxed/simple;
	bh=kRVLLsgKiz2jZLmbrgSJ+pgFZSLBYcixAWmaVgwW9zQ=;
	h=Date:To:From:Subject:Message-Id; b=qyuyEyiDdIK/65B1Bg3H8lrb4IGCxq3HDIJulGno+LWcKmQXncOtmB/HOxHqspId/PNtyuTZE5oL5RpXG9qvToOrGoukVeyC1rAL6dqrrnDBQnKsxon8Os9dj2/IC8iy1s62ExsvqhGW6jhfxEv6imSiaWI4eO/4Afmm6zCQEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kveDjRKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kveDjRKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0655C4CEF8;
	Tue,  9 Sep 2025 02:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385463;
	bh=kRVLLsgKiz2jZLmbrgSJ+pgFZSLBYcixAWmaVgwW9zQ=;
	h=Date:To:From:Subject:From;
	b=kveDjRKRcASJHgB7A5Yqc3IJJHGM9MBHsAQ6E/v2xF03w+SjwWn6g52vWQs8BqB8L
	 LMXnqOaTMnWa1be0ubN1BSIviHUvG2Ea27gFu0wxTix6tUlzVJdFRM5KaYCjGyjwNr
	 lHjOLimy5SeOoNlVF5XPCHE7aTYEK2B2y+sT0C0I=
Date: Mon, 08 Sep 2025 19:37:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-avoid-starting-damon-before-initialization.patch added to mm-hotfixes-unstable branch
Message-Id: <20250909023743.C0655C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: avoid starting DAMON before initialization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-mtier-avoid-starting-damon-before-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-avoid-starting-damon-before-initialization.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: samples/damon/mtier: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:38 -0700

Commit 964314344eab ("samples/damon/mtier: support boot time enable
setup") is somehow incompletely applying the origin patch [1].  It is
missing the part that avoids starting DAMON before module initialization. 
Probably a mistake during a merge has happened.  Fix it by applying the
missed part again.

Link: https://lkml.kernel.org/r/20250909022238.2989-4-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-4-sj@kernel.org [1]
Fixes: 964314344eab ("samples/damon/mtier: support boot time enable setup")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-avoid-starting-damon-before-initialization
+++ a/samples/damon/mtier.c
@@ -208,6 +208,9 @@ static int damon_sample_mtier_enable_sto
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch
mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch
samples-damon-wsse-avoid-starting-damon-before-initialization.patch
samples-damon-prcl-avoid-starting-damon-before-initialization.patch
samples-damon-mtier-avoid-starting-damon-before-initialization.patch
mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch


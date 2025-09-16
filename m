Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8C81DDA1E
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757997219; cv=none; b=KB0NAjy7DBd7/IrU7//IOIHUecYs0m8DaV4B4peT7OMMe8dXanAuRUIUugigTh3IOeoQaw+HcxaC7Z/m3N4KOBIIK/Y6t1GTg6UcyFIzerT1+Fw0WicNbO8dQH1T78xDb5c7kC+HLgIgWBw4gS+/gPUKdHdMG1E/n4vdlCfzJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757997219; c=relaxed/simple;
	bh=ebGvv+iQmdOJ/tYvb9uf9OEdmumIEc/8V/kBxZV6FfA=;
	h=Date:To:From:Subject:Message-Id; b=mg+ibe87DLm0APDAqGynraju6XFdVEhnWQPCKenDXsMtUAcHYB/iU5r+KB1qe1UNWEeekdW0KRCuS4tVFpn7HXouoBfo8ln71ST+rc79hSYwLjY70+yNsJYkqcyZr0ZGGUKC53AvuyYhICQ2V86MvF7xzdENCcpRxSWUj3PWyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dd9t6mUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dd9t6mUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F84C4CEEB;
	Tue, 16 Sep 2025 04:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997217;
	bh=ebGvv+iQmdOJ/tYvb9uf9OEdmumIEc/8V/kBxZV6FfA=;
	h=Date:To:From:Subject:From;
	b=dd9t6mUvKnVrvX57NQDDj7UxATNwX2u3+yWrYXRFnbhOqAIkHOj1lyQunmRSnOnm9
	 fcUe4P8A0hP2jgRDHbyP2M+fBQDi0spnE7GA3iyMzmIO9NNtm49T1fGyeOAKMYzC36
	 FnlcKuBYZHUvciQnU1UclbfZigRSVrvJYM6etzDw=
Date: Mon, 15 Sep 2025 21:33:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-damon_initialized-function.patch added to mm-new branch
Message-Id: <20250916043337.86F84C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement damon_initialized() function
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-implement-damon_initialized-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-damon_initialized-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/damon/core: implement damon_initialized() function
Date: Mon, 15 Sep 2025 20:35:05 -0700

Patch series "mm/damon: define and use DAMON initialization check
function".

If DAMON is used when it is not yet successfully initialized, the caller
could crash.  The DAMON core layer does not providing a reliable way to
see if it is successfully initialized and therefore ready to be used.  As
a result, DAMON API callers are implementing their own hacks to see this. 
The hacks simply assume DAMON should be ready on module init time.  It is
not reliable as DAMON initialization can indeed fail if KMEM_CACHE()
fails, and difficult to maintain as those are duplicates.  Implement a
core layer API function for better reliability and maintainability to
replace the hacks with followup commits.


This patch (of 7):

If DAMON is tried to be used when it is not yet successfully initialized,
the caller could be crashed.  DAMON core layer is not providing a reliable
way to see if it is successfully initialized and therefore ready to be
used, though.  As a result, DAMON API callers are implementing their own
hacks to see it.  The hacks simply assume DAMON should be ready on module
init time.  It is not reliable as DAMON initialization can indeed fail if
KMEM_CACHE() fails, and difficult to maintain as those are duplicates. 
Implement a core layer API function for better reliability and
maintainability to replace the hacks with followup commits.

Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   10 ++++++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damon_initialized-function
+++ a/include/linux/damon.h
@@ -938,6 +938,7 @@ static inline unsigned int damon_max_nr_
 }
 
 
+bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
--- a/mm/damon/core.c~mm-damon-core-implement-damon_initialized-function
+++ a/mm/damon/core.c
@@ -2863,6 +2863,16 @@ void damon_update_region_access_rate(str
 		r->nr_accesses++;
 }
 
+/**
+ * damon_initialized() - Return if DAMON is ready to be used.
+ *
+ * Return: true if DAMON is ready to be used, false otherwise.
+ */
+bool damon_initialized(void)
+{
+	return damon_region_cache != NULL;
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch
mm-damon-core-implement-damon_initialized-function.patch
mm-damon-stat-use-damon_initialized.patch
mm-damon-reclaim-use-damon_initialized.patch
mm-damon-lru_sort-use-damon_initialized.patch
samples-damon-wsse-use-damon_initialized.patch
samples-damon-prcl-use-damon_initialized.patch
samples-damon-mtier-use-damon_initialized.patch


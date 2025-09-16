Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77A12A1CF
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757997227; cv=none; b=sYuaWEE3fnscVXjAaRDW+jLcVA2XjDPlXcnNQIMedMpK4JxrvT+Ko4N9KxtgkmKXOC5LU9q05djU/pMpwo8qJLTtklLrZnz5+4m8USjnkt8Y9TwxwRChbpCMsNYFqhchhxztbsIoFiblRgpNDwny+56Q6tI8lK7bypIAHad+xic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757997227; c=relaxed/simple;
	bh=J8q3NOib6FsvNStuhzsO815Vs39Mm1cfxYfzK4Sm3Pw=;
	h=Date:To:From:Subject:Message-Id; b=YWlNDZ4Jyn1rFd2QhnLA1eYvLN22pfBZ9yGg8JgU7pSG7Jk132JW6sR3h0DHsrJULIahnIM7rq0ABF64udNJEHb1X7nckK+dm1mHhLtTbtHfEdGeDHt7/c3cahRNErD4HrFqNDLO0Jrj9doAEsJIy40aN693sAiyn4Lt9vDvVxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4zk8Elh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4zk8Elh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F890C4CEEB;
	Tue, 16 Sep 2025 04:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997227;
	bh=J8q3NOib6FsvNStuhzsO815Vs39Mm1cfxYfzK4Sm3Pw=;
	h=Date:To:From:Subject:From;
	b=P4zk8Elh0FzspoWoqL3+w98nY2J5AgjeQtkRfdG7GLeZgiBXTiuudnjBr86Djj2ev
	 /FtGJsOB9snFrpEb165aNmgCon/dT8gXQIhHL+507ArJPQ57CeRRcoBvUiTAGRCAdg
	 Z9dx8+ODIalxSo0pfl0Gfs+V5bl/EIy0YIa6oXHc=
Date: Mon, 15 Sep 2025 21:33:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-use-damon_initialized.patch added to mm-new branch
Message-Id: <20250916043347.4F890C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: use damon_initialized()
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-prcl-use-damon_initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-use-damon_initialized.patch

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
Subject: samples/damon/prcl: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:10 -0700

damon_sample_prcl is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-use-damon_initialized
+++ a/samples/damon/prcl.c
@@ -122,8 +122,6 @@ static void damon_sample_prcl_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -137,7 +135,7 @@ static int damon_sample_prcl_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -154,7 +152,12 @@ static int __init damon_sample_prcl_init
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		return -ENOMEM;
+	}
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
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


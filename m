Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A498627281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490022; cv=none; b=gLwlnTqL4pGDlV/RYWlXvVdOiZ7qrHYfi8B6odzC7lifCfiTCjm/P0faxUcNzlfjqoUtdOvt0nL/qjWtWz29i9rmVh8VqgoKplPGQksTVwgnyrnIKxwS2031/OtqcznAed9T+5tlgSaG65ci/NlMrsU80G2GPd0Nfa9QTmbL9uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490022; c=relaxed/simple;
	bh=6FsvT1HKKilUav+WISCuIQgpxKu2Ipj674sa24wIEf4=;
	h=Date:To:From:Subject:Message-Id; b=Eky48lNT0vLMtRliqqdawWUooQFLQ4BevGqZhugXOM1AK/C7hq1feolPuRthStCvoVlIG9OfqbYjOOMggdgFuzaOC8MTDx3iahd+GjlFz4PIQzBgOdsIPlLmnY5Uk3TNPemlM5sU2Iya24hmzIXdq4sPiShyObRS6nNvkJVPxOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CyE4J3ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CyE4J3ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7987FC4CEE7;
	Sun, 21 Sep 2025 21:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490022;
	bh=6FsvT1HKKilUav+WISCuIQgpxKu2Ipj674sa24wIEf4=;
	h=Date:To:From:Subject:From;
	b=CyE4J3ya2rL7YvDPQcj49v/dOXANu/bZ+RKuUw9li5TT48sndZ0vzt6obhzebvnFT
	 pZuwwfM80VujJ/W1VMF1rnmNQpWxq5JsyDh6YKKiHUjXxgapSFc+YQGWL5qrwSzgw9
	 h1sRf9dnMYLN652z4cCu5kxpkXfhPITgYxix24Ks=
Date: Sun, 21 Sep 2025 14:27:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212702.7987FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:06 -0700

DAMON_STAT is assuming DAMON is ready to use in module_init time, and uses
its own hack to see if it is the time.  Use damon_initialized(), which is
a way for seeing if DAMON is ready to be used that is more reliable and
better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-damon_initialized
+++ a/mm/damon/stat.c
@@ -214,8 +214,6 @@ static void damon_stat_stop(void)
 	damon_destroy_ctx(damon_stat_context);
 }
 
-static bool damon_stat_init_called;
-
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -229,7 +227,7 @@ static int damon_stat_enabled_store(
 	if (is_enabled == enabled)
 		return 0;
 
-	if (!damon_stat_init_called)
+	if (!damon_initialized())
 		/*
 		 * probably called from command line parsing (parse_args()).
 		 * Cannot call damon_new_ctx().  Let damon_stat_init() handle.
@@ -250,12 +248,16 @@ static int __init damon_stat_init(void)
 {
 	int err = 0;
 
-	damon_stat_init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* probably set via command line */
 	if (enabled)
 		err = damon_stat_start();
 
+out:
 	if (err && enabled)
 		enabled = false;
 	return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch


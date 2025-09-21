Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19327281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490027; cv=none; b=jj43TQ/8dkTNQ6MwIWjBXsOhZ3kCJjNY0IJrOQbecj0prt60iREXCHQCTmVBuL7iC5tXLG8BntyzzClIIoy93FmxOYSJBRVG1sKTT6QyQrIagUmWoinvwTnUJ9KTVLcB8Ue/W1ql7/8F4xF1/Ng39B2tDF3ScCytVbdXiVMm8Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490027; c=relaxed/simple;
	bh=g1ZDW+oTL+JgHQfw53J92vxxKXmchfxmwEOjKGwXSQ8=;
	h=Date:To:From:Subject:Message-Id; b=W5xEEL0vVntS35l03JlrwpLZW0kAhNTLcmBgdsbRDV6HcuT0DGkqK9YD7FYvwtFbJgRQ/KfzLeIUov8sCseLwtbSGowEZTu6BzblSkQD+WA8RCwL6kOOGz2NLUrsfs+3gnxiitE4RS2C8D/eGB2phwj3J3jBSnzm4s5MOug2Gps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSn9YU+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSn9YU+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F6C4CEE7;
	Sun, 21 Sep 2025 21:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490026;
	bh=g1ZDW+oTL+JgHQfw53J92vxxKXmchfxmwEOjKGwXSQ8=;
	h=Date:To:From:Subject:From;
	b=FSn9YU+7HO5DZQoPO4c7LakZEHQnHdjWFWCMoMOf+LNkGTUNG3lSh86YhQR0ccb3V
	 MgUXgKd3MADaYSCYLauLFCk9aHnYA+dNqBm7m/Z/RRBXpRUtMp+oGX5voQUaRjUSVC
	 r7VSEQKVO4E66NbQ3yg8toOyC6dEJP9cfqre3lUo=
Date: Sun, 21 Sep 2025 14:27:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212706.C04F6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch


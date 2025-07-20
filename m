Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F61E7DA6A
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976937; cv=none; b=LRB2daz1lMFHBNWgUBPrf0ZVdQo/xmWFxCLMN4pFxBnLsg4tcuE7t9yd+k3mTmEMYF+auC3XLUYIOOI19I5jdBzODEPSHkIHWUa2hvP0K6Ata+Ags8pp7/v2LrtNS7UXozpVCPWsynBtASBKjMeQCvGhNwH6X2tIFi4OE9ejEBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976937; c=relaxed/simple;
	bh=N7ly342Ejn5AMbuM1UbtLpPDy8C8GYhrzK1AIb14vAY=;
	h=Date:To:From:Subject:Message-Id; b=KxRSanZiOTJ7bWLdGvPQLbz8pf5IGxGPuAwwU7ZiNpTMcw/f/VTUagESccMQ7lDV+AcRvMj2adaxe9WBOSZ7BfK6w2HfpjIx1nSv2d5bIHeqkNvYrHPz4a2NjYN5DfmZoyRTof1Z/Ryjs2qKWuk1oTjg57Shq6cdhawjqKPtk/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pahew9UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pahew9UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038E4C4CEE3;
	Sun, 20 Jul 2025 02:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976937;
	bh=N7ly342Ejn5AMbuM1UbtLpPDy8C8GYhrzK1AIb14vAY=;
	h=Date:To:From:Subject:From;
	b=Pahew9UI3WJcOOswQq8rS6gBUl6Y5HYKGpTR+V3YSbwwOHX24mhtTv+1T/fyOs0J2
	 cU7H96LFU4bIcuLykXd4ViiqwQZrz8bU7JEuHOa548n/ch5gTvuYeqxhmPtC02atGl
	 vb3JnfgVj/xmFA/u2l79Ic8c+ka6ISgGZW7L8U30=
Date: Sat, 19 Jul 2025 19:02:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch removed from -mm tree
Message-Id: <20250720020217.038E4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: do not call ops.cleanup() when destroying targets
has been removed from the -mm tree.  Its filename was
     mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do not call ops.cleanup() when destroying targets
Date: Sat, 12 Jul 2025 12:50:10 -0700

damon_operations.cleanup() is documented to be called for kdamond
termination, but also being called for targets destruction, which is done
for any damon_ctx destruction.  Nobody is using the callback for now,
though.  Remove the cleanup() call under the destruction.

Link: https://lkml.kernel.org/r/20250712195016.151108-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-not-call-opscleanup-when-destroying-targets
+++ a/mm/damon/core.c
@@ -550,11 +550,6 @@ static void damon_destroy_targets(struct
 {
 	struct damon_target *t, *next_t;
 
-	if (ctx->ops.cleanup) {
-		ctx->ops.cleanup(ctx);
-		return;
-	}
-
 	damon_for_each_target_safe(t, next_t, ctx)
 		damon_destroy_target(t);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch


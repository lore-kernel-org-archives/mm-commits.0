Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0D6664C6;
	Tue, 31 Dec 2024 02:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610416; cv=none; b=HhT+EVwPNN/RG2ShhmCptYHfG2oIYyGb2BL5xXV3wwCC5xhfbQj7od2oYyJ0B7lakITOzj5rmzLvvFBRWvaCCOnFXFJQX7al2SS2EnNnZ2Z/j2sbIDSBvVKJ8+evlMBaf8nK42NsQPRgsjrUrm6L7tlBDTMHmW450PnBrV7KX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610416; c=relaxed/simple;
	bh=hh76XRgYnj5YKE5EAtXnRWYiimkHKfqhn6X9B1+d/pE=;
	h=Date:To:From:Subject:Message-Id; b=PD+PCR2nzQczTiCDbl620CwC2LecBcT15i23kqkUbf3/ZzhkJ0cn+I9EjFkdmKeA6IS8mR3HcDjnh3sDobnCeTfD7VtM6FYeAfIKAbbh232n59HPcg82beLjxt1dDmXJELRGt+EgF1aB1eEovE2Cmqabc+xRyQAplw86CRyzMJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bPMR+6tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPMR+6tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41830C4CED0;
	Tue, 31 Dec 2024 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610416;
	bh=hh76XRgYnj5YKE5EAtXnRWYiimkHKfqhn6X9B1+d/pE=;
	h=Date:To:From:Subject:From;
	b=bPMR+6tbDWWJk7r0fiEeamzL04vuGCi7opUdJXneCBeOz6GXBnxTTmEQ7rPTTPJZx
	 5eA56YPFvCJkF6OnV7uEKBSo1GBDTRp4k9kQoLr4pOsPO9HmjykgcsRFQ/onLHWXwJ
	 W7cD9SNgja/3Mp27+Zr6giJBnCvOWhM8VSBQbKu0=
Date: Mon, 30 Dec 2024 18:00:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch removed from -mm tree
Message-Id: <20241231020016.41830C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
Date: Sun, 22 Dec 2024 15:12:21 -0800

Patch series "mm/damon/core: fix memory leaks and ignored inputs from
damon_commit_ctx()".

Due to two bugs in damon_commit_targets() and damon_commit_schemes(),
which are called from damon_commit_ctx(), some user inputs can be ignored,
and some mmeory objects can be leaked.  Fix those.

Note that only DAMON sysfs interface users are affected.  Other DAMON core
API user modules that more focused more on simple and dedicated production
usages, including DAMON_RECLAIM and DAMON_LRU_SORT are not using the buggy
function in the way, so not affected.


This patch (of 2):

When new DAMON targets are added via damon_commit_targets(), the newly
created targets are not deallocated when updating the internal data
(damon_commit_target()) is failed.  Worse yet, even if the setup is
successfully done, the new target is not linked to the context.  Hence,
the new targets are always leaked regardless of the internal data setup
failure.  Fix the leaks.

Link: https://lkml.kernel.org/r/20241222231222.85060-2-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets
+++ a/mm/damon/core.c
@@ -961,8 +961,11 @@ static int damon_commit_targets(
 			return -ENOMEM;
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src));
-		if (err)
+		if (err) {
+			damon_destroy_target(new_target);
 			return err;
+		}
+		damon_add_target(dst, new_target);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch


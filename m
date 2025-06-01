Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D9F1411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756832; cv=none; b=ic3xLLKGGH40ds8B9okObMHMINcv9RlNNe1alWOwkXtosxqtKOFhfWGMLKR1bHBBlO9CwW6Pu8PEvXMSeLZet1Xy5arTTkCXJ0m4jLp1jQDA+VuyCjoUUgyz5XBSGS07HsYo2R08FOCREpTkZkkmAyHNYKk7mhUyRcTKNxzsFSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756832; c=relaxed/simple;
	bh=DIJCMwz0/RkdZf8gP3TfCZ8vK/10RDfnUozHJGzDi6A=;
	h=Date:To:From:Subject:Message-Id; b=sqc/SFY7wYn0Imqvx74xDy8nGb6990jhnsKxnvisa8N3nyqrRXf43UtLU4sr9Sn5eo7NVm8rVZpvX4Q25toUrU0LXcVxf5CktDmxzWdDCMGFf8BYeWoNRhZfzH1XPp4gNEInbmNYrmK0TM9NcfMYX/N6FF1s2BGHq+6xDiUtABw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VHXY3wfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VHXY3wfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC3DC4CEED;
	Sun,  1 Jun 2025 05:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756831;
	bh=DIJCMwz0/RkdZf8gP3TfCZ8vK/10RDfnUozHJGzDi6A=;
	h=Date:To:From:Subject:From;
	b=VHXY3wfHVYwJl6U7kVCWBzgmH1xyqvO8hIxWi7wwp7u+vmWzn0dG5EOi/1vq3haT7
	 R8wxzTQAiIOpd0VaIz3t9hwSXgMZFFbDBT8DZUvVdjc7nBcFcbtrm7b4prmJULVgeU
	 HESyTiCiN8huyYzrLSwrvsVfNy1q/DX6OFyaURIU=
Date: Sat, 31 May 2025 22:47:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch removed from -mm tree
Message-Id: <20250601054711.9DC3DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: avoid destroyed target reference from DAMOS quota
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon/core: avoid destroyed target reference from DAMOS quota
Date: Sat, 17 May 2025 23:18:52 +0900

When the number of the monitoring targets in running contexts is reduced,
there may be DAMOS quotas referencing the targets that will be destroyed.

Applying the scheme action for such DAMOS scheme will be skipped forever
looking for the starting part of the region for the destroyed monitoring
target.

To fix this issue, when the monitoring target is destroyed, reset the
starting part for all DAMOS quotas that reference the target.

Link: https://lkml.kernel.org/r/20250517141852.142802-1-akinobu.mita@gmail.com
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-avoid-destroyed-target-reference-from-damos-quota
+++ a/mm/damon/core.c
@@ -1093,9 +1093,17 @@ static int damon_commit_targets(
 			if (err)
 				return err;
 		} else {
+			struct damos *s;
+
 			if (damon_target_has_pid(dst))
 				put_pid(dst_target->pid);
 			damon_destroy_target(dst_target);
+			damon_for_each_scheme(s, dst) {
+				if (s->quota.charge_target_from == dst_target) {
+					s->quota.charge_target_from = NULL;
+					s->quota.charge_addr_from = 0;
+				}
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are



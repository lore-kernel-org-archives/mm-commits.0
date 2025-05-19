Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1933D21CA0C
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694651; cv=none; b=nwyN8kBwCeiO6NijFcf8XS8V78JWb/3QFZuLRmKBzTaSBNePpjhgJR3hy3IEh7bBcGEclUUeUKy+wHrlCY9UcBzFs/mVZnntyDbGLebEW5ebyAvVm8M+xdESiwnBGDOJbiDekgmKW59F6LVdU/H2aDxh67sjQCamcPYu0vWP6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694651; c=relaxed/simple;
	bh=YZJ1g/WskgJ6XxDVuB35W93jMAKCj/VT5Gu/6ErF2Lg=;
	h=Date:To:From:Subject:Message-Id; b=n3jR3GxeOxr8xl2UT7KED1vPajOclPQ6LvfEFLXA+tP4WFUV/eQHFM/5CyGWUWecs0SjEnAZ1sjAOuPFdi1iw8XEt813Y82WO2xUWsQ+nd9Gl7L4jp+N8IgFgr1a1qXUTHQUzY0d6N6tY0f6lVOTV+alcByQyzfdvo53zRRf+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1wrrFs2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1wrrFs2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B29CC4CEE4;
	Mon, 19 May 2025 22:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747694649;
	bh=YZJ1g/WskgJ6XxDVuB35W93jMAKCj/VT5Gu/6ErF2Lg=;
	h=Date:To:From:Subject:From;
	b=1wrrFs2/DMa2UZUzhelO2OlR8hfHvOXTiAxFpAU3XgOm2T+LfsyRZ77PfK/mSTD/b
	 FbTmWu1M0InaxX3LhD+WPzytAfrhKLpKNwNrF6ZBrAlSvUxX2sNz/NOFfzy5gGoKqu
	 /lvbxYx8FM6NzJvdoM5eFat4j7NZfLG3xtxAr54U=
Date: Mon, 19 May 2025 15:44:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch added to mm-new branch
Message-Id: <20250519224409.5B29CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: avoid destroyed target reference from DAMOS quota
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch

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

mm-damon-core-avoid-destroyed-target-reference-from-damos-quota.patch


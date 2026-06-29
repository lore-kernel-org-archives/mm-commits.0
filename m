Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954A816DEB1;
	Mon, 29 Jun 2026 04:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708936; cv=none; b=IItTz5m+0/CvH4UOa5BaJswC4M7aFCArKEnBniP1tLykr19KKIj6BIHHUA4X+B8wuuUPwe009Zi5VtZ8l4RgAgDK+jYQbyyp7goUWRwBf1IEZ/ORT73ndeq1O9AeiFVvlNswhZt8PFcZup2FHzo10V6voXPoedmbXLevZEABYfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708936; c=relaxed/simple;
	bh=30fQ+qyTw5uaroHIsxExRVlDtxsuQcrhnVkiuXLcKSI=;
	h=Date:To:From:Subject:Message-Id; b=IJwicRPJeodokSCIg5E/mM5p7qAMfXHl7dpJeqLGZU9sw6Q79lKkGEYwivrUH2MNVGuDS4xT+SDKrd5r6usonHpcAXcm9luqPLPw5NMPbKje/HU2eUetlEwt97h56rdY2h6LRT/mvQcKATplOoi1U87ZoKn5vUtrPr54SLLkbyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fn0sHgVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fn0sHgVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7521F000E9;
	Mon, 29 Jun 2026 04:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708935;
	bh=22ieR5B5jsR1Oni3QT5o66WWA2bZMz4TWo1T4D0wvE0=;
	h=Date:To:From:Subject;
	b=Fn0sHgViD92saxYrSJ5S944MHUEZeranBPzTa5xT4UnI2XSckEbnyLxpjzFBdEE0b
	 yIQvjhPzKxX5Zf4az1LMQ++RSAOfT8dDUCwjQeYw/JEs7+3EzfG0LvmaqD1KhtF2gl
	 0ESlpmGcmta7YkmD0UDYg0QLJpLdJLw2Lw0ePFfk=
Date: Sun, 28 Jun 2026 21:55:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch added to mm-new branch
Message-Id: <20260629045535.3E7521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Sun, 28 Jun 2026 15:01:16 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-8-sj@kernel.org
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs
+++ a/mm/damon/sysfs-schemes.c
@@ -2143,8 +2143,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch


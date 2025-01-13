Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFCC2AF09
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741653; cv=none; b=DTn2rOJhxVgwCvYSwp4cFUUZa9Kqx58MKnY05nxb8qBxiX4046b/8Bh2z3swqk64xP4uRsty+7zeUGKe8AJpGEb+9QcJtb2OpE1dRtqPgPcnQIMchivOYKXmA6fHJgj8SE/yPx5QbAAPwTiYriouYmaS3q61l9EZJzK4x9NxfII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741653; c=relaxed/simple;
	bh=kyWXwgzYsOKwscijvacLKQeHfGLanYDUx8POuJErhEo=;
	h=Date:To:From:Subject:Message-Id; b=LQxoxKypJtW4jE8rLqEWucrs3SZY2mGFpBviu1Fp10Hhe1JujaFV0o+PTtuwzX5e9MAvIBVZrIsxegMOIrb0l3Q6FD9fELWl732K9noJ+zgxNrqpQ1bn9V141lO5rzHobkCrTHrDC0Ypn7cUYAT0y0wz+Fp6u2XOnXA/5h526JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0Q+5rE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0Q+5rE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C3C4CED6;
	Mon, 13 Jan 2025 04:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741651;
	bh=kyWXwgzYsOKwscijvacLKQeHfGLanYDUx8POuJErhEo=;
	h=Date:To:From:Subject:From;
	b=O0Q+5rE5ChOrTlauODSPUNS7D0/henPHBrWJKJBhRZiqmhrprKXT8UzGhs0bW91yq
	 yE6oNZoWuygviA908qWht1tB7PC5PwnYNs7zIpwjbaCFaXWrMDz5nkATbEXdaIBUPs
	 U2LBgQ4BUfiepMkKdqcx93gIQRYWOsWhSVEz29EY=
Date: Sun, 12 Jan 2025 20:14:11 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,apw@canonical.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] checkpatch-check-return-of-git_commit_info-fix.patch removed from -mm tree
Message-Id: <20250113041411.859C3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch-check-return-of-git_commit_info-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-check-return-of-git_commit_info-fix.patch

This patch was dropped because it was folded into checkpatch-check-return-of-git_commit_info.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-check-return-of-git_commit_info-fix
Date: Mon Jan  6 06:16:23 PM PST 2025

s/12 chars of sha1/12+ chars of sha1/, per Jon

Link: https://lkml.kernel.org/r/87o70kt232.fsf@trenco.lwn.net
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-check-return-of-git_commit_info-fix
+++ a/scripts/checkpatch.pl
@@ -3240,7 +3240,7 @@ sub process {
 			if (defined($cid) && ($ctitle ne $title || $tag_case || $tag_space || $id_length || $id_case || !$title_has_quotes)) {
 				my $fixed = "Fixes: $cid (\"$ctitle\")";
 				if (WARN("BAD_FIXES_TAG",
-				     "Please use correct Fixes: style 'Fixes: <12 chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
+				     "Please use correct Fixes: style 'Fixes: <12+ chars of sha1> (\"<title line>\")' - ie: '$fixed'\n" . $herecurr) &&
 				    $fix) {
 					$fixed[$fixlinenr] = $fixed;
 				}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
checkpatch-check-return-of-git_commit_info.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch
hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch


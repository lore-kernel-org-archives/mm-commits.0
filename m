Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA14D38DE0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957135; cv=none; b=DV+hMaCkj01TwqV9+WxEuLmJEywVkEF9tfH1qSp9F+r0r4n79PkFOZrgVP5sdEXhLzCm6KweWobyK3QEq6TGAcbGkyHcqjYP4JXre5sUaCACgw8yt/eT2p5048jqDzDaReae9tcUdsyWQl/cxONcbNG+OOjPHk4sCOrJt3CxC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957135; c=relaxed/simple;
	bh=nfCMdRCG2m7Km5hs4Y5Y+L7WupmHQlXkY/pIefNOP+E=;
	h=Date:To:From:Subject:Message-Id; b=nbPewP6u3nvrgzkSj+2rnkanBuM2fNQ+72m6hG+hpYFRoe3Zx46zivf2q/pN4bGa5ORupNk3uIae/bPvv0Dnr/wEnT3Qz2caf1D0SN80UPMHq2kR/OS/wV3MdzTVa5CMvGkTe9HFHK7DtwTNP5Aj53qkcDWL+qKmofTk1IloH7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CC7LSi3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CC7LSi3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81166C113CC;
	Mon,  6 May 2024 00:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957135;
	bh=nfCMdRCG2m7Km5hs4Y5Y+L7WupmHQlXkY/pIefNOP+E=;
	h=Date:To:From:Subject:From;
	b=CC7LSi3yyldVDzYqVyg7+w2Bd0oJYsimiN7+4P6ZG5L5JkgFnv9qb3DFlQyISkdCK
	 l1pWDl7Edj1mteceFZsh0uYV0pGx49Rdb5Q2fzIHbnOgi1kO6Xt8j0063ssciMjviN
	 Mn8FBS/RZYRnEfFMN0/SiEeIA1JzqYqhw26RSIlM=
Date: Sun, 05 May 2024 17:58:55 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-youg-page-type-damos-filter.patch removed from -mm tree
Message-Id: <20240506005855.81166C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: update for 'youg page' type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-youg-page-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for 'youg page' type DAMOS filter
Date: Fri, 26 Apr 2024 12:52:46 -0700

Update DAMON ABI document for the newly added DAMO filter type, 'young
page'.

Link: https://lkml.kernel.org/r/20240426195247.100306-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-youg-page-type-damos-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -314,9 +314,9 @@ Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
-		'memcg' for specific memory cgroup, 'addr' for address range
-		(an open-ended interval), or 'target' for DAMON monitoring
-		target can be written and read.
+		'memcg' for specific memory cgroup, 'young' for young pages,
+		'addr' for address range (an open-ended interval), or 'target'
+		for DAMON monitoring target can be written and read.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
 Date:		Dec 2022
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch


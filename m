Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C457C6D4
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423599; cv=none; b=o+7hjHivHVI5ZwZ/FCXuKVwq5aHQ1mwKeg7Ct/bg//tk1UMzxWQRsREf2o3hw8eFHNsAi07GWE7Sv/BDLZHAqUPwbqw3mLKqZ94ku+9fY1rtjf5xoq+ZNtjLXp7yY3uTFHMK52uG+7MCA4cCEsb2CnG+eezwav8L4rS5zuBftWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423599; c=relaxed/simple;
	bh=fFgG+Plq1EEqkCY+3vOEIyEDQhSjSGii3KFFqXpKEik=;
	h=Date:To:From:Subject:Message-Id; b=qwLZf7CZ5/dKLmAdkxklbe4Npkq+f7G//kIg2O8hkozbbpKiHqW6v/2TufCGBlI++MvHJXsmcZdRDimZZmJIEd5xRU6nM26xkxeqeZ6QiQA0sVii720OCoa2pB4QA+qEHRPCeNf8x3LkG9qf2gsH5Gcs0OqK3fyxMPlZYTbyOnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fN2NNMwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fN2NNMwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E69C4CEC2;
	Wed,  4 Sep 2024 04:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423599;
	bh=fFgG+Plq1EEqkCY+3vOEIyEDQhSjSGii3KFFqXpKEik=;
	h=Date:To:From:Subject:From;
	b=fN2NNMwTWB01L/bsAoZIe8u4xU+BJa/N8Z/S7sEikwPLKvbPhi8EuXy6OxbQkoFdF
	 fssQR8CPpn9r4igcfIKrCH0IqtgO001zMSXW3+IZ1PXYmlUOQRsZOi3ZKxujh01yFR
	 FPGmIgT3Ithw2m0qzMKpBrJQg3k19ZhUIWie39Qg=
Date: Tue, 03 Sep 2024 21:19:59 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-access_memory_even-to-gitignore.patch removed from -mm tree
Message-Id: <20240904041959.87E69C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add access_memory_even to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-access_memory_even-to-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add access_memory_even to .gitignore
Date: Mon, 26 Aug 2024 20:03:28 -0700

Patch series "misc fixups for DAMON {self,kunit} tests".

This patchset is for minor fixups of DAMON selftests and kunit tests. 
First three patches make DAMON selftests more cleanly maintained (patches
1 and 2) without unnecessary warnings (patch 3).  Following six patches
remove unnecessary test case (patch 4), handle configs combinations that
can make tests fail (patches 5-7), reorganize the test files following the
new guideline (patch 8), and add reference kunitconfig for DAMON kunit
tests (patch 9).


This patch (of 9):

DAMON selftests build access_memory_even, but its not on the .gitignore
list.  Add it to make 'git status' output cleaner.

Link: https://lkml.kernel.org/r/20240827030336.7930-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240827030336.7930-2-sj@kernel.org
Fixes: c94df805c774 ("selftests/damon: implement a program for even-numbered memory regions access")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-access_memory_even-to-gitignore
+++ a/tools/testing/selftests/damon/.gitignore
@@ -3,3 +3,4 @@ huge_count_read_write
 debugfs_target_ids_read_before_terminate_race
 debugfs_target_ids_pid_leak
 access_memory
+access_memory_even
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch


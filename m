Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE34A356A32
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966126; cv=none; b=PUYt5IeI4u0UtWmqF9IN4DfLkKROLhjl/RP1OoEcKQ3lFyxTrROSAKrT5EIg4JG+XUwj3tpaFyiPKziAPOHL/n9LQXuTKGdlA8Py4L94GZJ95MYoHSrRMrgcPFKnwbUxMtG5ylzgkqAvvDek/BHtUdooAeNZv177rUCb8Jb0TE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966126; c=relaxed/simple;
	bh=24TNK0CeNviIzQrKW7galE2T6DWb0J6si1vNsJ6JoqU=;
	h=Date:To:From:Subject:Message-Id; b=JqC3ofvGgKc6iulMgpP6g4vKNXpQ6hIEEiv/mEpGMKvDd5jwAr4eQyv6IpbVp51vQjGe8eQ2Zlf1vDoC9p8LNosUwCCl0xFAAzZnFxvHlypYMlU0+fNRd3dPO7sYOTDuA9FH/MwxljbIAhLSygaZTHosdxQTPHQcMOCNPx+H7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5/dAGy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5/dAGy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A6C16AAE;
	Wed, 21 Jan 2026 03:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966125;
	bh=24TNK0CeNviIzQrKW7galE2T6DWb0J6si1vNsJ6JoqU=;
	h=Date:To:From:Subject:From;
	b=Z5/dAGy1j9+Hj3tPHdbvRBZ+KXDuKeoTocRfHwVrrFl3eGvHMvigtb8sooINRnl8k
	 nmGcGFKtsForht7t0b++7xARddS5SlM2jsuHGdSaegaEGExImG7onwoISGQPURCeXa
	 ZWhbxfCbDR+wU+EznA2klNBX7rs5dYQ8xWOYi6jE=
Date: Tue, 20 Jan 2026 19:28:44 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch removed from -mm tree
Message-Id: <20260121032845.5F6A6C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
Date: Wed, 24 Dec 2025 04:22:00 +0000

Remove a redundant test case from damos_test_commit_quota_goal() as it is
already covered.  Instead, add a new test for DAMOS_QUOTA_SOME_MEM_PSI_US,
which was previously not tested.

Link: https://lkml.kernel.org/r/20251224042200.2061847-6-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal
+++ a/mm/damon/tests/core-kunit.h
@@ -600,9 +600,10 @@ static void damos_test_commit_quota_goal
 			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal) {
-			.metric = DAMOS_QUOTA_USER_INPUT,
-			.target_value = 789,
-			.current_value = 12,
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
 			});
 }
 
_

Patches currently in -mm which might be from shu17az@gmail.com are



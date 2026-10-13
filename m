Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0F9481A98
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865974; cv=none; b=ga5LwRClyCenwMoD5rxq1xhcjOe2fQUydEuc4gdhWj59LQT3BzDHYFqNW6mGIY5XrH/9DRc5aVmeZNArYGX+Xa9nqa5JJ41o71m005y2dLAxtFlbDc0Xhv79XkMPA3qwtOEHapnZzluwADiIChLp39Kws8qiAYtpNjuhUo5fvXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865974; c=relaxed/simple;
	bh=JDOZf1da29zFHitbZ8TLSleZG3D1I2j57tURklpTEb4=;
	h=Date:To:From:Subject:Message-Id; b=aG7ZwuImunkdPLqepqIY3hopaoXGZbAh0iIF7lhT2FOAso14xMykJDPp4zWqttezDygNMG9MqpUwksisrlZuJIWSMBtcc173OLmN4L6SAnQjotS8fTkpqwh+v+nqyOHiK7ard6kSWbMh/BczYyHaU7t7LkRKqVWuaxIsDxmNwLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xSlUqlg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xSlUqlg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129E1F00893;
	Tue, 13 Oct 2026 04:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865973;
	bh=pbDpSC+RgJRgH9ei9nN2u6bnPzmSYXwNPrnPpdDJsjM=;
	h=Date:To:From:Subject;
	b=xSlUqlg1rU9K3WCz70z3cCzfROiW0vpnyHvSYQcOVPt2P4CCicu5LrKfIjta/itfF
	 wo47OMe3jSLwPzXIJe1UYdqltWiuKs6v0OvuPZL1Lv2eSm4ToXJtCJx5bIZvEvze6j
	 zEGwwJWCUr2eVVm2lWm6Q9Gean4UH3KJh804icgk=
Date: Mon, 12 Oct 2026 21:32:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch removed from -mm tree
Message-Id: <20261013043253.6129E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test eligible_mem_bp commitment
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: test eligible_mem_bp commitment
Date: Thu, 17 Sep 2026 07:22:05 -0700

There was a DAMOS quota goal commit bug [1] that doesn't update the nid
field for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric goal.  Add a kunit
test case for confirming nid commitment.

Link: https://lore.kernel.org/20260917142210.90829-8-sj@kernel.org
Link: https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/tests/core-kunit.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment
+++ a/mm/damon/tests/core-kunit.h
@@ -835,6 +835,9 @@ static void damos_test_commit_quota_goal
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
 	default:
 		break;
 	}
@@ -898,6 +901,13 @@ static void damos_test_commit_quota_goal
 			.current_value = 345,
 			.last_psi_total = 567,
 			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
 }
 
 static void damos_test_commit_quota_goals_for(struct kunit *test,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA80C484889
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865980; cv=none; b=SJtW5p3VC/jYlH6cMQYxliwK+mB/PH/WYZ/bDTpv52UdX3SWCp9aA+HCaoKrIjJHiF5peX7rgyCTTzTwbzzLG3OilIVIju6Lj70vIImJovFyJMZQ6P+d5rnKz1CLfH/6IiM3C49n/nRGeZHXNL74cyUV7qHgqzttUZUI31u7rMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865980; c=relaxed/simple;
	bh=uIX9evh7QDIZO7WqLN0jYtMZUP6XyIjPIq9uoW6vxTo=;
	h=Date:To:From:Subject:Message-Id; b=WjfV4Kos+4uwH6zSbLA31Vqxg0Ve5DReTfY7GM8pOoHBDpjk0VeaygWnclY0rkmSwqP+y71gd2s+qmxE5Fk6ljXhaHBgxwYlVebSHB4rb+/8COMCkybdm/Gc6Lp8xEXBbT3QD1ojha3JSE6asheRCukPyiJjtwrTudnr+sV3EZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0VC4EENg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0VC4EENg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815191F000FF;
	Tue, 13 Oct 2026 04:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865976;
	bh=NudKbIngZc8mMJsXlUx+D9gJcjksHbvmZFoGRpoHvEw=;
	h=Date:To:From:Subject;
	b=0VC4EENgNoT4eeMStqHkEvSQRxOUAv9c8i1YyfzOgW4pBX43aWrYD8CXsR6HCoJs3
	 YNnezPIxEpARU+skr0Q+EsgorzYYQuFDIeka0Y9Q/06oQNmoIvvxoisI18Rybn8M+/
	 w182IAOo/VCNJPL9rcAhO6ACnx/xNxNBVBgamCvA=
Date: Mon, 12 Oct 2026 21:32:56 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-clarify-bp-is-basis-point.patch removed from -mm tree
Message-Id: <20261013043256.815191F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: clarify bp is basis point
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-clarify-bp-is-basis-point.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/design: clarify bp is basis point
Date: Thu, 17 Sep 2026 07:22:08 -0700

DAMON design document uses "bp" for "basis point" in multiple places.
Because it is not clearly mentioned, it is difficult to understand what
"bp" stands for.  Add the clarification.

Link: https://lore.kernel.org/20260917142210.90829-11-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-bp-is-basis-point
+++ a/Documentation/mm/damon/design.rst
@@ -445,7 +445,7 @@ users to set the aimed amount of access
 given time interval.  The target can be specified by the user as a ratio of
 DAMON-observed access events to the theoretical maximum amount of the events
 (``access_bp``) that measured within a given number of aggregations
-(``aggrs``).
+(``aggrs``).  The ratio is in basis point (bp or 1/10,000).
 
 The DAMON-observed access events are calculated in byte granularity based on
 DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
@@ -717,7 +717,8 @@ mechanism tries to make ``current_value`
   in microseconds that measured from last quota reset to next quota reset.
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
-- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
+- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in basis point
+  (bp or 1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
 - ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
   specific NUMA node, in bp (1/10,000).
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


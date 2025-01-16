Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51690186E40
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006287; cv=none; b=M8D3WYmLnHuTEwyRf6s0hc5fK97jVF4omMyHcwxYy2peTv58YlVf86xdBWZyabM9/rOuK9ZUqZaaHAQ55cmagWxuk414wFrYd9z2vCmo1MYoVdX0FhpaThyt5Fvy3sIo/JqkxNvaIyORVpGOLnhZKMMTCEkLMj5vrL+u42m6B9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006287; c=relaxed/simple;
	bh=uV8z+fM9G49Y0o9/i8CtyfusfsAFkaBSoJ+iLaJQQfg=;
	h=Date:To:From:Subject:Message-Id; b=CiyZ0Jqo9myvN4m7K4eR+AEZ+eTj20x1R9qYyKhH8kiObM1QjrVavakBkEnGTyvbxzQaCGN5izPwAUTxrk8NzB6HTOWcq5rG6K+9NCLlWQwNgOVUnnlIOJBu0rmpQYv0jPJXJ/d1zuiX8kopMFi/B99TjyoIDmxVu4GmlVm5nfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZObxtfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZObxtfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F20C4CED6;
	Thu, 16 Jan 2025 05:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006287;
	bh=uV8z+fM9G49Y0o9/i8CtyfusfsAFkaBSoJ+iLaJQQfg=;
	h=Date:To:From:Subject:From;
	b=IZObxtfy54BUNAearv8y+HxWoFPYrOqghbqffdszwITW1/j4XlyXX7W1JwO5OO/zK
	 Q05aorShifYxn81gregfGMn4rKmUV9Z6GYv3oSUcpdw+tged1y6OJacU+kUuoGEBt+
	 6IMI73HQGYsfEf73OzuZmq7ae3zGWiVB8t3XBDJc=
Date: Wed, 15 Jan 2025 21:44:46 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch removed from -mm tree
Message-Id: <20250116054447.25F20C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: add monitoring parameters tuning guide
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add monitoring parameters tuning guide
Date: Fri, 10 Jan 2025 10:52:28 -0800

Patch series "Docs/mm/damon: add tuning guide and misc updates".

Add DAMON monitoring parameters tuning guide (patches 1 and 2), with misc
documentation fixes (patch 3), updates (patch 4) and clarifications (patch
5).


This patch (of 5):

DAMON monitoring parameters including sampling and aggregation intervals
should be tuned for given workloads.  However, the fact is not explicitly
documented.  Also there is no official guide to help the tuning.  This
apparently confused a number of people[1] at best, or made people forgive
DAMON without tuning.  Add a guide on the design document.

[1] https://lore.kernel.org/20241202175459.2005526-1-sj@kernel.org

Link: https://lkml.kernel.org/r/20250110185232.54907-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250110185232.54907-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   48 ++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-monitoring-parameters-tuning-guide
+++ a/Documentation/mm/damon/design.rst
@@ -203,6 +203,8 @@ This scheme, however, cannot preserve th
 assumption is not guaranteed.
 
 
+.. _damon_design_adaptive_regions_adjustment:
+
 Adaptive Regions Adjustment
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -264,6 +266,52 @@ tracepoints.  For more details, please r
 respectively.
 
 
+Monitoring Parameters Tuning Guide
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+In short, set ``aggregation interval`` to capture meaningful amount of accesses
+for the purpose.  The amount of accesses can be measured using ``nr_accesses``
+and ``age`` of regions in the aggregated monitoring results snapshot.  The
+default value of the interval, ``100ms``, turns out to be too short in many
+cases.  Set ``sampling interval`` proportional to ``aggregation interval``.  By
+default, ``1/20`` is recommended as the ratio.
+
+``Aggregation interval`` should be set as the time interval that the workload
+can make an amount of accesses for the monitoring purpose, within the interval.
+If the interval is too short, only small number of accesses are captured.  As a
+result, the monitoring results look everything is samely accessed only rarely.
+For many purposes, that would be useless.  If it is too long, however, the time
+to converge regions with the :ref:`regions adjustment mechanism
+<damon_design_adaptive_regions_adjustment>` can be too long, depending on the
+time scale of the given purpose.  This could happen if the workload is actually
+making only rare accesses but the user thinks the amount of accesses for the
+monitoring purpose too high.  For such cases, the target amount of access to
+capture per ``aggregation interval`` should carefully reconsidered.  Also, note
+that the captured amount of accesses is represented with not only
+``nr_accesses``, but also ``age``.  For example, even if every region on the
+monitoring results show zero ``nr_accesses``, regions could still be
+distinguished using ``age`` values as the recency information.
+
+Hence the optimum value of ``aggregation interval`` depends on the access
+intensiveness of the workload.  The user should tune the interval based on the
+amount of access that captured on each aggregated snapshot of the monitoring
+results.
+
+Note that the default value of the interval is 100 milliseconds, which is too
+short in many cases, especially on large systems.
+
+``Sampling interval`` defines the resolution of each aggregation.  If it is set
+too large, monitoring results will look like every region was samely rarely
+accessed, or samely frequently accessed.  That is, regions become
+undistinguishable based on access pattern, and therefore the results will be
+useless in many use cases.  If ``sampling interval`` is too small, it will not
+degrade the resolution, but will increase the monitoring overhead.  If it is
+appropriate enough to provide a resolution of the monitoring results that
+sufficient for the given purpose, it shouldn't be unnecessarily further
+lowered.  It is recommended to be set proportional to ``aggregation interval``.
+By default, the ratio is set as ``1/20``, and it is still recommended.
+
+
 .. _damon_design_damos:
 
 Operation Schemes
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63403215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188343; cv=none; b=XBQbshMJgh69odkTPEwhcphQyE1Ag04b3JBwUyrY42SWNozgE4Ox89BhfJvAV7DffrQt9UG8evAlzD4FrUcGYANdmJ1triuKHEMGGIRNRbLIa3lYgKDArPPuvzB0UN3RNkpYutvhbzn/fKKWIMUsK7/atZRl+oSglLd8KxojHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188343; c=relaxed/simple;
	bh=Umc7pMSXsPaRPTfnua25hYcKlYnWy0CBDuLC7jNnMlc=;
	h=Date:To:From:Subject:Message-Id; b=n4fW7/F47ARxK430HStEcuKWU78wwSIjKbdE/kEmfOpcOI07ejKbNu/WY1SvMXUc3AghA5Dli4gmNZuiSjtOQRue2wVF4DqJ2VxXeQk0JgAJpr6odSidLDfq0RH/Ck+fhoAO2/6YjdgVRWvI/nfryc1qeaMqWGJK3gBIAZVM73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t9U+6aZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t9U+6aZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC67AC4CEEC;
	Mon, 17 Mar 2025 05:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188342;
	bh=Umc7pMSXsPaRPTfnua25hYcKlYnWy0CBDuLC7jNnMlc=;
	h=Date:To:From:Subject:From;
	b=t9U+6aZsXVmM1NSQuwdjE9FcKvmHCPNHhRvDUtEW6yxd2PQl5z7lKH+oz3fbS5o75
	 hl20VzZN+nwkeyLpmf43BWSWYmxeRdSEx8H3V51QOy4z6vbJDruyMH98/eweIcSZqX
	 2EmE26rqh64d4eRcA00cGYSmozKaDhBOn0nn3EcM=
Date: Sun, 16 Mar 2025 22:12:22 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,marcelomoreira1905@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-fix-spelling-and-grammar-in-monitoring_intervals_tuning_examplerst.patch removed from -mm tree
Message-Id: <20250317051222.CC67AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: fix spelling and grammar in monitoring_intervals_tuning_example.rst
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-fix-spelling-and-grammar-in-monitoring_intervals_tuning_examplerst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Subject: Docs/mm/damon: fix spelling and grammar in monitoring_intervals_tuning_example.rst
Date: Mon, 17 Feb 2025 18:54:31 -0300

This patch fixes some spelling and grammar mistakes in the documentation,
improving the readability.

- multipled  -> multiplied
- idential   -> identical
- minuts     -> minutes
- efficieny  -> efficiency

Link: https://lkml.kernel.org/r/20250217215512.12833-1-marcelomoreira1905@gmail.com
Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/monitoring_intervals_tuning_example.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst~docs-mm-damon-fix-spelling-and-grammar-in-monitoring_intervals_tuning_examplerst
+++ a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
@@ -36,7 +36,7 @@ Then, list the DAMON-found regions of di
 "access temperature".  "Access temperature" is a metric representing the
 access-hotness of a region.  It is calculated as a weighted sum of the access
 frequency and the age of the region.  If the access frequency is 0 %, the
-temperature is multipled by minus one.  That is, if a region is not accessed,
+temperature is multiplied by minus one.  That is, if a region is not accessed,
 it gets minus temperature and it gets lower as not accessed for longer time.
 The sorting is in temperature-ascendint order, so the region at the top of the
 list is the coldest, and the one at the bottom is the hottest one. ::
@@ -58,11 +58,11 @@ list is the coldest, and the one at the
 The list shows not seemingly hot regions, and only minimum access pattern
 diversity.  Every region has zero access frequency.  The number of region is
 10, which is the default ``min_nr_regions value``.  Size of each region is also
-nearly idential.  We can suspect this is because “adaptive regions adjustment”
+nearly identical.  We can suspect this is because “adaptive regions adjustment”
 mechanism was not well working.  As the guide suggested, we can get relative
 hotness of regions using ``age`` as the recency information.  That would be
 better than nothing, but given the fact that the longest age is only about 6
-seconds while we waited about ten minuts, it is unclear how useful this will
+seconds while we waited about ten minutes, it is unclear how useful this will
 be.
 
 The temperature ranges to total size of regions of each range histogram
@@ -190,7 +190,7 @@ for sampling and aggregation intervals,
 The number of regions having different access patterns has significantly
 increased.  Size of each region is also more varied. Total size of non-zero
 access frequency regions is also significantly increased. Maybe this is already
-good enough to make some meaningful memory management efficieny changes.
+good enough to make some meaningful memory management efficiency changes.
 
 800ms/16s intervals: Another bias
 =================================
_

Patches currently in -mm which might be from marcelomoreira1905@gmail.com are



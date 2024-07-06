Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A4B139CFC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292047; cv=none; b=iEbc1UxKDhcsgBGX9om5ygO5M3qi9fKud1E+14ZjvTPqbRNn4Y4Ohl6XRr/XE53BVaQF5Z4WS4MRWEciWEZByG6HfWYsAuTciDxZ31qn6N63QXfmdmm0OGaEDH5bxgOrC5B9IknHI+eYTBX8MR4S87TEEsJvVtu9ZJcI1A/waHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292047; c=relaxed/simple;
	bh=yutb/KOwp/P6zGNts1CV5uRndhj6zk4e84TMgIcZ4h8=;
	h=Date:To:From:Subject:Message-Id; b=MX0xaFherrRczFINyFxy2cj4Aai3ynbbdqTvOK/7HGj3JgoetqSLd7WyPOtcXZOINTbOeEJFkA/f+wbPn1mBSVKPuaEgKrhPbeb5YtR9W8DnPaxmB2p/ZID0wTaEdBGHCbj03MjGgppZuU/a/tlGx25+EkbUXcpsD9p9ESz3VaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVWFtAu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVWFtAu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0A4C2BD10;
	Sat,  6 Jul 2024 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292047;
	bh=yutb/KOwp/P6zGNts1CV5uRndhj6zk4e84TMgIcZ4h8=;
	h=Date:To:From:Subject:From;
	b=rVWFtAu6a/f/XOUeZkjDbPHQAIPIzXNBiR5v6TRLX3zNRUHSTdLk3IJ1sOIbm7OWf
	 uhGJoBZn98rNdTmtKv9cs49Oe3pQYbZhISmWJ2UjJuBf2HeAhguXBMIwlemLLMc3V4
	 L+il2Zu4ZbAhD1FuAx2OWjt3gklneMUJx6dawFXA=
Date: Sat, 06 Jul 2024 11:54:06 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-clarify-regions-merging-operation.patch removed from -mm tree
Message-Id: <20240706185406.DF0A4C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: clarify regions merging operation
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-clarify-regions-merging-operation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: clarify regions merging operation
Date: Mon, 1 Jul 2024 12:26:59 -0700

DAMON design document is not explaining how min_nr_regions limit is kept,
and what happens if the number of regions exceeds max_nr_regions.  Add
more clarification for those.

Link: https://lkml.kernel.org/r/20240701192706.51415-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-regions-merging-operation
+++ a/Documentation/mm/damon/design.rst
@@ -209,11 +209,18 @@ the data access pattern can be dynamical
 monitoring quality.  To keep the assumption as much as possible, DAMON
 adaptively merges and splits each region based on their access frequency.
 
-For each ``aggregation interval``, it compares the access frequencies of
-adjacent regions and merges those if the frequency difference is small.  Then,
-after it reports and clears the aggregated access frequency of each region, it
-splits each region into two or three regions if the total number of regions
-will not exceed the user-specified maximum number of regions after the split.
+For each ``aggregation interval``, it compares the access frequencies
+(``nr_accesses``) of adjacent regions.  If the difference is small, and if the
+sum of the two regions' sizes is smaller than the size of total regions divided
+by the ``minimum number of regions``, DAMON merges the two regions.  If the
+resulting number of total regions is still higher than ``maximum number of
+regions``, it repeats the merging with increasing access frequenceis difference
+threshold until the upper-limit of the number of regions is met, or the
+threshold becomes higher than possible maximum value (``aggregation interval``
+divided by ``sampling interval``).   Then, after it reports and clears the
+aggregated access frequency of each region, it splits each region into two or
+three regions if the total number of regions will not exceed the user-specified
+maximum number of regions after the split.
 
 In this way, DAMON provides its best-effort quality and minimal overhead while
 keeping the bounds users set for their trade-off.
_

Patches currently in -mm which might be from sj@kernel.org are



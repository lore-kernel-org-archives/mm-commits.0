Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F5625DCE5
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485157; cv=none; b=siQ19iTsBPRFNiFPNozq5dj9G5lpbi7jVLFc1V7hhTmvgtKA7pPwWFIVvWpoavhK1aBv5WpKyuN6D/epeUDEOGwVNW0JktyIAwv2gwfNcDip/XbhgY+sHO7Z4BLofcDxUMJdk4HC6FG9SUuWAAwXk4eECfMTuc/jXlHG7O/Y0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485157; c=relaxed/simple;
	bh=0nfURxuPTuutbYX4dOI9cn24Ue4hGVriuwTnxfExj98=;
	h=Date:To:From:Subject:Message-Id; b=SLPCKaEdqyf64nfTqYIJjHPyrd2z8oZcqGLYTPKKq8/Nrclz9IV1DoNyTd2r5oIegLljBPGELXXDFbBXQ0o/WHDj0aCySt62CHswpFlXwS4medHM8fvvEkXfbNEOUWAX1LUR9dEjifWXHN7eQGn1NpF4YV5yNkzKA7wUFoFTNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=if3gPnGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="if3gPnGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D06DC4CEF4;
	Fri, 25 Jul 2025 23:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753485155;
	bh=0nfURxuPTuutbYX4dOI9cn24Ue4hGVriuwTnxfExj98=;
	h=Date:To:From:Subject:From;
	b=if3gPnGTVfsrkYo2w7wx3uEcpsQJ3SgPcENal87vXCOn0LeKA1JSb0cxsv98tKDm/
	 NiRlkGHA1o+yvPwrWtDEj9FH+RhdLcvmYB8G/lt31KhyAyjaMY6IRwrI+Lfa7NCn0J
	 ahjup2QF/IvhPpXW8hpekgYhpAMP5f4T/egA0Hbg=
Date: Fri, 25 Jul 2025 16:12:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch added to mm-unstable branch
Message-Id: <20250725231235.7D06DC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: Skip isolating folios already in destination nid
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/vaddr: Skip isolating folios already in destination nid
Date: Fri, 25 Jul 2025 11:33:00 -0500

damos_va_migrate_dests_add() determines the node a folio should be in
based on the struct damos_migrate_dests associated with the migration
scheme and adds the folio to the linked list corresponding to that node so
it can be migrated later.  Currently, folios are isolated and added to the
list even if they are already in the node they should be in.

In using damon weighted interleave more, I've found that the overhead of
needlessly adding these folios to the migration lists can be quite high. 
The overhead comes from isolating folios and placing them in the migration
lists inside of damos_va_migrate_dests_add(), as well as the cost of
handling those folios in damon_migrate_pages().  This patch eliminates
that overhead by simply avoiding the addition of folios that are already
in their intended location to the migration list.

To show the benefit of this patch, we start the test workload and start a
DAMON instance attached to that workload with a migrate_hot scheme that
has one dest field sending data to the local node.  This way, we are only
measuring the overheads of the scheme, and not the cost of migrating
pages, since data will be allocated to the local node by default.  I
tested with two workloads: the embedding reduction workload used in [1]
and a microbenchmark that allocates 20GB of data then sleeps, which is
similar to the memory usage of the embedding reduction workload.

The time taken in damos_va_migrate_dests_add() and damon_migrate_pages()
each aggregation interval is shown below.

Before this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                   ~2ms                      ~3ms
embedding reduction              ~1s                       ~3s

After this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                    0us                      ~40us
embedding reduction               0us                      ~100us

I did not do an in depth analysis for why things are much slower in the
embedding reduction workload than the microbenchmark.  However, I assume
it's because the embedding reduction workload oversaturates the bandwidth
of the local memory node, increasing the memory access latency, and in
turn making the pointer chasing involved in iterating through a linked
list much slower.  Regardless of that, this patch results in a significant
speedup.

[1] https://lore.kernel.org/damon/20250709005952.17776-1-bijan311@gmail.com/

Link: https://lkml.kernel.org/r/20250725163300.4602-1-bijan311@gmail.com
Fixes: 19c1dc15c859 ("mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}")
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid
+++ a/mm/damon/vaddr.c
@@ -711,6 +711,10 @@ static void damos_va_migrate_dests_add(s
 		target -= dests->weight_arr[i];
 	}
 
+	/* If the folio is already in the right node, don't do anything */
+	if (folio_nid(folio) == dests->node_id_arr[i])
+		return;
+
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch


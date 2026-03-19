Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87DF3783D6
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960564; cv=none; b=po0yvaf72xBVQKXlAwvpNNf1LTt4gjdnkB4ladwkIp4OCc7fP/muS4nzMnHFL7ynosjiQvOasiraSgHgKJV1fdjkL7Gqa8PqbqDMB6vpeQG/5X5AAw20cgmuT3MBV+iueWFXS2wu35k5Yg040xBTo6pGqBWMQewSqvqmnQy1ulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960564; c=relaxed/simple;
	bh=cU9S1wPluPsvcsW29m06rAD9NxCaqm66VkCfi2RGSV8=;
	h=Date:To:From:Subject:Message-Id; b=NxCtuTvaKifVaSV0WCexC09wmtNRcicRTpLRFaP25eRF+ftCQf108M8j9nlkij6cRRrXd9Pbp/mfh9ORPbUyv6OZ0UeUrLB+vnNIkLw2RMHnmqyx/2e90I4MDhvdGs8exGgeUbO8ao9DQsC6kFarddO2RCYNZWHsyfuxxfF3r1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njn9Sovg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njn9Sovg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E63FC19424;
	Thu, 19 Mar 2026 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960564;
	bh=cU9S1wPluPsvcsW29m06rAD9NxCaqm66VkCfi2RGSV8=;
	h=Date:To:From:Subject:From;
	b=njn9Sovge22A5s3jmiSXTGq9Z0TJsBY9k1KNjdooD+nDZvCTK610t9MWypeG4dTxo
	 7cBPQsOFCnLjt4WAX+VcDBId4JocWe1wL0nmo9uiJ6RG/qgjO+h/5We5I4J5qjvRSr
	 MzA0tnF2C6ccRxum7aWJBJ3duppUvCp3KZB1y1ZE=
Date: Thu, 19 Mar 2026 15:49:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch added to mm-new branch
Message-Id: <20260319224924.1E63FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
Date: Thu, 19 Mar 2026 09:28:43 +0800

Patch series "Modify memfd_luo code".

I found several modifiable points while reading the code.


This patch (of 3):

Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
to improve performance when restoring large memfds.

Currently, shmem_recalc_inode() is called for each folio during restore,
which is O(n) expensive operations.  This patch collects the number of
successfully added folios and calls shmem_recalc_inode() once after the
loop completes, reducing complexity to O(1).

Additionally, fix the error path to also call shmem_recalc_inode() for the
folios that were successfully added before the error occurred.

Link: https://lkml.kernel.org/r/20260319012845.29570-1-duanchenghao@kylinos.cn
Link: https://lkml.kernel.org/r/20260319012845.29570-2-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path
+++ a/mm/memfd_luo.c
@@ -412,6 +412,7 @@ static int memfd_luo_retrieve_folios(str
 	struct folio *folio;
 	int err = -EIO;
 	long i;
+	u64 nr_added = 0;
 
 	for (i = 0; i < nr_folios; i++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
@@ -463,12 +464,15 @@ static int memfd_luo_retrieve_folios(str
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		nr_added++;
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
+	if (nr_added)
+		shmem_recalc_inode(inode, nr_added, 0);
+
 	return 0;
 
 unlock_folio:
@@ -487,6 +491,9 @@ put_folios:
 			folio_put(folio);
 	}
 
+	if (nr_added)
+		shmem_recalc_inode(inode, nr_added, 0);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch


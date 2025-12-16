Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC9315785
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 04:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765859149; cv=none; b=N0IGk4uTtgYNhT4IZhI7wIEqDcc4NiYgPg2mfi0gbzsEm3HflGBmHrOHH9wEtPwSyQLtsBnaEFDJkshTCWjcrS93LN2RBGEXpCphtz8qmeqfL4BXPBA5mQ9uSfiQUgGI7kbKuLNxjwRhK7e+vu727RPBue3LvpB26JgKFDwIKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765859149; c=relaxed/simple;
	bh=O5c1l+DVSGC5mdQH+ciufXk4DndovHprIpLvsoQnfrw=;
	h=Date:To:From:Subject:Message-Id; b=BpWKWVfChkpP2AcPvvJoQoBcY6U78VIfpdmx5uDMJbKnlC1fBJAZOiu5Iz5BWjcVGd4jMDc7k8r6/H/yoI7S0dXuWbg6xE2DFiuDMdr07g6NdDQoozqE1Cig9WRfdAyeBXb9A4sHlTbTAODGsPum5LQXRf5jk3yYPKZVBJ87WYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGvQU0kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGvQU0kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D62C4CEF1;
	Tue, 16 Dec 2025 04:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765859148;
	bh=O5c1l+DVSGC5mdQH+ciufXk4DndovHprIpLvsoQnfrw=;
	h=Date:To:From:Subject:From;
	b=vGvQU0krcIJfZepWWyggKQajIzRQtp1kcsDaeXJmsHU6uU1bb0lVSA8RIKpOR83tK
	 5cDQreI5a7H/h1Y2QnD+UxZpB9lb4OFa3FRz15Gr98b75kj3WO3uyTkYn5vDX4LiqQ
	 Lt3n+ISarh1j29Y+aCdc440TZmbkxyohvrnZ59gs=
Date: Mon, 15 Dec 2025 20:25:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-fix-partial-long-option-mapping.patch added to mm-new branch
Message-Id: <20251216042548.D1D62C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/slabinfo: fix --partial long option mapping
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-fix-partial-long-option-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-fix-partial-long-option-mapping.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/slabinfo: fix --partial long option mapping
Date: Mon, 8 Dec 2025 16:22:40 +0530

The long option "--partial" was incorrectly mapped to lowercase 'p' in the
opts[] array, but the getopt string and switch case handle uppercase 'P'. 
This mismatch caused --partial to be rejected.

Fix the long_options mapping to use 'P' so --partial works correctly
alongside the existing -P short option.

Link: https://lkml.kernel.org/r/20251208105240.2719773-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-partial-long-option-mapping
+++ a/tools/mm/slabinfo.c
@@ -1405,7 +1405,7 @@ struct option opts[] = {
 	{ "numa", no_argument, NULL, 'n' },
 	{ "lines", required_argument, NULL, 'N'},
 	{ "ops", no_argument, NULL, 'o' },
-	{ "partial", no_argument, NULL, 'p'},
+	{ "partial", no_argument, NULL, 'P'},
 	{ "report", no_argument, NULL, 'r' },
 	{ "shrink", no_argument, NULL, 's' },
 	{ "Size", no_argument, NULL, 'S'},
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch
tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch
tools-mm-slabinfo-fix-partial-long-option-mapping.patch


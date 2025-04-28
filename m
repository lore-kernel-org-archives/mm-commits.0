Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F054D599
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799784; cv=none; b=J/m5zNVgEfLi9vahXWdVjvUSzb+TmlyEQD50TAnjrYzDzLJCght5g8Ua7vxKMS0/bj83aYdo5bFW6mq+baf+Zm+33l9sHTSQwKEBui+T6umu6iCNhANfZoo8UKK1QejcaNSk5zRK7ALSVZNYR8qqdzyS2OQ8uJ0z/4RhDPlg6iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799784; c=relaxed/simple;
	bh=lCtlmZUtScywuNdfcObr+CwEj7VHvRMsHfP1lR4pH+0=;
	h=Date:To:From:Subject:Message-Id; b=aXiAQ5Ky2dN+6t8ahT99n7hol357LxstTukyPjXKj8XD08PbK+tb2VSCA+xr71cUpY4C0siQS9X4mzdbiKDN0CjQIJQ4/XY8g4Q6W0T4efWZSjyXSGBuVDQgdnZQkOR/6HZIQ68TBPNDf0kG39zvT0FOMwhhvMxgEfqPmIffsEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnthChCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnthChCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7DAC4CEE3;
	Mon, 28 Apr 2025 00:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799784;
	bh=lCtlmZUtScywuNdfcObr+CwEj7VHvRMsHfP1lR4pH+0=;
	h=Date:To:From:Subject:From;
	b=KnthChCEyDTMc4CDM0ZBO6NCGnSWMIzG1q4FUx4SF1FWmoceM9wIA9ihCiVfh3mEl
	 js7FOHm/bHnm3cej7O6QDn9aOFpSil1PKmW+LKYit0vXHiiW4h3HL/PKPJhuYMtgq5
	 FAPgHTrdIPmldESONGAtUWNa7LlOqtb8kvJoH/nk=
Date: Sun, 27 Apr 2025 17:23:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch added to mm-unstable branch
Message-Id: <20250428002304.2F7DAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: trigger build even if only mtier is enabled
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon: trigger build even if only mtier is enabled
Date: Sat, 26 Apr 2025 11:40:54 -0700

mtier can be built only if one or more of other DAMON sample modules are
build-enabled.  This is because commit 66001f0476f4 ("samples/damon:
implement a DAMON module for memory tiering") on mm-unstable tree is not
connecting it on samples/Makefile.  Fix it by adding the connection on
samples/Makefile.

Link: https://lkml.kernel.org/r/20250426184054.11437-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/Makefile~samples-damon-implement-a-damon-module-for-memory-tiering-fix
+++ a/samples/Makefile
@@ -42,4 +42,5 @@ obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
 obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
+obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch


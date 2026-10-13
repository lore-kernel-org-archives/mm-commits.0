Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4248D391838
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865968; cv=none; b=Si5oK79JUCvP/YXGN0Mc3s17tsgARBjdlEnCnYUsG1SwxvQ1lY5QvTh+oiSkUrvdZsqabUspCQ1F0KFR+HnVBuN0XvgqlLbmc9mc4ZFcDUAUU/IjATRlCPjGhjXLWIn3oUVx04TJwERcz2S6hz3RyDYk1sli9PWllNt8i9nMYQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865968; c=relaxed/simple;
	bh=pai5xnQmbxMZU1az+Mz6vDMEOVV08ryoSjIXBBK4X3Y=;
	h=Date:To:From:Subject:Message-Id; b=DJQ4a9y68F4LMSop8vMOI432hMD4hKgKpwrnWB4eeVmLrdLMYe+3brhqiSaaSFdcr1/5Fx77Ky5zQApt4jrCmIsga3u4IpI4RXNSlSPnIydrG596uM4bxmg9dsKxvSVU97a9RUz2/8v6vRByffL5306EgwGAlkCDFK2fQ+B11xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gDshMprD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gDshMprD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CCB1F000FF;
	Tue, 13 Oct 2026 04:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865967;
	bh=QOcr9oLitFruGPIsiBRbN16q/CLiDzjgud6V6+QT/4k=;
	h=Date:To:From:Subject;
	b=gDshMprDuou/RUg9VPfRBf/SeBNhF+Lw0ZgLEftlkobZ6YZ1n1SW18TRDqgFAyBBT
	 HIhFc/wDWybtvIWUT26Q8HCCeoPjNaGs6phKG4viQ/b1MjA1Ua9uPqugeVqXINNisl
	 KcImhwFiiFQtalk1v08xSRGE/Yk1giiyGXOQH/1w=
Date: Mon, 12 Oct 2026 21:32:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-api-remove-nr_damos_filter_types.patch removed from -mm tree
Message-Id: <20261013043247.15CCB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/api: remove NR_DAMOS_FILTER_TYPES
has been removed from the -mm tree.  Its filename was
     mm-damon-api-remove-nr_damos_filter_types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/api: remove NR_DAMOS_FILTER_TYPES
Date: Thu, 17 Sep 2026 07:21:59 -0700

Patch series "mm/damon: improve readability, clarity and test coverage".

Yet another batch of miscellaneous DAMON minor improvements.  Mostly
focused on readability and clarity of code and document, and unit/self
test coverage.  No user-visible behavioral change is intended.


This patch (of 10):

Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.

Link: https://lore.kernel.org/20260917142210.90829-1-sj@kernel.org
Link: https://lore.kernel.org/20260917142210.90829-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
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

 include/linux/damon.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-api-remove-nr_damos_filter_types
+++ a/include/linux/damon.h
@@ -400,7 +400,6 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
- * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
@@ -422,7 +421,6 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
-	NR_DAMOS_FILTER_TYPES,
 };
 
 /**
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


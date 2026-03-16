Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1AD326D45
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681727; cv=none; b=ZfJk3w6kND6HuzY4dftQfpxMWnHPInpaWeOzzQMiuFIlBhT/XEoTtm24NYC3fKv74oOdNt+iZ//Ate+DRM78CK455bfFshDtmD+3bSXoOEiL2BhNVTX2oNCU/l6CZgsHB1NtQ2DR10GLds9rKF+yW8je25hC/ftJxXgT7qdO4vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681727; c=relaxed/simple;
	bh=iY5EsDNvUXep+QdSM3B6IG5QZhB14yFXwUEyaXllMxA=;
	h=Date:To:From:Subject:Message-Id; b=Gl55j2xlEvknzlvlPxg1zJxH4js7xcBkcO7Hb8ibGD9hnFU37ovXYDLF/nv2lQ5p89wjtXINDyQlftepkNaZfpm38PWvuyH3iGbtX0OWh3Nb/m68HZCkar6LzrHJ0JwsvAdzSGd4pPMutmpYn9nOsr37BOMdh6qvo8L1zDdTy2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7LlMBST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7LlMBST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4A4C19421;
	Mon, 16 Mar 2026 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773681727;
	bh=iY5EsDNvUXep+QdSM3B6IG5QZhB14yFXwUEyaXllMxA=;
	h=Date:To:From:Subject:From;
	b=M7LlMBSTCP5QnIhCZZ020h61hegFz0iypELn63tBm0I3ksFjRlN0bnoRDOn8/Qi06
	 6/Q3IP5lPGN13egLRSu/te7ZPr3RfKcuFAB04BMHXwjNVm9vf8VCX6gEcUYQevusVk
	 HAWouBcgzt1U47+BvFvUBb0AakOiTry2ZlWfBCqs=
Date: Mon, 16 Mar 2026 10:22:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch added to mm-new branch
Message-Id: <20260316172207.1A4A4C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: document exclusivity of special-purpose modules
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sun, 15 Mar 2026 09:29:44 -0700

Add a section in design.rst to explain that DAMON special-purpose kernel
modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
-EBUSY if another is already running.

Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
to this exclusivity rule at the end of their respective Example sections.

This change is motivated from another discussion [1].

Link: https://lkml.kernel.org/r/20260315162945.80994-1-sj@kernel.org
Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t [1]
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    5 +++++
 Documentation/admin-guide/mm/damon/reclaim.rst  |    5 +++++
 Documentation/admin-guide/mm/damon/stat.rst     |    5 +++++
 Documentation/mm/damon/design.rst               |    4 ++++
 4 files changed, 19 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -351,3 +351,8 @@ the LRU-list based page granularity recl
     # echo 400 > wmarks_mid
     # echo 200 > wmarks_low
     # echo Y > enabled
+
+Note that this module (damon_lru_sort) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -318,6 +318,11 @@ granularity reclamation. ::
     # echo 200 > wmarks_low
     # echo Y > enabled
 
+Note that this module (damon_reclaim) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
 .. [3] https://www.kernel.org/doc/html/latest/mm/free_page_reporting.html
--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+Note that this module (damon_stat) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. _damon_stat_aggr_interval_us:
 
 aggr_interval_us
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/mm/damon/design.rst
@@ -853,6 +853,10 @@ more detail, please read the usage docum
 (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
+.. _damon_design_special_purpose_modules_exclusivity:
+
+Note that these modules currently run in an exclusive manner.  If one of those
+is already running, others will return ``-EBUSY`` upon start requests.
 
 Sample DAMON Modules
 --------------------
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch


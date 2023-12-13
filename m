Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074FC68296
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8GrROdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A91AC433C8;
	Wed, 13 Dec 2023 19:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496972;
	bh=Y6fgMSoYK4hz5diY2PXGKSeeYS8JaZMMBrU+S3FlJEA=;
	h=Date:To:From:Subject:From;
	b=z8GrROdIr1NlittSh14FiQzPRFfJu2IeMjTvEUUeMEVF5cOGj/9NXr6c3EGVLI3OF
	 RAOZQ4dHxeNpV7Hdf6Xg/XDlaL2lyDxubh4c6f7r9jpbqkukLIChVWOhTLN0+sf7Nk
	 zpyGfhdDnj573UnlxPm3gvQQS4Z+pytGE0qz2Hh8=
Date: Wed, 13 Dec 2023 11:49:31 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch added to mm-unstable branch
Message-Id: <20231213194932.7A91AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: place execution model and data structures at the beginning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch

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
Subject: Docs/mm/damon/design: place execution model and data structures at the beginning
Date: Wed, 13 Dec 2023 19:03:35 +0000

The execution model and data structures section at the end of the design
document is briefly explaining how DAMON works overall.  Knowing that
first may help better drawing the overall picture.  It may also help
better understanding following detailed sections.  Move it to the
beginning of the document.

Link: https://lkml.kernel.org/r/20231213190338.54146-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning
+++ a/Documentation/mm/damon/design.rst
@@ -5,6 +5,18 @@ Design
 ======
 
 
+.. _damon_design_execution_model_and_data_structures:
+
+Execution Model and Data Structures
+===================================
+
+The monitoring-related information including the monitoring request
+specification and DAMON-based operation schemes are stored in a data structure
+called DAMON ``context``.  DAMON executes each context with a kernel thread
+called ``kdamond``.  Multiple kdamonds could run in parallel, for different
+types of monitoring.
+
+
 Overall Architecture
 ====================
 
@@ -490,15 +502,3 @@ modules for proactive reclamation and LR
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
-
-
-.. _damon_design_execution_model_and_data_structures:
-
-Execution Model and Data Structures
-===================================
-
-The monitoring-related information including the monitoring request
-specification and DAMON-based operation schemes are stored in a data structure
-called DAMON ``context``.  DAMON executes each context with a kernel thread
-called ``kdamond``.  Multiple kdamonds could run in parallel, for different
-types of monitoring.
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch
mm-damon-update-email-of-seongjae.patch
mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch
docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch
docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch
docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch


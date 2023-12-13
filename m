Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5CE68296
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fc1fgExA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1BAC433C8;
	Wed, 13 Dec 2023 19:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496974;
	bh=rAYrn+lSfBLgyijxGFH0tL6hJRB6n4q53mViSrPkbfU=;
	h=Date:To:From:Subject:From;
	b=Fc1fgExAmzOxfmZSd1oRe5LX5Lvl1OVJnG514pNpMfbSrpS+Dd4hPniRdZM+TxzvK
	 by1eg9e8LAjY+68ZNLWXFOvd+MHxlYR7Iv7InL6NJhwxDs8uMp5wR8Fck8jH1t1exq
	 OETLkrsn+DLky4efohS4EX1//faKYteFAUTuS2aU=
Date: Wed, 13 Dec 2023 11:49:33 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch added to mm-unstable branch
Message-Id: <20231213194934.2C1BAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update context directory section label
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update context directory section label
Date: Wed, 13 Dec 2023 19:03:36 +0000

The label for context DAMON sysfs directory section is having name
sysfs_contexts.  The name would be better to be used for the contexts
directory.  Rename it to represent a single context.

Link: https://lkml.kernel.org/r/20231213190338.54146-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-context-directory-section-label
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -164,7 +164,7 @@ number (``N``) to the file creates the n
 details).  At the moment, only one context per kdamond is supported, so only
 ``0`` or ``1`` can be written to the file.
 
-.. _sysfs_contexts:
+.. _sysfs_context:
 
 contexts/<N>/
 -------------
@@ -288,7 +288,7 @@ The ``action`` file is for setting and g
 from the file and their meaning are as below.
 
 Note that support of each action depends on the running DAMON operations set
-:ref:`implementation <sysfs_contexts>`.
+:ref:`implementation <sysfs_context>`.
 
  - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
@@ -428,7 +428,7 @@ pages of all memory cgroups except ``/ha
     echo N > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
-``paddr`` :ref:`implementation <sysfs_contexts>` is being used.
+``paddr`` :ref:`implementation <sysfs_context>` is being used.
 
 Also, memory regions that are filtered out by ``addr`` or ``target`` filters
 are not counted as the scheme has tried to those, while regions that filtered
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


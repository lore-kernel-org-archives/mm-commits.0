Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE046829A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d/pSpnt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A23C433C8;
	Wed, 13 Dec 2023 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496977;
	bh=JROJqHxJYqyKkCHniaXOgVs04mi1w4jI+bcSFXcXG4E=;
	h=Date:To:From:Subject:From;
	b=d/pSpnt5ZpbcdtUK3pTqcVkmZUmo2jhl/YMSJsgcAtPcyaUQ6Wi2w7Tp58hMjuhwd
	 e95AxE3HbV3CcFNcx91S0CUr+L9GcVSIEB2UpDHaP5JQsj39I5kafeVBR7JYJgb9Rg
	 seq+vFJG3FuF3mXIkl4MvyKIOCx7SJsQT+Wu2QbQ=
Date: Wed, 13 Dec 2023 11:49:36 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch added to mm-unstable branch
Message-Id: <20231213194937.78A23C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: use a list for 'state' sysfs file input commands
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch

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
Subject: Docs/admin-guide/mm/damon/usage: use a list for 'state' sysfs file input commands
Date: Wed, 13 Dec 2023 19:03:38 +0000

There are eight command inputs for 'state' DAMON sysfs file, and those are
verbosely explained in multiple paragraphs.  It is not easy to find
explanation of specific command, and getting whole picture of supported
commands.  Replace the paragraphs with a list.

Link: https://lkml.kernel.org/r/20231213190338.54146-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   43 ++++++++---------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -130,30 +130,29 @@ In each kdamond directory, two files (``
 (``contexts``) exist.
 
 Reading ``state`` returns ``on`` if the kdamond is currently running, or
-``off`` if it is not running.  Writing ``on`` or ``off`` makes the kdamond be
-in the state.
+``off`` if it is not running.
 
-Writing ``commit`` to the ``state`` file makes kdamond reads the
-user inputs in the sysfs files except ``state`` file again.  Writing
-``commit_schemes_quota_goals`` to the ``state`` file makes kdamond reads the
-DAMON-based operation schemes' :ref:`quota goals <sysfs_schemes_quota_goals>`
-of the kdamond.
+Users can write below commands for the kdamond to the ``state`` file.
 
-Writing ``update_schemes_stats`` to ``state`` file updates the
-contents of stats files for each DAMON-based operation scheme of the kdamond.
-For details of the stats, please refer to :ref:`stats section
-<sysfs_schemes_stats>`.
-
-Writing ``update_schemes_tried_regions`` to ``state`` file updates the
-DAMON-based operation scheme action tried regions directory for each
-DAMON-based operation scheme of the kdamond.  Writing
-``update_schemes_tried_bytes`` to ``state`` file updates only
-``.../tried_regions/total_bytes`` files.  Writing
-``clear_schemes_tried_regions`` to ``state`` file clears the DAMON-based
-operating scheme action tried regions directory for each DAMON-based operation
-scheme of the kdamond.  For details of the DAMON-based operation scheme action
-tried regions directory, please refer to :ref:`tried_regions section
-<sysfs_schemes_tried_regions>`.
+- ``on``: Start running.
+- ``off``: Stop running.
+- ``commit``: Read the user inputs in the sysfs files except ``state`` file
+  again.
+- ``commit_schemes_quota_goals``: Read the DAMON-based operation schemes'
+  :ref:`quota goals <sysfs_schemes_quota_goals>`.
+- ``update_schemes_stats``: Update the contents of stats files for each
+  DAMON-based operation scheme of the kdamond.  For details of the stats,
+  please refer to :ref:`stats section <sysfs_schemes_stats>`.
+- ``update_schemes_tried_regions``: Update the DAMON-based operation scheme
+  action tried regions directory for each DAMON-based operation scheme of the
+  kdamond.  For details of the DAMON-based operation scheme action tried
+  regions directory, please refer to
+  :ref:`tried_regions section <sysfs_schemes_tried_regions>`.
+- ``update_schemes_tried_bytes``: Update only ``.../tried_regions/total_bytes``
+  files.
+- ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
+  action tried regions directory for each DAMON-based operation scheme of the
+  kdamond.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
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


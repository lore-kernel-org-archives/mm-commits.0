Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59214D124
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WdV+yDaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512B0C433C7;
	Wed, 20 Dec 2023 22:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112569;
	bh=jNd9o6y0g6X5TArYW3Vfp3+gAsanXjIOeKKKRU0iDeg=;
	h=Date:To:From:Subject:From;
	b=WdV+yDaYDdKjWZYMk7LyolyHp8TS/8eTqdbBKa5ZXSOxdt+tD2w2K6e8caX25nbLP
	 y1239V102TQA5R+jC0gBUyhMq8rAXbRLuUU1xF+azCH7X+dedpPI25BbgRzxGFY701
	 UqPbI6jJ+pcM2Pm0DbGH29CxFr0J9AOCMVFJSNUw=
Date: Wed, 20 Dec 2023 14:49:28 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch removed from -mm tree
Message-Id: <20231220224929.512B0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: use a list for 'state' sysfs file input commands
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



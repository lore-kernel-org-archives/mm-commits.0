Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B138DEF
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597120; cv=none; b=uNd2g/A5BERR6rgzULfwLWQysv20RWvPn43c1rZQEAEK7iteZaMPurkzRhsenRWpmy1faAbM4BnZgzjx/kzelMtl6OrI88S0gjiXF70F5eGx3sZKKG2+931VkXQ0oNxC7YRruPleqIcdl9Fz813bSMiQrd6LxdX6jzAvwfirtXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597120; c=relaxed/simple;
	bh=p3hDYcr/cpsfl6EQHeK5jayIGkzSd08tica7fe2gzW0=;
	h=Date:To:From:Subject:Message-Id; b=QRikPdfZoXghwQ9ILggnGLBiqca873oWjcgxxJc3mz3KmYg0zeU9fF3iMCwz9bIkkb2DvzOWcsni5tqtcdxi7l/QYBZDG4kgQmaS1cOjO+3GhWwfPkdC6xxJoVET3s7QsPIPYSisGnUauej41ZXM8TLDA+eR49cHx9A0459AFL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g2vyk04C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2vyk04C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D9DC433C7;
	Tue, 30 Jan 2024 06:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597119;
	bh=p3hDYcr/cpsfl6EQHeK5jayIGkzSd08tica7fe2gzW0=;
	h=Date:To:From:Subject:From;
	b=g2vyk04COIn6LmsywTRl8AeusJfMca/cotSyCK858s7N18RZSpGtbp5D0wTwSSgUa
	 VnWXXrXq+jK3cOSWh0Y+nLiBSgM5ydVjRrwE1XsuG16JcDj05Mcw9FSyqZ6shj7TuJ
	 w3CbqWq68r1cRpxojLd9P52ZzQEa+3uCp4OCS+A0=
Date: Mon, 29 Jan 2024 22:45:05 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch added to mm-unstable branch
Message-Id: <20240130064518.67D9DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document 'DEPRECATED' file of DAMON debugfs interface
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document 'DEPRECATED' file of DAMON debugfs interface
Date: Mon, 29 Jan 2024 17:35:44 -0800

Document the newly added DAMON debugfs interface deprecation notice file
on the usage document.

Link: https://lkml.kernel.org/r/20240130013549.89538-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -628,9 +628,16 @@ debugfs Interface (DEPRECATED!)
   move, please report your usecase to damon@lists.linux.dev and
   linux-mm@kvack.org.
 
-DAMON exports eight files, ``attrs``, ``target_ids``, ``init_regions``,
-``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` and
-``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+DAMON exports nine files, ``DEPRECATED``, ``attrs``, ``target_ids``,
+``init_regions``, ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts``
+and ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+
+
+``DEPRECATED`` is a read-only file for the DAMON debugfs interface deprecation
+notice.  Reading it returns the deprecation notice, as below::
+
+    # cat DEPRECATED
+    DAMON debugfs interface is deprecated, so users should move to DAMON_SYSFS. If you cannot, please report your usecase to damon@lists.linux.dev and linux-mm@kvack.org.
 
 
 Attributes
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch


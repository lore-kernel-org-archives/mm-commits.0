Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B277938FA3
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597194; cv=none; b=RAjFo92qEwIbHGkcI46DwcDlsEz1KLuv+zxCs5cG0xtHCYfVAjsx0mbdp7OmDbG3nQNyYm2GD14DYCTnm612CspoLLnpyBHs0dxMtHulrfTS8mVJdjT+/svz8XVmg11g57kx2IrDaoj0YRkSF/apNxATP3ch/iuL0mCK9tvKcW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597194; c=relaxed/simple;
	bh=C+rzYJ5OiV8GctdFfetiOXy/pcxc7DfhSP8l6Q38pTY=;
	h=Date:To:From:Subject:Message-Id; b=rcJh4C4qDSLFgpvBVAY8Ov0RyXwbHJC/wU6o5/c1wujvuX5lEaCUXtJQUlWNpfpMZmGyC7qOa2fR4xvZHvK2EE6OE7kGGW6qQF+9nAAIPsDqftI9zqxHZXT4XLKVz45BDDCB26TkwUZTfFsphGe20ihGjdflPOSOdk+NmtG+Rcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMoAqexw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMoAqexw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97245C433F1;
	Tue, 30 Jan 2024 06:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597194;
	bh=C+rzYJ5OiV8GctdFfetiOXy/pcxc7DfhSP8l6Q38pTY=;
	h=Date:To:From:Subject:From;
	b=HMoAqexwK5AjpWHkNuWYbLCK9KCVbnKKCXvTE+sy+/YSUSDa/VMOLyy6RUAn5zIXP
	 iFRlGEJcKd0x6/G46hocW+VYPv0MW+PaqGRI3h6iusl5pVsJwP62TDwczA+0ZgiXnO
	 8ma1Gy2V4GbR5KKRAozN9eMaaqYlno6gQSY1o4eY=
Date: Mon, 29 Jan 2024 22:46:20 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch added to mm-unstable branch
Message-Id: <20240130064632.97245C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for monitor_on renaming
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for monitor_on renaming
Date: Mon, 29 Jan 2024 17:35:47 -0800

Update DAMON debugfs interface sections on the usage document to reflect
the fact that 'monitor_on' file has renamed to 'monitor_on_DEPRECATED'.

Link: https://lkml.kernel.org/r/20240130013549.89538-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   29 ++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -629,8 +629,9 @@ debugfs Interface (DEPRECATED!)
   linux-mm@kvack.org.
 
 DAMON exports nine files, ``DEPRECATED``, ``attrs``, ``target_ids``,
-``init_regions``, ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts``
-and ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+``init_regions``, ``schemes``, ``monitor_on_DEPRECATED``, ``kdamond_pid``,
+``mk_contexts`` and ``rm_contexts`` under its debugfs directory,
+``<debugfs>/damon/``.
 
 
 ``DEPRECATED`` is a read-only file for the DAMON debugfs interface deprecation
@@ -855,16 +856,16 @@ Turning On/Off
 
 Setting the files as described above doesn't incur effect unless you explicitly
 start the monitoring.  You can start, stop, and check the current status of the
-monitoring by writing to and reading from the ``monitor_on`` file.  Writing
-``on`` to the file starts the monitoring of the targets with the attributes.
-Writing ``off`` to the file stops those.  DAMON also stops if every target
-process is terminated.  Below example commands turn on, off, and check the
-status of DAMON::
+monitoring by writing to and reading from the ``monitor_on_DEPRECATED`` file.
+Writing ``on`` to the file starts the monitoring of the targets with the
+attributes.  Writing ``off`` to the file stops those.  DAMON also stops if
+every target process is terminated.  Below example commands turn on, off, and
+check the status of DAMON::
 
     # cd <debugfs>/damon
-    # echo on > monitor_on
-    # echo off > monitor_on
-    # cat monitor_on
+    # echo on > monitor_on_DEPRECATED
+    # echo off > monitor_on_DEPRECATED
+    # cat monitor_on_DEPRECATED
     off
 
 Please note that you cannot write to the above-mentioned debugfs files while
@@ -880,11 +881,11 @@ can get the pid of the thread by reading
 monitoring is turned off, reading the file returns ``none``. ::
 
     # cd <debugfs>/damon
-    # cat monitor_on
+    # cat monitor_on_DEPRECATED
     off
     # cat kdamond_pid
     none
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # cat kdamond_pid
     18594
 
@@ -914,5 +915,5 @@ directory by putting the name of the con
     # ls foo
     # ls: cannot access 'foo': No such file or directory
 
-Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on`` files are in the
-root directory only.
+Note that ``mk_contexts``, ``rm_contexts``, and ``monitor_on_DEPRECATED`` files
+are in the root directory only.
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


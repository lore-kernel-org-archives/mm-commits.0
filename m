Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C728827
	for <mm-commits@vger.kernel.org>; Wed,  1 Jan 2025 23:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735774770; cv=none; b=ca59hUW7W1PZNfHg1sffLB5DCj5CaRK+N/KvPrIaMxQ37APzwz1Hht0vZh+PHOwVD5yt+Op9MrzBiaqNwYnku2iRxWz3PrDMWnWW8/qmOw/nW142W1cYZhka4C9OdnYkJvKaIFWnrGpFwERYz1RPHWmKkzG7sqdEmaXkkxSAnPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735774770; c=relaxed/simple;
	bh=cVyVcag2fqC09gmvgbP1+wlkzwtyx32rO3Z5NBUG/Bs=;
	h=Date:To:From:Subject:Message-Id; b=fwjPsPNu0+HOompEcvltFG+nJrJ8cZ22DX2kfcDGiiT9DWU05gGzg2pPoAgpvtK/LcBbjmjAPev+WxVR1ZRtBtD9MhZS5bM8oBLXxls45U86uK+ypA0IV1Ffx3Qaq3FSczC9nAcWbj1FfeYgx/kZyX4FRNIRyQ3l0Z1zZPnUnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mbOkASsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mbOkASsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DA9C4CECE;
	Wed,  1 Jan 2025 23:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735774769;
	bh=cVyVcag2fqC09gmvgbP1+wlkzwtyx32rO3Z5NBUG/Bs=;
	h=Date:To:From:Subject:From;
	b=mbOkASshUVb33P7ZJahPlk00sOcBCrSaizuvD1o2FiAlPn7Jacc8AZUaREvo0uG70
	 1lqSKKhuEnv9l48gcbSLJpcGSDDNrP6T2//3jFxYxSsskXWG3TuBDz7CMv0YCmIPOm
	 uE7Z2IpUyl0Q7RPwSlWQdJKUq2cWaYmVceFCwWw4=
Date: Wed, 01 Jan 2025 15:39:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch added to mm-unstable branch
Message-Id: <20250101233929.54DA9C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: update for removal of DAMON debugfs interface
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch

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
Subject: Docs/mm/damon/design: update for removal of DAMON debugfs interface
Date: Wed, 1 Jan 2025 13:35:22 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Update DAMON design documentation to stop mentioning about the interface,
to avoid unnecessary confuses.

Link: https://lkml.kernel.org/r/20250101213527.74203-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface
+++ a/Documentation/mm/damon/design.rst
@@ -573,15 +573,11 @@ General Purpose User Interface Modules
 DAMON modules that provide user space ABIs for general purpose DAMON usage in
 runtime.
 
-DAMON user interface modules, namely 'DAMON sysfs interface' and 'DAMON debugfs
-interface' are DAMON API user kernel modules that provide ABIs to the
-user-space.  Please note that DAMON debugfs interface is currently deprecated.
-
-Like many other ABIs, the modules create files on sysfs and debugfs, allow
-users to specify their requests to and get the answers from DAMON by writing to
-and reading from the files.  As a response to such I/O, DAMON user interface
-modules control DAMON and retrieve the results as user requested via the DAMON
-API, and return the results to the user-space.
+Like many other ABIs, the modules create files on pseudo file systems like
+'sysfs', allow users to specify their requests to and get the answers from
+DAMON by writing to and reading from the files.  As a response to such I/O,
+DAMON user interface modules control DAMON and retrieve the results as user
+requested via the DAMON API, and return the results to the user-space.
 
 The ABIs are designed to be used for user space applications development,
 rather than human beings' fingers.  Human users are recommended to use such
@@ -590,8 +586,9 @@ Github (https://github.com/damonitor/dam
 (https://pypistats.org/packages/damo), and Fedora
 (https://packages.fedoraproject.org/pkgs/python-damo/damo/).
 
-Please refer to the ABI :doc:`document </admin-guide/mm/damon/usage>` for
-details of the interfaces.
+Currently, one module for this type, namely 'DAMON sysfs interface' is
+available.  Please refer to the ABI :ref:`doc <sysfs_interface>` for details of
+the interfaces.
 
 
 Special-Purpose Access-aware Kernel Modules
@@ -599,8 +596,8 @@ Special-Purpose Access-aware Kernel Modu
 
 DAMON modules that provide user space ABI for specific purpose DAMON usage.
 
-DAMON sysfs/debugfs user interfaces are for full control of all DAMON features
-in runtime.  For each special-purpose system-wide data access-aware system
+DAMON user interface modules are for full control of all DAMON features in
+runtime.  For each special-purpose system-wide data access-aware system
 operations such as proactive reclamation or LRU lists balancing, the interfaces
 could be simplified by removing unnecessary knobs for the specific purpose, and
 extended for boot-time and even compile time control.  Default values of DAMON
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch


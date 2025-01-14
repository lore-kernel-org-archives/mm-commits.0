Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC0823D3D1
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837176; cv=none; b=igQHJNN1BtuhpIe1xjYddBEFs2crTqV1S/FoDMcZGIqnQqXMMA6OP+KLwPpWfySlFvNAFGlozcyoNM6sSEcCASUSkoG/0nH3t09UKvotATevVfL1Dt8Z8TUREkgmw9LsmotlMUEJb4bxavN1jU8kEqUPPoyNHYXeZAnrLQTu0bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837176; c=relaxed/simple;
	bh=dhp7BmOZwx2l+H1QuVMGb9/vVRDqkSpTeKHswHAhGxk=;
	h=Date:To:From:Subject:Message-Id; b=VS6ab8e8szsRcjD42s/vmNw3tnjJbpuFXGVqdbWN7v2j8oRSlQaTSJL61xprPHpyX71y59fYpMeYW36Tnjl/VUYvs4C6Iva2GF+9WfCW/wxZ606l/DyuFxdj/1s8jPZ9MKFSWks9+ByDCaNNRGJWGuGJHXF4Ek8g4DPRytJLLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJ2n7Q4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJ2n7Q4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634F2C4CEDD;
	Tue, 14 Jan 2025 06:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837176;
	bh=dhp7BmOZwx2l+H1QuVMGb9/vVRDqkSpTeKHswHAhGxk=;
	h=Date:To:From:Subject:From;
	b=PJ2n7Q4n52Q7T6lFzJH/hi15KcifCrvgNDTcJTFk4tVVil/Dz+vTeOgBwB3OhCK9H
	 Zqou/Jw+/CzA6Jy71d/SxYkQsoyBHpOcKs89XuV7JS79yjfMAakqZ0B2bmdGOKSY4t
	 Ms/f8585FkS7am5r8zVcUIk680Eej9KFslLf3XyA=
Date: Mon, 13 Jan 2025 22:46:15 -0800
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch removed from -mm tree
Message-Id: <20250114064616.634F2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: update for removal of DAMON debugfs interface
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for removal of DAMON debugfs interface
Date: Mon, 6 Jan 2025 11:19:36 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Update DAMON design documentation to stop mentioning about the interface,
to avoid unnecessary confuses.

Link: https://lkml.kernel.org/r/20250106191941.107070-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface
+++ a/Documentation/mm/damon/design.rst
@@ -627,15 +627,11 @@ General Purpose User Interface Modules
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
@@ -644,8 +640,9 @@ Github (https://github.com/damonitor/dam
 (https://pypistats.org/packages/damo), and Fedora
 (https://packages.fedoraproject.org/pkgs/python-damo/damo/).
 
-Please refer to the ABI :doc:`document </admin-guide/mm/damon/usage>` for
-details of the interfaces.
+Currently, one module for this type, namely 'DAMON sysfs interface' is
+available.  Please refer to the ABI :ref:`doc <sysfs_interface>` for details of
+the interfaces.
 
 
 Special-Purpose Access-aware Kernel Modules
@@ -653,8 +650,8 @@ Special-Purpose Access-aware Kernel Modu
 
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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


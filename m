Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F682D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274563; cv=none; b=ZDrrXeJiW6GMK6WeZSaTaDu84DQdz7C/qiS9ocvgkOsb71ve/6Pvrj9oNchztYfSvXOcBVym4ztkztr3sKPkz8HQkJoEj78n0UAd+MbZVbOxSQc4E8Yt8Ss9B2hsOqIBTKqfWRucdECrxKnFPAKk7dmL7GSuV0QDnNJH0eFnD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274563; c=relaxed/simple;
	bh=r6H9Sur7HW+nLooWHnhv3NVW/0M708r0rwWVdsoFNvQ=;
	h=Date:To:From:Subject:Message-Id; b=MnHPmyEL29Nst456cUSXBSMrL39deiJ/aW+zoMXAtwZyKPu6eXXGA8R57UR7ICv5Iw9dXa3yhur8A2Mm5x7qPFwqeekjYV4en5GySZUkgtdinG5m+PSM9wHXb+nQWv/NN8HwTDEBg1JkVSZ2aCWahnLEc7stQLdZkLhDD1wpe18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WyLJaE9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WyLJaE9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A3BC4CEDD;
	Tue, 18 Mar 2025 05:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274563;
	bh=r6H9Sur7HW+nLooWHnhv3NVW/0M708r0rwWVdsoFNvQ=;
	h=Date:To:From:Subject:From;
	b=WyLJaE9C/bIyu5xV6EjovMg/jOFh+Grn624WsE29YF421X43uPK7h9IU9XI3r20kE
	 hWHdkRCIwADnCnned9JjKahemjPGKiCvZQWnXFFSzjwGnaWyaUDLN244KWPiKgbjfr
	 uq6/4XN9/07LKa3XVpImEW2Xi2fc6fwwP+hqNQHE=
Date: Mon, 17 Mar 2025 22:09:23 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-coreops_filters-directories.patch removed from -mm tree
Message-Id: <20250318050923.A4A3BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document {core,ops}_filters directories
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-coreops_filters-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document {core,ops}_filters directories
Date: Wed, 5 Mar 2025 14:27:32 -0800

Document the new DAMOS filters sysfs directories on ABI doc.

Link: https://lkml.kernel.org/r/20250305222733.59089-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   16 ++++++++++++++
 1 file changed, 16 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-coreops_filters-directories
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -409,6 +409,22 @@ Description:	Writing 'Y' or 'N' to this
 		applying the scheme's action to the memory that satisfies the
 		'type' and the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMON core layer-handled DAMOS filters.  Files
+		under this directory works same to those of
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+		directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/ops_filters
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMON operations set layer-handled DAMOS filters.
+		Files under this directory works same to those of
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+		directory.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_tried
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are



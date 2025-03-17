Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BDB217F46
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188478; cv=none; b=bPdLDOX4EoqohrlF/i664qcn5YrH/le/llIpB89PW7F/v+id9HmBHbs0Zs6hwguEYPUQUHXWqeIb7jIrTbZqZODsRkosGo4gYbArYxsyOj9QdBQVxG1kddWrafxbJF7gOVAFs2K3wE1yQvDntX4Mgi83jSeSN+4YjStcjdZaMP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188478; c=relaxed/simple;
	bh=oDU8Nh0M0Sr/xapl/ZOnb6nzgUdTB6GeE+XZYceXLU8=;
	h=Date:To:From:Subject:Message-Id; b=qeNotuV1sk+JdJXlIxcADDlPIwgIKV8TiCLdYss78y9IuAV1WDdZjAxNbiHM3DsOTe4MztOsH2zmUrpZ12PAj84AMTF71D+Lq1dnxWZJ4m0iy7pdnflo6i8VBVHuQ7wfVRPNlAUIw3vcFQyF6incAEzr5ENt427eVNib0uLDoGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6t5cJbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6t5cJbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E215C4CEEC;
	Mon, 17 Mar 2025 05:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188478;
	bh=oDU8Nh0M0Sr/xapl/ZOnb6nzgUdTB6GeE+XZYceXLU8=;
	h=Date:To:From:Subject:From;
	b=g6t5cJbrDiuBlx6EsAwkz2mEk6h2CuPqtMn6Ph7fk3LWnZ3AVM0QxaL+aY1PlkJHN
	 7czIkgV4k+9F9uIAz2u2R2mb04gtF9447rldYaHoGpYhhT8TPW3ihmgXnMF5o4Llr5
	 gnSpqXMcy/E6vrfDyOe+hYJHO+TRVaEE6lHnvSIM=
Date: Sun, 16 Mar 2025 22:14:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,bus710@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-a-typo-in-the-kconfig-sameple.patch removed from -mm tree
Message-Id: <20250317051438.4E215C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: a typo in the kconfig - sameple
has been removed from the -mm tree.  Its filename was
     samples-damon-a-typo-in-the-kconfig-sameple.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Seongjun Kim <bus710@gmail.com>
Subject: samples/damon: a typo in the kconfig - sameple
Date: Wed, 26 Feb 2025 10:42:04 -0800

There is a typo in the Kconfig file of the damon sample module.  Correct
it: s/sameple/sample/

Link: https://lkml.kernel.org/r/20250226184204.29370-1-sj@kernel.org
Signed-off-by: Seongjun Kim <bus710@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/samples/damon/Kconfig~samples-damon-a-typo-in-the-kconfig-sameple
+++ a/samples/damon/Kconfig
@@ -3,7 +3,7 @@
 menu "DAMON Samples"
 
 config SAMPLE_DAMON_WSSE
-	bool "DAMON sameple module for working set size estimation"
+	bool "DAMON sample module for working set size estimation"
 	depends on DAMON && DAMON_VADDR
 	help
 	  This builds DAMON sample module for working set size estimation.
@@ -15,7 +15,7 @@ config SAMPLE_DAMON_WSSE
 	  If unsure, say N.
 
 config SAMPLE_DAMON_PRCL
-	bool "DAMON sameple module for access-aware proactive reclamation"
+	bool "DAMON sample module for access-aware proactive reclamation"
 	depends on DAMON && DAMON_VADDR
 	help
 	  This builds DAMON sample module for access-aware proactive
_

Patches currently in -mm which might be from bus710@gmail.com are



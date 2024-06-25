Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B081BC4E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289469; cv=none; b=hXCYzTDYR1cRZSbcrk62UcfzE+nZvmnghm3Es+8OxPcgEQc/P8FH9+6HSBNdva1VKl77mQZx165GMHCXfzImsmpEhcg8g5hpzuANxs931BrJaDcxBKDGKTIyRATEv6LczHNnpxD4UxI+nF0nSK+SnV5niLLJ9i8izKVpM8qrSgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289469; c=relaxed/simple;
	bh=u6yJcsP2+6qOC12e0mliNMXI2MgLCjIv4yScGYZHuVo=;
	h=Date:To:From:Subject:Message-Id; b=nCr7Kb5SZCFs7tDKucbHfvCkc9OJdsMd2geBbQdybGi49+bkL1S8y77CbhOV1EGZjLEO8n88WZcvH+KYw/aKdyCZ6KqkwYltdziDnLwPtd76w0XFJmAn7sufraVjklyFQk+QTQlD9/JW8aPvvR5Aopl0hyQqO5U+eUVST36k4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z24gIcjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z24gIcjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7420C32782;
	Tue, 25 Jun 2024 04:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289468;
	bh=u6yJcsP2+6qOC12e0mliNMXI2MgLCjIv4yScGYZHuVo=;
	h=Date:To:From:Subject:From;
	b=z24gIcjvew8EHBGbwZQ8fIphBgSnREGC1YOANWfv7Vc7IHHh93np5Bsgm3Zop+Q4h
	 aj0k3BdRRfNqG5RVjh3QBSYEpgKJ2d3v5EYoarGm0GVUIgt2DKCxOcmQ0ClNNFClhq
	 I7ZMMOAzMtAgbHbzjoz/XaUL0buWbGOzqQGSMqWE=
Date: Mon, 24 Jun 2024 21:24:28 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch removed from -mm tree
Message-Id: <20240625042428.C7420C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

This patch was dropped because it was folded into mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
Date: Tue Jun 11 02:56:34 PM PDT 2024

reflow transhuge.rst addition to 80 cols

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -332,12 +332,13 @@ deny
 force
     Force the huge option on for all - very useful for testing;
 
-Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to control
-mTHP allocation: '/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
-and its value for each mTHP is essentially consistent with the global setting.
-An 'inherit' option is added to ensure compatibility with these global settings.
-Conversely, the options 'force' and 'deny' are dropped, which are rather testing
-artifacts from the old ages.
+Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to
+control mTHP allocation:
+'/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
+and its value for each mTHP is essentially consistent with the global
+setting.  An 'inherit' option is added to ensure compatibility with these
+global settings.  Conversely, the options 'force' and 'deny' are dropped,
+which are rather testing artifacts from the old ages.
 
 always
     Attempt to allocate <size> huge pages every time we need a new page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch


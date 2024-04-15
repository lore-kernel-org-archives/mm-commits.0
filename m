Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B4156237
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211217; cv=none; b=i2APneKFrJyeZgcg/hOrySnietBkp4yayGOBeJilgfAhJ+Xeh2OJGY1Dv6ImV4t0AwLZnimBxjUV4TSTS2ITdj6C6lmTONgWXmiAZ6PHDgYzEgy4kLC9OLJYapwolXF+dEXEayKAzJt20Sqsryw8PYB2GGrB2iiTa3nVOuwCIRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211217; c=relaxed/simple;
	bh=QSKGMZfXdPDxYFHReqdpTcpuqXg/iNb1uO8TAAhrYTQ=;
	h=Date:To:From:Subject:Message-Id; b=hHWxAOlqmItyDW/35DfShryLHynFC3bP4bf5jSxSRvyb8IeC0HdgSdtRfZRwzXtugCaiP8VRnSabvrtb6aW9JA+dhpPxmFMY4qmi7gU4jcRBT+N8+be2RIdkiheq7w9swP0oZw5Ig1y586cX9OIsdz7Qfxz0ey6dGJIDF6etvBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnA0Q66W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnA0Q66W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A82BC113CC;
	Mon, 15 Apr 2024 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713211217;
	bh=QSKGMZfXdPDxYFHReqdpTcpuqXg/iNb1uO8TAAhrYTQ=;
	h=Date:To:From:Subject:From;
	b=NnA0Q66W3GGeL6oZA6V2Y+c9x/I80lGSt1YeaBjymc6nHJViRtUeuhgCI0b0HISJk
	 9RcTvRt2kO0rBSwMU0cv88mKMe/wEX3mGwB7p3QEvMp/9/LfV/GgmqbOqh54urgPsr
	 AQXSLa6+NDh5W++h1mFCW0JcG0EcU8bxlB7EZK0Y=
Date: Mon, 15 Apr 2024 13:00:16 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch added to mm-unstable branch
Message-Id: <20240415200017.4A82BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysfs-kernel-mm-transparent-hugepage: fix the name and unexpected indentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: sysfs-kernel-mm-transparent-hugepage: fix the name and unexpected indentation
Date: Mon, 15 Apr 2024 17:37:04 +1200

Link: https://lkml.kernel.org/r/20240415054538.17071-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage   |   17 ---------
 Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage |   18 ++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
@@ -0,0 +1,18 @@
+What:		/sys/kernel/mm/transparent_hugepage/
+Date:		April 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		/sys/kernel/mm/transparent_hugepage/ contains a number of files and
+		subdirectories,
+
+			- defrag
+			- enabled
+			- hpage_pmd_size
+			- khugepaged
+			- shmem_enabled
+			- use_zero_page
+			- subdirectories of the form hugepages-<size>kB, where <size>
+			  is the page size of the hugepages supported by the kernel/CPU
+			  combination.
+
+		See Documentation/admin-guide/mm/transhuge.rst for details.
--- a/Documentation/ABI/testing/sys-kernel-mm-transparent-hugepage
+++ /dev/null
@@ -1,17 +0,0 @@
-What:		/sys/kernel/mm/transparent_hugepage/
-Date:		April 2024
-Contact:	Linux memory management mailing list <linux-mm@kvack.org>
-Description:
-		/sys/kernel/mm/transparent_hugepage/ contains a number of files and
-		subdirectories,
-			- defrag
-			- enabled
-			- hpage_pmd_size
-			- khugepaged
-			- shmem_enabled
-			- use_zero_page
-			- subdirectories of the form hugepages-<size>kB, where <size>
-			  is the page size of the hugepages supported by the kernel/CPU
-			  combination.
-
-		See Documentation/admin-guide/mm/transhuge.rst for details.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch


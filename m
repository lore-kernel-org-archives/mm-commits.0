Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779EB13AA3F
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041436; cv=none; b=rHYbVZiLs6Qy+EdpqYMl8rQ50J2bBBJvMARjsnu980ibouPmhS6F/BucP4iuY5gqrCM8cE6gFN2WOvOGp6+0J8Aw5zBou9QJFD5uD9YnRdjeVByICi25eQ+u8iIfOL+y0P/1bcA8cv8UI4XXRDAsN0gc+dBrtf5PBqr8C4wdIuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041436; c=relaxed/simple;
	bh=gRi+e+9fDu4gdvXcjzx3rl7V/E4ot8Orm1MUPzpMO2g=;
	h=Date:To:From:Subject:Message-Id; b=sL1zf58Gg9j7i98QMtduXP2+xR82JlHBxKkEZPYEMS+8iPxIMgZHM/VqixePnHucdym/7F2f8b/rEMZLzhvhLOFJ17ntTkJBD1bObZaebknaCRhU9bIh+p4u+WeovLxvUM8rOUjFBDVbjHJyf9LqTHCBxkr+ZWm7n1TxFioGs1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hG7Fcjz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hG7Fcjz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAD3C433C7;
	Thu, 15 Feb 2024 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708041435;
	bh=gRi+e+9fDu4gdvXcjzx3rl7V/E4ot8Orm1MUPzpMO2g=;
	h=Date:To:From:Subject:From;
	b=hG7Fcjz2vtP0F6e6d39sBH/kWcpfGP8cnWVvRbnfMLg5QysaNn711IgAvCKbinTr8
	 efeVQY8Kc/UJKvkV8E+xqb6q8vCqaX+HoYbAIb19cznsXuEOMafrrRsQ4IvpHUIyFH
	 iuV+5QeTmPKXjahL2emsVTIhGsC6YHiPY1zCoOvA=
Date: Thu, 15 Feb 2024 15:57:15 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch added to mm-unstable branch
Message-Id: <20240215235715.CFAD3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: ensure adequate CMA areas available for hugetlb_cma[]
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: ensure adequate CMA areas available for hugetlb_cma[]
Date: Thu, 15 Feb 2024 10:04:05 +0530

HugeTLB CMA area array is being created for possible MAX_NUMNODES without
ensuring corresponding MAX_CMA_AREAS support in CMA.  This fails the build
for such scenarios indicating need for CONFIG_CMA_AREAS adjustment.

Link: https://lkml.kernel.org/r/20240215043405.2379295-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma
+++ a/mm/hugetlb.c
@@ -7855,6 +7855,13 @@ void __init hugetlb_cma_reserve(int orde
 	}
 
 	reserved = 0;
+
+	/*
+	 * There needs to be enough MAX_CMA_AREAS to accommodate
+	 * MAX_NUMNODES heap areas being created here. Otherwise
+	 * adjust CONFIG_CMA_AREAS as required.
+	 */
+	BUILD_BUG_ON(MAX_CMA_AREAS < MAX_NUMNODES);
 	for_each_online_node(nid) {
 		int res;
 		char name[CMA_MAX_NAME];
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch
mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch
mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch


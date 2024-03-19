Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6E3BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882979; cv=none; b=Oftk21sb6X15XlP5BurYdb1J2Quxg4/ias6+nhTZigxnfjWdD/cTIOSryC1hPTm/3qKeo3wa8djqZXL7nu4oherC4ZLFRZNgCWGNtOVFmMIA+i0ERTP0qUyEgkcORURA/M9qWMZBJp3G2KB+X4uvL0kU8ni+PyIgX3Th1a3vYsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882979; c=relaxed/simple;
	bh=nQSFlLxf2dX7epcUFG/TEXLzGmCyVcHrRK5w5XZWELM=;
	h=Date:To:From:Subject:Message-Id; b=soElejdhfUhUV5nUSQHvKEEvrEc0qG+HVEUW6NMCuRPPPSrxsZCa25xp5Zwq+c3XZmqyliDtGckc7eSBCL6gIcU1xdP1MSoMxui8u+aVI8l198lNLNQB6NkZ2+gKiODvRxdlciHBHuE8oEeXspUgKrEJbub5epqhl9K1i18AZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zQFFtGwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQFFtGwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BC0C433F1;
	Tue, 19 Mar 2024 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882979;
	bh=nQSFlLxf2dX7epcUFG/TEXLzGmCyVcHrRK5w5XZWELM=;
	h=Date:To:From:Subject:From;
	b=zQFFtGwW1DiZFIZIoYDrAwmgo9PAaKDWlxC8iyy6jd+NEzLPLnEGaiwtpP0074XrJ
	 XNt5zPT3+EM0ptA0RNpMQXmwyY0333pfuC3HUA1iFUdGXOlHvPdvjtpt4AHM3O4Ah4
	 2l/zNbJhHZn9dYlj5zweYZQZFmL13eoOYUM5edSw=
Date: Tue, 19 Mar 2024 14:16:18 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch added to mm-unstable branch
Message-Id: <20240319211618.E2BC0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
Date: Tue Mar 19 02:14:43 PM PDT 2024

s/;;/;/, per Muchun

Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/hugetlbpage.c~mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -409,7 +409,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 
 int pmd_huge(pmd_t pmd)
 {
-	return pmd_leaf(pmd);;
+	return pmd_leaf(pmd);
 }
 
 int pud_huge(pud_t pud)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch


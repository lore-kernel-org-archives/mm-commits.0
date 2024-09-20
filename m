Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDF6FB6
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726827861; cv=none; b=BKXcb1J0zgdiyi3KhuI6QoPHD4zUmJmQRAGV9u/kre4B+U4ULy+vaw4APFbzxrC4N+9bXTIfM50pavlIqKGBZTH1Ekk8LBWBuqMphHyrMbikwixXPnHV5RkojgrjRkWVMlv0JA4558UmvUdFg1NAXEwBJJhMx6L/3X8nVIwNirU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726827861; c=relaxed/simple;
	bh=1NSmz5QLS+JqwzeMMXWePmHanEgRyCdrwT+B47WP/OE=;
	h=Date:To:From:Subject:Message-Id; b=q21REFEQ7XX6dwpKKEHc1/akJX0Xj1kllOP4sUGBbGxlRYnkcErBgIwExToC+ncDtQzlfg4K54jeW/DGjSLyJRvuHpYSpd1z+oktxKxX65aRvrMMQaFVv/MgEWpGWpJH7FMI/XN69+ff8DL7bpJI0UNnr4f1g6Q29i9luDB9r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PwAsqAGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PwAsqAGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E72C4CEC3;
	Fri, 20 Sep 2024 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726827860;
	bh=1NSmz5QLS+JqwzeMMXWePmHanEgRyCdrwT+B47WP/OE=;
	h=Date:To:From:Subject:From;
	b=PwAsqAGVeT3VU2NjxLdDNRW14GMhaUH9meDqNaFYeQEXbJFfXK2vzmCzsvHoXk3/R
	 WUNa0RUtQ7xSrq5tvjE3n1K5+HqcNHNvQCPLGFhW2iV322MOoqaj9MSdm/z0yB1jGG
	 l6GuirYTBfjApTnxrv7Heg0gK8XXcuLoHu0SwncU=
Date: Fri, 20 Sep 2024 03:24:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,lkp@intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch added to mm-unstable branch
Message-Id: <20240920102420.D2E72C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch

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
Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
Date: Fri Sep 20 03:19:14 AM PDT 2024

fix the fix

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
+++ a/mm/shmem.c
@@ -1652,7 +1652,7 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 	return result;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(SHMEM)
 bool shmem_hpage_pmd_enabled(void)
 {
 	if (shmem_huge == SHMEM_HUGE_DENY)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch
mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch


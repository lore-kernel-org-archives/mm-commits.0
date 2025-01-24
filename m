Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A1E5588E
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 06:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737698600; cv=none; b=PHuNgw1oElSuj/gntkZnFt7UxU83g3QPaI+BYdqEsbfAzr3FBg1mSqp6pZFJikqephNuX+gjy5J4V0WCHU87GKkm4qxUef+vpxDoaBP4OMhrod+KA8QUPJTuu4gyXQJD3ZAwwBgXNsDY/FTaFH9+uuuCQ2/BSNCwELzEJq/oBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737698600; c=relaxed/simple;
	bh=IZ6EeCdA7xIJmjaSPB1UMcHrPK89Yfk+sEVnEcpBNsQ=;
	h=Date:To:From:Subject:Message-Id; b=YtS4smcRXuP19hW1HUeq4pCI3gDjQY5kOFhQo3UKnxAqafTBE2VbYAig+oyFbVf89D3OrFgGp9EOcNKXQGHApIUPHtIc813fLWiISvT/z5g7G8M0mH3qwJuTbrMsf84Qq8MdCYAbpFqPRavDp4Rmtm7Zbaryh3JByqP0lAP4JMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHnxwK45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHnxwK45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0E7C4CED2;
	Fri, 24 Jan 2025 06:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737698599;
	bh=IZ6EeCdA7xIJmjaSPB1UMcHrPK89Yfk+sEVnEcpBNsQ=;
	h=Date:To:From:Subject:From;
	b=wHnxwK45fDHkr8iyEeZZefgg0qoD5hqNz5QuDnhrzzwXHpjv6WPLvMXAYuN8sB8qP
	 /h77JyqycrUv2/vYO6eYWxCUnQkJKHYWBK5D+iWNbaQT+sGG1nuKYKCHoNGoYMPeZ3
	 4PTr912I+KW7CuJD+1FauNqzC4lacZUjIPZKOS/E=
Date: Thu, 23 Jan 2025 22:03:18 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,kevin.brodsky@arm.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch added to mm-unstable branch
Message-Id: <20250124060319.7F0E7C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/mm: add missing ctor/dtor on page table upgrade
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch

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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: s390/mm: add missing ctor/dtor on page table upgrade
Date: Thu, 23 Jan 2025 17:03:49 +0100

Commit 78966b550289 ("s390: pgtable: add statistics for PUD and P4D level
page table") misses the call to pagetable_p4d_ctor() against a newly
allocated P4D table in crst_table_upgrade();

Commit 68c601de75d8 ("mm: introduce ctor/dtor at PGD level") misses the
call to pagetable_pgd_ctor() against a newly allocated PGD and the call to
pagetable_dtor() against a newly allocated P4D that is about to be freed
on crst_table_upgrade() PGD upgrade fail path.

The missed constructors and destructor break (at least) the page table
accounting when a process memory space is upgraded.

Link: https://lkml.kernel.org/r/20250123160349.200154-1-agordeev@linux.ibm.com
Fixes: 78966b550289 ("s390: pgtable: add statistics for PUD and P4D level page table")
Fixes: 68c601de75d8 ("mm: introduce ctor/dtor at PGD level")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/all/20250122074954.8685-A-hca@linux.ibm.com/
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/mm/pgalloc.c~s390-mm-add-missing-ctor-dtor-on-page-table-upgrade
+++ a/arch/s390/mm/pgalloc.c
@@ -88,12 +88,14 @@ int crst_table_upgrade(struct mm_struct
 		if (unlikely(!p4d))
 			goto err_p4d;
 		crst_table_init(p4d, _REGION2_ENTRY_EMPTY);
+		pagetable_p4d_ctor(virt_to_ptdesc(p4d));
 	}
 	if (end > _REGION1_SIZE) {
 		pgd = crst_table_alloc(mm);
 		if (unlikely(!pgd))
 			goto err_pgd;
 		crst_table_init(pgd, _REGION1_ENTRY_EMPTY);
+		pagetable_pgd_ctor(virt_to_ptdesc(pgd));
 	}
 
 	spin_lock_bh(&mm->page_table_lock);
@@ -130,6 +132,7 @@ int crst_table_upgrade(struct mm_struct
 	return 0;
 
 err_pgd:
+	pagetable_dtor(virt_to_ptdesc(p4d));
 	crst_table_free(mm, p4d);
 err_p4d:
 	return -ENOMEM;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch


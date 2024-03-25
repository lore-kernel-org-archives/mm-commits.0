Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F11D53F
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711388831; cv=none; b=UgDZhICTEGA/krNrl+5/lV1bcCaSc2Hle+RmUKdvYawx51x7YYfQ2Ks5SJgjHp5lv9CTm9R7jYkpawd+rppt/8z0fkwSDmBCobxSCHLn6onEaMp2oosBZH/DqF1oOHnutDRYnLuVCApIBCWXC/oIy8T7grmrG7A6u3gvbipvqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711388831; c=relaxed/simple;
	bh=p059cdlHEruis5XQDcEUdYeYCZscvQyZhKuIGP4XAL0=;
	h=Date:To:From:Subject:Message-Id; b=JNKVrMUaj/2ndm6gkndDETtx5IZpt6kt8J/aUNvJhrGXzOJn/vPf+0JQ3fM6Pehb8sruqPZjD+q7xMvID0sRbxAeucVflxnA783tYced5vVyraRcFntDh0Kwt0jLrLl+e8SZ1GuUEI+/iH8MqHRnk2ouYsNFoKwdATvhXWr37DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMxrfHs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMxrfHs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D1EC433C7;
	Mon, 25 Mar 2024 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711388830;
	bh=p059cdlHEruis5XQDcEUdYeYCZscvQyZhKuIGP4XAL0=;
	h=Date:To:From:Subject:From;
	b=mMxrfHs6kidm9Yhn1FlVzZHtakH+zae3YpOOn7wFXlwDd+qJFpuf0eGqxlQVtXhef
	 gUctQLSgoNNjUoF3PQliKrPTSNAwabSU67E4HYPTSsWBOQ/Lw0ngbTYFsbTNUtHaXQ
	 sRWFk1uC56+AmzEVqO1eVkyNHbQqpug00x2MR5WU=
Date: Mon, 25 Mar 2024 10:47:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,rppt@kernel.org,riel@surriel.com,peterx@redhat.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-handle-huge-pud-for-follow_pud_mask-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240325174710.80D1EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-handle-huge-pud-for-follow_pud_mask-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-gup-handle-huge-pud-for-follow_pud_mask-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-handle-huge-pud-for-follow_pud_mask-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-gup-handle-huge-pud-for-follow_pud_mask-fix
Date: Fri Mar 22 03:13:23 PM PDT 2024

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup.c~mm-gup-handle-huge-pud-for-follow_pud_mask-fix
+++ a/mm/gup.c
@@ -19,6 +19,7 @@
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
+#include <linux/huge_mm.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-gup-handle-huge-pud-for-follow_pud_mask-fix.patch


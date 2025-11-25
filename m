Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5957329E78
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090935; cv=none; b=ZkL+LXTb8ofglNXfIiNOtRVy+lSd6nslKEVsA8De8vJpV/qhws2yDspnQ1iI36HGUZgk75qGPy6mLsKMnx7HiL6L7N6saZC5HdIfNht5UGID38iCzXK6tTZV5E8cauDzkjyqrEyiBkmECwG/lkUDW7NGDTPCk7ZU/lyLCSVwBSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090935; c=relaxed/simple;
	bh=+3MJK2/xB8bmQW3Juc3lQQbEc2huPagpoF4DMVU17OU=;
	h=Date:To:From:Subject:Message-Id; b=YltT8qlzK4OL20UvMZCWRw7PH21HLDxG5phgpIgvyO0KKupPE9KawYEaSKoQPdjvueqUhTr9Assiym4ZaOvrYEiBDwIu/cQFS7LddUha/lu1pBg0X336XDB4McVcSERkXQAN4sKrlrbi7TUXWojNdjMB79DHJlgeQg7MQskBLCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2d0GchPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2d0GchPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEFAC4CEF1;
	Tue, 25 Nov 2025 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764090932;
	bh=+3MJK2/xB8bmQW3Juc3lQQbEc2huPagpoF4DMVU17OU=;
	h=Date:To:From:Subject:From;
	b=2d0GchPugnJ+YZXK3LZFYIaJSMl2qCgK8Kcdhqqa+xovvU2Jw1OcY6uYDOmCHt4n2
	 XR38iybkqsVn9jMZFeXv7j2zJYE8MMcf0Sj3r/zhoMMaSBCrpoKRA20iXxf7YGwXgf
	 3vEqw2M4IuOnW84h7ZWSdX1QFx/unQIN84YtT/nM=
Date: Tue, 25 Nov 2025 09:15:31 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch added to mm-nonmm-unstable branch
Message-Id: <20251125171532.3DEFAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: kho_restore_vmalloc: fix initialization of pages array
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: kho_restore_vmalloc: fix initialization of pages array
Date: Tue, 25 Nov 2025 13:09:16 +0200

Patch series "kho: fixes for vmalloc restoration".

Pratyush reported off-list that when kho_restore_vmalloc() is used to
restore a vmalloc_huge() allocation it hits VM_BUG_ON() when we
reconstruct the struct pages in kho_restore_pages().

These patches fix the issue.


This patch (of 2):

In case a preserved vmalloc allocation was using huge pages, all pages in
the array of pages added to vm_struct during kho_restore_vmalloc() are
wrongly set to the same page.

Fix the indexing when assigning pages to that array.

Link: https://lkml.kernel.org/r/20251125110917.843744-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20251125110917.843744-2-rppt@kernel.org
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-kho_restore_vmalloc-fix-initialization-of-pages-array
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1096,7 +1096,7 @@ void *kho_restore_vmalloc(const struct k
 				goto err_free_pages_array;
 
 			for (int j = 0; j < contig_pages; j++)
-				pages[idx++] = page;
+				pages[idx++] = page + j;
 
 			phys += contig_pages * PAGE_SIZE;
 		}
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch
kho-drop-notifiers.patch
kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch
kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch


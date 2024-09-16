Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4906381B1;
	Mon, 16 Sep 2024 06:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726466623; cv=none; b=iXeH/AYGIHl3HUG8pefzfRmfi418R89Z3ZigGQz7nrCT+mtACoZMVj8GV/FExMpb8W0/2bMU0jvbjts8GfUiPRTX5xAgER58D5BtSDBgQf2Ts438m2zCHsUxnKrKX5aobpYw0b4NKRsqtVij6aCtKypWqqNXGPf/6OHwrYTlkJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726466623; c=relaxed/simple;
	bh=kV+DuwdGhpzOzFA6zt3AsB/r5Orvqk9kwp5hxIG6wgU=;
	h=Date:To:From:Subject:Message-Id; b=pwq8rZgFJr5mvVXcyn3YLmQgtKduAHelexrDQi4fYCgEbJRvtFbWuDTOVkp97gU8gNixsJ7zyjn/wkiL8S7pNg9eQHi8ORZ5rzkZ+ViT31OQilrfLWS8V6mojp4rde8ARTYeD2tTrfRjL2XU9uzqdsCmTKkmUa8JoBDEzBpdbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlQrg2uW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlQrg2uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE2CC4CEC4;
	Mon, 16 Sep 2024 06:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726466622;
	bh=kV+DuwdGhpzOzFA6zt3AsB/r5Orvqk9kwp5hxIG6wgU=;
	h=Date:To:From:Subject:From;
	b=IlQrg2uWEs31cbvQOiQQiZbnBZbtwwdM2WqQcxg2qZgFqQy7CySjdL77aPjLawhJL
	 QOj9b3LJfk5WGfly2P+tH/62qk1BBlnyRPt1qdXFjPYvPoR3M5tYFW+5BzrZ3dr8Xm
	 VC05rRMjdIjcv/FUq3bMQA8YdQlRVBbdaMp0Hhdw=
Date: Sun, 15 Sep 2024 23:03:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch added to mm-hotfixes-unstable branch
Message-Id: <20240916060341.DAE2CC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway
Date: Sat, 14 Sep 2024 12:41:19 -0700

Syzbot reports a UAF in hugetlb_fault().  This happens because
vmf_anon_prepare() could drop the per-VMA lock and allow the current VMA
to be freed before hugetlb_vma_unlock_read() is called.

We can fix this by using a modified version of vmf_anon_prepare() that
doesn't release the VMA lock on failure, and then release it ourselves
after hugetlb_vma_unlock_read().

Link: https://lkml.kernel.org/r/20240914194243.245-2-vishal.moola@gmail.com
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway
+++ a/mm/hugetlb.c
@@ -6065,7 +6065,7 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	ret = vmf_anon_prepare(vmf);
+	ret = __vmf_anon_prepare(vmf);
 	if (unlikely(ret))
 		goto out_release_all;
 
@@ -6264,7 +6264,7 @@ static vm_fault_t hugetlb_no_page(struct
 		}
 
 		if (!(vma->vm_flags & VM_MAYSHARE)) {
-			ret = vmf_anon_prepare(vmf);
+			ret = __vmf_anon_prepare(vmf);
 			if (unlikely(ret))
 				goto out;
 		}
@@ -6395,6 +6395,14 @@ static vm_fault_t hugetlb_no_page(struct
 	folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() is
+	 * the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
@@ -6616,6 +6624,14 @@ out_ptl:
 	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() in
+	 * hugetlb_wp() is the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-change-vmf_anon_prepare-to-__vmf_anon_prepare.patch
mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A02156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756856; cv=none; b=ff0DKVw4AwR69G+Eb+hsYsq133Y196+Eh7/eQvzQaveVq06bXk2ufPyuEIak6Z+16MrgkUpmPxfAojE9q2GYMKJlvIeJiBgwdsCM1xRnRwp858pp9IMk3elBS8CBJvNbqFdy6yDd882KIBPAOaWznVq+HRvPT2obtARK/UuSZjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756856; c=relaxed/simple;
	bh=7sNQ04L++SlVSYCvr10+kAv9Nmhi2dGdffQ5RooSQhg=;
	h=Date:To:From:Subject:Message-Id; b=Isdc5yXaLMp5XHKxh1hLiSyZUsRNR5/fpMVMJpDtwVendLRVV2B98Qz0nQa1zCCbbZSBvpqSbUVJy4cwhKuIMPVN8hgoHpYDy1+2F/UMW+oZtSSyzk4P1WIt+dk9qYgXqDyBVQX7M5oQHUCIHlxShNDUDhLqVdpF/iHCzXu8mv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TJ0Zj1uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TJ0Zj1uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC10C4CEED;
	Sun,  1 Jun 2025 05:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756856;
	bh=7sNQ04L++SlVSYCvr10+kAv9Nmhi2dGdffQ5RooSQhg=;
	h=Date:To:From:Subject:From;
	b=TJ0Zj1uCAfnOlV93yfPi1nbBCVAqSppdgrrmA11v6aa3zgLOzab4ZQ0E8iMYIMpWv
	 pp96UGXKVCx7vnZojgRzFomstyL7c1nnLR7qQYIOiDK+RVpuj2gVfL0NwqvAc4xciL
	 +VI5nVdCM8V1+lX/2tx+Wo7hREj2bUmRv2zn3BVU=
Date: Sat, 31 May 2025 22:47:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-add-missing-function-stub.patch removed from -mm tree
Message-Id: <20250601054736.1EC10C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: add missing function stub
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-add-missing-function-stub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: add missing function stub
Date: Wed, 28 May 2025 15:15:39 +0100

The hugetlb fix introduced in commit ee40c9920ac2 ("mm: fix copy_vma()
error handling for hugetlb mappings") mistakenly did not provide a stub
for the VMA userland testing, which results in a compile error when trying
to build this.

Provide this stub to resolve the issue.

Link: https://lkml.kernel.org/r/20250528-fix-vma-test-v1-1-c8a5f533b38f@oracle.com
Fixes: ee40c9920ac2 ("mm: fix copy_vma() error handling for hugetlb mappings")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by:  Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-add-missing-function-stub
+++ a/tools/testing/vma/vma_internal.h
@@ -1461,4 +1461,9 @@ static inline int __call_mmap_prepare(st
 	return file->f_op->mmap_prepare(desc);
 }
 
+static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
+{
+	(void)vma;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DEB18CBFE
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457335; cv=none; b=CVv8J6Pu4GHduXtqqMWrO02GTuX/LsSgNQePp5pXoqHc/tG8sRrKIQqMbsvyXT9swOc0F49mOCbn0MHQqduNo+mLUkG+tkWQ+JZ9wVKDgDBNjM1qFK0HUMnDDIy3OESC+ztuxoeRoZiSzaJodZIN4tDq4otmjx65v6cVExL3Kjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457335; c=relaxed/simple;
	bh=D/Vj/PckySJzVPvKTCX1bf444mgYAnJEFX2xB4logPA=;
	h=Date:To:From:Subject:Message-Id; b=Mu8I1nd2vc706LppnNlgZyYVCsnlDjp3OFTThLRFnkfbMKV6M7q/Xep9fCVRDOdBO782MW7hth1TuvMIBDNbCwP80p4U3LI9/na6y/ZCZ9+wSIlfZbYvprK7ONJzBLStMEaxxm7VMnEqTwWY0hUckeku1Ex0USRxpaqOnP9iNcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U50dbI/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U50dbI/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDBEC4CED1;
	Fri,  6 Dec 2024 03:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457334;
	bh=D/Vj/PckySJzVPvKTCX1bf444mgYAnJEFX2xB4logPA=;
	h=Date:To:From:Subject:From;
	b=U50dbI/5ysh2AaBRHYCL2A7/1K5XPz/DtRHi1CwobQhoPYOBM70cjlyYH3rc/SlsV
	 PkQgHcSDo+q4kgmT5cV9lrFd+tSwxSaeQfdyRbahHfmGQAe8Bb1Ok3dpwp8mDoGrep
	 YnapcVjesDYX7nrc75b4JFJNGZsR6U2KI00iwo7k=
Date: Thu, 05 Dec 2024 19:55:34 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-correct-typo-in-mmap_state-macro.patch removed from -mm tree
Message-Id: <20241206035534.CFDBEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correct typo in MMAP_STATE() macro
has been removed from the -mm tree.  Its filename was
     mm-correct-typo-in-mmap_state-macro.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: correct typo in MMAP_STATE() macro
Date: Mon, 18 Nov 2024 17:54:14 +0000

We mistakenly refer to len rather than len_ here.  The only existing
caller passes len to the len_ parameter so this has no impact on the code,
but it is obviously incorrect to do this, so fix it.

Link: https://lkml.kernel.org/r/20241118175414.390827-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-correct-typo-in-mmap_state-macro
+++ a/mm/vma.c
@@ -35,7 +35,7 @@ struct mmap_state {
 		.mm = mm_,						\
 		.vmi = vmi_,						\
 		.addr = addr_,						\
-		.end = (addr_) + len,					\
+		.end = (addr_) + (len_),				\
 		.pgoff = pgoff_,					\
 		.pglen = PHYS_PFN(len_),				\
 		.flags = flags_,					\
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18E3A1DB
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 00:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762560865; cv=none; b=kIxSzwpcIl1j55n9mCGU/n2Rl4jSZ7MlE6MXBaYNR6i0r9h6P8q/DeNTnFHUvtnHNX7FIJGtehQSiBeH0zqqSPaEbTGZttJHt6ErxFht21s5nIdO4BVcIeGm16PHqsr5XqH2SnbIwA63cTdFImxAvXVtxeGvlzD70M4bab6tTpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762560865; c=relaxed/simple;
	bh=jsh1i/7vp1aYW4wmz+uUSNGYUtIzIBIW1NWZc3IWnSg=;
	h=Date:To:From:Subject:Message-Id; b=gOMbFuvyBHqZ9bI78hw+iEWxYHPcodJ7fY4aQpDndKZZh5rTXI2q9orOVKrpA1fX/w0F0qzNV7kqs/HUeozBBV1sCAZZAQRqZ3w9P95wtk1oGmYFYttmjHY8TyZVpc8savPW4vbn45ejt87EU50aTT5FJr5bQNnPLsV7exUyNSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njW2xhFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njW2xhFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4640C113D0;
	Sat,  8 Nov 2025 00:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762560864;
	bh=jsh1i/7vp1aYW4wmz+uUSNGYUtIzIBIW1NWZc3IWnSg=;
	h=Date:To:From:Subject:From;
	b=njW2xhFs8AOBker/xwpzuqXJGDPtkwbZn1L2BEzNyW+20Z9GaW+mDWmSdzVyrwheS
	 hPm8mAQZ4w2iIxjXz9VS7Rg+oSoEe5CdWk8mAFbuHYV52LU4TkImu6R2cIk3fJJKpu
	 E0X4Q5njzB6PXO33RygngfXKm9PVvhR3JkYS5M4A=
Date: Fri, 07 Nov 2025 16:14:24 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rdunlap@infradead.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix.patch added to mm-unstable branch
Message-Id: <20251108001424.C4640C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix.patch

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
Subject: mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix
Date: Fri Nov  7 04:12:44 PM PST 2025

fix kerneldoc warning, per Randy

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix
+++ a/include/linux/mm_types.h
@@ -286,7 +286,7 @@ typedef struct {
 } swp_entry_t;
 
 /**
- * leaf_entry_t - Describes a page table 'leaf entry'.
+ * typedef leaf_entry_t - Describes a page table 'leaf entry'.
  *
  * Leaf entries are an abstract representation of all page table entries which
  * are non-present. Therefore these describe:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31BF9E6
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741046065; cv=none; b=JToNS45HF6dPQeU0DYp8btsf5f+nu/vcfrMHjGF0vQi5VBa8671dJnRyhJdiKG4ZXvzYpdIHWYyhuexJppAaHktlcDff+6pixUX3EQPldCbzWdJMq1CY3iczqUU6iSQb8DjI71Geb/jIql/Yv+AKyeQXyd2EhGXAKMm/qu+7rHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741046065; c=relaxed/simple;
	bh=q3XLteGa9J/GCsxb8Sgpzaa8Es3Eze15Tkxv7ESRmWY=;
	h=Date:To:From:Subject:Message-Id; b=vF05WyqBuooH7THKN9c7CKSklBVhLWWPbvsYVPist8nUTooSWxj0RKpZpx5i4u4+7VPcqUozcZsF6gvuDY4W5C3GsQaa9Br+lHbep/JhR3bROj+FXOT9+GZSI2Fi/KETJIllsvyynvPkKl5/69MJw5fRHB7RhO5CdDPscsjlLH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6bKLryc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6bKLryc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9A1C4CEE4;
	Mon,  3 Mar 2025 23:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741046065;
	bh=q3XLteGa9J/GCsxb8Sgpzaa8Es3Eze15Tkxv7ESRmWY=;
	h=Date:To:From:Subject:From;
	b=b6bKLrycph+zAEo5CNfFPj8Qh1sSMpR3oON195HEHQ7U+yFLp/JQw5BXcItFc4WS7
	 CL4KJTW4V1S535Hz0bOK66Lh2ow+Ql3jIXU/kn8t3/wZnFzDSOEv67z/XFQohRLKgr
	 HDwygDuH6t64fn4edJrKffeMdqOrxiWSWzWpE3GM=
Date: Mon, 03 Mar 2025 15:54:24 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch added to mm-unstable branch
Message-Id: <20250303235424.DE9A1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

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
Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
Date: Mon Mar  3 03:52:14 PM PST 2025

remove trailing semi in arch/loongarch/include/asm/pgalloc.h

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -56,7 +56,7 @@ static inline pte_t *pte_alloc_one_kerne
 }
 
 #define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch


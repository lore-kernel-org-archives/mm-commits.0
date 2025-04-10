Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CDB1A5B9B
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 22:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324428; cv=none; b=NZlX4D2jzme22fhUBXTDKDQ3dCca11bfLFLgDI4Kkkvg+eRDeLcboDmUkHepCTJpvfFEC3gyGLM/hpf7ga732XzlTCUdhqtDD3nabPD75J6S2MWvdgPW23IIpn/PWYB+ns7SWYGGP2NKLg1U3e/6Kmf+6j2krcTxacav1RPHGuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324428; c=relaxed/simple;
	bh=6LCJ0fHu5ZyZnohx8AzUkkJ5K26YZfey1XSyOdIqsi8=;
	h=Date:To:From:Subject:Message-Id; b=tkHbpj7xtDHKfVBCTo/gYHaspuVv4/2kJMwUbSvuqumY0yotHEOl/n/oMVylleAdFR6POphSvG2SbDA1CiyvzEvJs+MsRie6bx7BR4aWzJVJyebrfsOzjhBl/DELnIVhOXkwOBq/Tk50CX+a4YaN/LNsG+n+sIZO03D5fT7NCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YoZF4W/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YoZF4W/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC381C4CEDD;
	Thu, 10 Apr 2025 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744324427;
	bh=6LCJ0fHu5ZyZnohx8AzUkkJ5K26YZfey1XSyOdIqsi8=;
	h=Date:To:From:Subject:From;
	b=YoZF4W/iSIX+S3pPTuo/EQcX/QrQQSjAOPv9Ca6+B6EZjWGMtUnG0z/cSIE2ei/sb
	 FTbQIaoZyJPkUrfxUYxztifI7RBAu368p0rnAKbSq3F2GdfCw7annDgZPz/ZQL8RkL
	 tGWsYQ6RNcxTst+ovbxHFiBwqKZiT1Iou6ImAxUE=
Date: Thu, 10 Apr 2025 15:33:46 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch removed from -mm tree
Message-Id: <20250410223347.BC381C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow detection of wrong arch_enter_lazy_mmu_mode() context
has been removed from the -mm tree.  Its filename was
     mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: allow detection of wrong arch_enter_lazy_mmu_mode() context
Date: Tue, 8 Apr 2025 18:48:31 +0200

The lazy MMU batching may be only be entered and left under the protection
of the page table locks for all page tables which may be modified.  Yet,
there were cases arch_enter_lazy_mmu_mode() was called without the locks
taken, e.g.  commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
lazy mmu mode").

Make default arch_enter|leave|flush_lazy_mmu_mode() callbacks complain at
least in case the preemption is enabled to detect wrong contexts.

Most platforms do not implement the callbacks, so to aovid a performance
impact allow the complaint when CONFIG_DEBUG_VM option is enabled only.

Link: https://lkml.kernel.org/r/18bf936f63e0d1e53d8291a3bc2ee2c577876d9c.1744129955.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context
+++ a/include/linux/pgtable.h
@@ -232,9 +232,18 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void)
+{
+	VM_WARN_ON(preemptible());
+}
+static inline void arch_leave_lazy_mmu_mode(void)
+{
+	VM_WARN_ON(preemptible());
+}
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	VM_WARN_ON(preemptible());
+}
 #endif
 
 #ifndef pte_batch_hint
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

kasan-avoid-sleepable-page-allocation-from-atomic-context.patch
mm-cleanup-apply_to_pte_range-routine.patch
mm-protect-kernel-pgtables-in-apply_to_pte_range.patch


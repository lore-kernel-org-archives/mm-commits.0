Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F11423E329
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 20:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145971; cv=none; b=kURyCF6fiZ6hHx571jijfwUJwcOo90YVxiPqfnwtRnv2eV7CtlFrHHj7UL25gh1bLuBJ05bP8kMptWHqdI10kvuxQb2oqllrv9KmABLj90Fmg8swe6Ho8Q2gMGFtp1WEPmPqG7wVGWuSGYdUKGmXYX3DdmT7Rh3/qtGjmwBENJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145971; c=relaxed/simple;
	bh=5VJ0E8gy49VoHtOvP2O3FhXhv2WfkHrcqefA6vgFCZI=;
	h=Date:To:From:Subject:Message-Id; b=M7Tvu/EwioT2HVDcRbhbpjMrGJPjXSrQ20hHRQMauirM+gOC44QfiSD5hS0hAY/qGX3sZKHTd8EQBJ4HgXML/rRxysPvmkL32Awrkvpo9bXKGdfw7HkXO2F0vxtwRtE40RzbUdzPNj772ehSOcGcEFLcLzIXrdOu4IQmHXzrgL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jCXv9794; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jCXv9794"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EC0C4CEE5;
	Tue,  8 Apr 2025 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744145971;
	bh=5VJ0E8gy49VoHtOvP2O3FhXhv2WfkHrcqefA6vgFCZI=;
	h=Date:To:From:Subject:From;
	b=jCXv9794LbCveEIo2EXbORro3/416vm4mnhFprvnL+R0tyCF6wpwi6UpJLAiHSdoO
	 xeDCs0xMKRJ+cMrAiO1/IeYGyO3hCqDS1VCX5EUJGo1za2dZGixUisLnUEBSpzpZTS
	 3tExrDinySflL5TztoC2//IzLG+BeRU2qHqtQh/I=
Date: Tue, 08 Apr 2025 13:59:30 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch added to mm-new branch
Message-Id: <20250408205931.14EC0C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow detection of wrong arch_enter_lazy_mmu_mode() context
has been added to the -mm mm-new branch.  Its filename is
     mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch

This patch will later appear in the mm-new branch at
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
mm-allow-detection-of-wrong-arch_enter_lazy_mmu_mode-context.patch


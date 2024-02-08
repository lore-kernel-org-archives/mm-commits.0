Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E4767A0F;
	Thu,  8 Feb 2024 05:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369681; cv=none; b=OAz/esLt1gvjSB3UZRg/609EOCagLOVLhDTHeqxWuF2sMwHhJn8QzOxWjxp+HOgldKdVD50qJqLMAAWSeyGdKjbktjIjvjy24u/q1sgNDeLG8MS0+ItJkOpywwKioaFAMgwCLSzYo/1627fTBCpWdWue6eCIpOFST/mG4IV6hPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369681; c=relaxed/simple;
	bh=PO6p6Rdh2Zumde4Ywnq3kpj4vLqe/LXwFc+H5ARYe/8=;
	h=Date:To:From:Subject:Message-Id; b=U5wXTHw/5tXAKddTsKIzfSGcKsqUoe3exbtaVrqDF2NPnkgA35tD/KX7wXooDmkDJknnPH+G3f+wtCsfZsDk57jaqShK1+MMvfofVo28dgm4PpAr0GUtw8xuiuzgetTf3TfSSrSncP0PBG17YemAHbainw5SLmcF2UV8IcwqOSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rClVUIeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rClVUIeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E923EC433C7;
	Thu,  8 Feb 2024 05:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369681;
	bh=PO6p6Rdh2Zumde4Ywnq3kpj4vLqe/LXwFc+H5ARYe/8=;
	h=Date:To:From:Subject:From;
	b=rClVUIeK84oGwc7yR4ofRSrivS6Xe0LnNNDcyfqu6CndDLm3XmWY5jpmriGcY4REz
	 ZxhnKCcHT5F72lbYtysicNHkZXEUsIrkBuv/mycKNE/FyTR/vrLQv1rnqTnTlQDrBv
	 nkoiHgBz0cx6DMxQxbP3nWth3E4feiDM3NjV9EyE=
Date: Wed, 07 Feb 2024 21:21:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,stable@vger.kernel.org,rmk+kernel@armlinux.org.uk,peterz@infradead.org,palmer@dabbelt.com,mpe@ellerman.id.au,luto@kernel.org,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,agordeev@linux.ibm.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch removed from -mm tree
Message-Id: <20240208052120.E923EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/arm/mm: fix major fault accounting when retrying under per-VMA lock
has been removed from the -mm tree.  Its filename was
     arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: arch/arm/mm: fix major fault accounting when retrying under per-VMA lock
Date: Mon, 22 Jan 2024 22:43:05 -0800

The change [1] missed ARM architecture when fixing major fault accounting
for page fault retry under per-VMA lock.

The user-visible effects is that it restores correct major fault
accounting that was broken after [2] was merged in 6.7 kernel. The
more detailed description is in [3] and this patch simply adds the
same fix to ARM architecture which I missed in [3].

Add missing code to fix ARM architecture fault accounting.

[1] 46e714c729c8 ("arch/mm/fault: fix major fault accounting when retrying under per-VMA lock")
[2] https://lore.kernel.org/all/20231006195318.4087158-6-willy@infradead.org/
[3] https://lore.kernel.org/all/20231226214610.109282-1-surenb@google.com/

Link: https://lkml.kernel.org/r/20240123064305.2829244-1-surenb@google.com
Fixes: 12214eba1992 ("mm: handle read faults under the VMA lock")
Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mm/fault.c~arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/arm/mm/fault.c
@@ -298,6 +298,8 @@ do_page_fault(unsigned long addr, unsign
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-handle-zeropage-moves-by-uffdio_move.patch


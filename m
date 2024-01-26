Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6297475
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235446; cv=none; b=Se5kkOV4/PjUm1d0ZzpHw/RsrVyGwyLDB0adOQGN87zhDjnf/w396ZG9l7zdk6to2l6huPfGsYaRunxRVtMcBV7myQrkriD3Ch14f2LCd/UGaBF9GApAFYR6MVwmEqiuZgqNGvxqHuep9D7GkXQD7JVprDxcWRPr2yqAGsJUquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235446; c=relaxed/simple;
	bh=haEO2EPc2jfMvbkwYoQgtWmfENM5GeEY5j08CRsr9Vo=;
	h=Date:To:From:Subject:Message-Id; b=eYEsSHIjmNz9ilJBPh7ZgFolSfCslWIFhD/350LcvuPenVJIv9J6hvkT7aDIKXiwlFYCAsr+WC0+/J9cpaQa4io/CylaSYg6HWFVCR+pDb25kEWhKOzQ383xVxG/zMqDS15Z6jibR0BAm3Dtic+l/XbzVpyUwGZwV0FqoRyJifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fbHbCwgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fbHbCwgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3535DC433F1;
	Fri, 26 Jan 2024 02:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235446;
	bh=haEO2EPc2jfMvbkwYoQgtWmfENM5GeEY5j08CRsr9Vo=;
	h=Date:To:From:Subject:From;
	b=fbHbCwgujJMJjipLVD+I4QFiRuDHyAZKmYeHNNtKyKM2dv9NLzDvrF4GUBxRoZs56
	 hCOrQV015kxvVmirz7hou3xrCYwcJCsfkXQUiMMAWMQj8XsgS7o8MRw8lxgDQjd8Hu
	 q7GtIcrz4okRiAXe285AGFArVgAX7G4t2BxWggCA=
Date: Thu, 25 Jan 2024 18:17:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,rmk+kernel@armlinux.org.uk,peterz@infradead.org,palmer@dabbelt.com,mpe@ellerman.id.au,luto@kernel.org,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,agordeev@linux.ibm.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20240126021726.3535DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/arm/mm: fix major fault accounting when retrying under per-VMA lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: arch/arm/mm: fix major fault accounting when retrying under per-VMA lock
Date: Mon, 22 Jan 2024 22:43:05 -0800

The change [1] missed ARM architecture when fixing major fault accounting
for page fault retry under per-VMA lock.  Add missing code to fix ARM
architecture fault accounting.

[1] 46e714c729c8 ("arch/mm/fault: fix major fault accounting when retrying under per-VMA lock")

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

arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch


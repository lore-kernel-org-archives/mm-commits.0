Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098748C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600523; cv=none; b=cPk/J5dIdYQGIPL1+PQvNtlWx2C1FLTDf02GWIAFBkKiVOHWvrv7q0K7ac4hOSq7GEl05kI39EnuVSeaH1+F5N1op07Otf5+bijYE2GmrNeNSkXXKHSX3eSV9IcCBy4rdtiNkFxzDjxselEjQ3W2bBgFrKxe/vxd+zFMJwQdwTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600523; c=relaxed/simple;
	bh=5BNef++zIRh0La2dsmcl59EFz/X0F4j8J9ZFfarNT3w=;
	h=Date:To:From:Subject:Message-Id; b=OyeEjqxTYK629c9qpZ600IlN9spXzmlXj2DorcoZbFbGAq7fx/9ap7LFWKSPJV183oFhejsqeWDlA6jXHuI0dkiHxgrZfRXg9gD1oV3Nky0/RI2/RwUdzuX9QOam4PluKPQCuBulKkmu2Eqk/bO/A/hLo8o0AJJKxPES099M2jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1a/Ap6ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1a/Ap6ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FCBC433C7;
	Tue,  5 Mar 2024 01:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600522;
	bh=5BNef++zIRh0La2dsmcl59EFz/X0F4j8J9ZFfarNT3w=;
	h=Date:To:From:Subject:From;
	b=1a/Ap6apCNn/dnXNNVyUwNLxqhJFFPwBs++TuqGuZmx+q5KAcz2tT+aag8YCOAIQw
	 gtD9BtHBLDJOuoG4eofIS9h3ec7MTqaBwqswY//wQyx9kaEF/u+swB5srqCocgbeXB
	 CxjFxx+ZYYJ7+p1zH2/aIRAu8pf+JmEwjk5kl0qQ=
Date: Mon, 04 Mar 2024 17:02:02 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch removed from -mm tree
Message-Id: <20240305010202.83FCBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: always pass NULL as the first argument of switch_mm_irqs_off()
has been removed from the -mm tree.  Its filename was
     x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: x86/mm: always pass NULL as the first argument of switch_mm_irqs_off()
Date: Thu, 22 Feb 2024 19:09:11 +0000

The first argument of switch_mm_irqs_off() is unused by the x86
implementation.  Make sure that x86 code never passes a non-NULL value to
make this clear.  Update the only non violating caller, switch_mm().

Link: https://lkml.kernel.org/r/20240222190911.1903054-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/tlb.c~x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off
+++ a/arch/x86/mm/tlb.c
@@ -327,7 +327,7 @@ void switch_mm(struct mm_struct *prev, s
 	unsigned long flags;
 
 	local_irq_save(flags);
-	switch_mm_irqs_off(prev, next, tsk);
+	switch_mm_irqs_off(NULL, next, tsk);
 	local_irq_restore(flags);
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E924414
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708634428; cv=none; b=bqW9zK3vWGPPRd1PvejRUcFumldLOFsveZJ1Ou8NLtD492ir+AY2WrAk8Z42RquPKD1XrNN+ighau14I1RIc40yN3R9gsyKRyEWOF4jo9x12r33YT63bX9OIF9BOPWUR/LLyPKNIINYoXSYvtg/Xyp+Lz4GG49AWFX6d42ePPDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708634428; c=relaxed/simple;
	bh=LvV0m40KbOItk/2SE7cbojmknzkyHiAj0pxf5SnMfrs=;
	h=Date:To:From:Subject:Message-Id; b=m2Av3Q5KQICDnb2MZBzqcSQDibAm1Ra6vydFKf7ysQi06nivn/toe2038uV8IddywPcdR7OhYCP2+r4WyFlBXggPdXgFOuH9LmeyBQxvbtGGCWaMVYBY/hyhQlTTh+97Ug+1nnnOgy3YU7OpYVxJGeD4EW6eUoNgn71crSHpgpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=igiyNCa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="igiyNCa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85210C433C7;
	Thu, 22 Feb 2024 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708634427;
	bh=LvV0m40KbOItk/2SE7cbojmknzkyHiAj0pxf5SnMfrs=;
	h=Date:To:From:Subject:From;
	b=igiyNCa38yDdzuGede//4OGInHIzVL6NvLhKKIGxplA9HsWGrpyUawfNnRauDD371
	 robYfpnmqFk9Ogwig6gbwKNRnbNCZAmGPsMqjK3gWkgrADRz0oDbwIxEX6mCVsZdYB
	 IfmiV4jReNWADaM2VYmFWlhKCez0T5TqeHFJtkSg=
Date: Thu, 22 Feb 2024 12:40:26 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch added to mm-unstable branch
Message-Id: <20240222204027.85210C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: always pass NULL as the first argument of switch_mm_irqs_off()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: x86/mm: always pass NULL as the first argument of switch_mm_irqs_off()
Date: Thu, 22 Feb 2024 19:09:11 +0000

The first argument of switch_mm_irqs_off() is unused by the x86
implementation.  Make sure that x86 code never passes a non-NULL value to
make this clear.  Update the only non violating caller, switch_mm().

Link: https://lkml.kernel.org/r/20240222190911.1903054-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
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

x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch
x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333B34D3B1
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762041286; cv=none; b=hfcGTmw22WfM/IJeY8TvuSmXWXUzrksqFWIDCeu7Sss1IQSoJ1Nrmi7kQwdMptgcRavb5l2RtaMwI+NVNahHDQMlRGasvgzM6YEyP9bckPFMawA11yCaG5kwCkAmaC7VRz6xA1V84XngzmWNfAC9Ufh3aNwLfs7j0GtBMs3sFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762041286; c=relaxed/simple;
	bh=HanQ8BhajQly5U6UJ6ZY1OMeCsH+Vm97dBubXMoRK8o=;
	h=Date:To:From:Subject:Message-Id; b=NQ6N7WTl2BcrlnJIQ7opZildYNkMJs1/ovhJ8t94UvFZdWngZZuk/glp+4zXaIGKlO1rSB5iHIeQIrsaSDvd23igILDUaxQNcgP1kcHlZF98rEbtZkAcGPCUOXmfymDs6K/DqU2CJ9aaaVuZoWLJcy9wDCWC1tXcQQGhB92J2R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hTLWrD77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hTLWrD77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D660C4CEF1;
	Sat,  1 Nov 2025 23:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762041286;
	bh=HanQ8BhajQly5U6UJ6ZY1OMeCsH+Vm97dBubXMoRK8o=;
	h=Date:To:From:Subject:From;
	b=hTLWrD777i3iVxLoJTxuxb5OKZ12nqv1w01QuLnOLs0UIM9srYinXC68aifNOsBNF
	 p/CQWWaVsmuROmDjbaf3fo1r/ElrCi6GiQop7MTDECHlCk0l7Xk3NyYMYrxFVB1YkO
	 +zMAN+2FMGKNHZiCO7w79/44ibkC/M2e2GgTMWRg=
Date: Sat, 01 Nov 2025 16:54:45 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,david.laight.linux@gmail.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251101235446.3D660C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix
Date: Sat Nov  1 04:54:04 PM PDT 2025

fix the fix

Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/div64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/div64.h~lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix
+++ a/arch/x86/include/asm/div64.h
@@ -90,7 +90,7 @@ static inline u64 mul_u64_add_u64_div_u6
 
 	asm ("mulq %[mul]" : "+a" (rax), "=d" (rdx) : [mul] "rm" (mul));
 
-	if (!statically_true(add))
+	if (!statically_true(!add))
 		asm ("addq %[add], %[lo]; adcq $0, %[hi]" :
 			[lo] "+r" (rax), [hi] "+r" (rdx) : [add] "irm" (add));
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix.patch


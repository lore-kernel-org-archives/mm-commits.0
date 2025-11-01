Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63323B615
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 02:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761963126; cv=none; b=VrTjsudvD/Wdg4FetBSLMvglxVasTfHYALdPaIc/hmU5pK598SK7YOIaSFwp+CcRR4vkI+YPviwR+KK5p4056+XnBjXn0m1qo3s9YsVEvuYgkGrI40J3NMLahfZ2KUs+oPFX2eXvucCQhPJyBrFc6haf+baXSxDj2+RdajOhLCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761963126; c=relaxed/simple;
	bh=qCRIry4zzg0Vk17Ou28SYCkmHJbFfHO1QVLu1pkT+mw=;
	h=Date:To:From:Subject:Message-Id; b=ahyL/rd1tyjvuBwJalKVk7QesIfS5EIldGvgYB6sREjSm+YCnVUPW00i1AmGhOipyNj8ZquB95EmCxNs9WY/moMDGJuMDEORzF9fNJ037XG4G5dCE+1uUyb/qmxa5yJ0/goRLwJ+bFcEUNBQ1VV+2Ix5DXYo9cvbLa3GNAPJdyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNJDnBju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNJDnBju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A89C4CEE7;
	Sat,  1 Nov 2025 02:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761963126;
	bh=qCRIry4zzg0Vk17Ou28SYCkmHJbFfHO1QVLu1pkT+mw=;
	h=Date:To:From:Subject:From;
	b=SNJDnBju0Ugj8k+Oofwxk2bpzeJixvkvIxKHl5gF/qT+kGBNf7ICKnFEglI7GMQjY
	 m/q8zOXmYu8DsLrfVBvQJlrFijdwySY9JhrjbAXgNNZZ/Wa8rF8Vr11gusT6fKQX+q
	 A9tBan++tX1vZ5995h6UIdlk5twjYf64oQ1xdYlA=
Date: Fri, 31 Oct 2025 19:12:05 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,david.laight.linux@gmail.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251101021205.F0A89C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch

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
Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix
Date: Fri Oct 31 07:10:15 PM PDT 2025

fix mul_u64_add_u64_div_u64() test, per David

Link: https://lkml.kernel.org/r/20251031205917.56763269@pumpkin
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

--- a/arch/x86/include/asm/div64.h~lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix
+++ a/arch/x86/include/asm/div64.h
@@ -90,7 +90,7 @@ static inline u64 mul_u64_add_u64_div_u6
 
 	asm ("mulq %[mul]" : "+a" (rax), "=d" (rdx) : [mul] "rm" (mul));
 
-	if (statically_true(add))
+	if (!statically_true(add))
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


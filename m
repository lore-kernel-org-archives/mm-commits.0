Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A375809
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338673; cv=none; b=TrCWhnWAekd1EAttNi+QCTQCK7u6p+KNM2J0vQrU1TI541Y8o2xAqLFEuRGkSxZcHjB8ExlT1VJqZ2huImXgnVrjjf+RpR/HPU3a9VLL8awHeKs0rlPqY/mhGakUPbyTv4RFX6Prs5A9mchVGbwjLPrd5/25R0GAILIxerQmUvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338673; c=relaxed/simple;
	bh=dPP7gnysayjkFeZ8ycDf79C0fQzvy8imuomi9X0acw4=;
	h=Date:To:From:Subject:Message-Id; b=nNC3sd9jKPUYec+AYKrtFhVLScHivIJSr1zT6RtE94VOoeIAx4JgnejN3PKiDKuBvViHNv/AKCpL/Y7KDeVErdtURgZnszu2sMRtgNCU5fdq9XdRS0QMDbtehBga+ThpQIclA2njhKYXG8inQApQc+T7lyNR2JhHJnadh0igusg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCYK6UG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCYK6UG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBA01F0089C;
	Wed,  7 Oct 2026 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338671;
	bh=UTRfiAMBfhmmAALNtyjBkGRXxUMYyjVu341CajVMr0Y=;
	h=Date:To:From:Subject;
	b=oCYK6UG0hEKkxRbq/Zq5gflOtSKCSwl72vHgAEtfJa5tadU3zbL/YQAsCloCESPTY
	 MwLR699BP0P6PsdMAcLBiq+qQTA6CX3pZnA2Naok0iYVZA/shupO9PSKW5W1gQ+ru3
	 PzwNfmSE1jO4w1/mftRtu9QrpeIWN5EEHWd3dRhw=
Date: Tue, 06 Oct 2026 19:04:31 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,pmladek@suse.com,include@grrlz.net,hca@linux.ibm.com,gor@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,meted@linux.ibm.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-implement-arch_do_panic.patch removed from -mm tree
Message-Id: <20261007020431.CFBA01F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: implement arch_do_panic
has been removed from the -mm tree.  Its filename was
     s390-implement-arch_do_panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mete Durlu <meted@linux.ibm.com>
Subject: s390: implement arch_do_panic
Date: Mon, 31 Aug 2026 11:57:16 +0200

Implement s390 specific arch_do_panic() instead of using s390 specific
ifdef sections in vpanic() code.  disabled_wait() is now called after "end
Kernel panic" marker.  No functional changes.

Link: https://lore.kernel.org/20260831-arch_do_panic-v6-2-a1e170a9e7fd@linux.ibm.com
Signed-off-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
---

 arch/s390/kernel/traps.c |    7 +++++++
 kernel/panic.c           |    3 ---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/traps.c~s390-implement-arch_do_panic
+++ a/arch/s390/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/entry-common.h>
 #include <linux/kmsan.h>
 #include <linux/bug.h>
+#include <linux/panic.h>
 #include <asm/entry-percpu.h>
 #include <asm/asm-extable.h>
 #include <asm/irqflags.h>
@@ -33,6 +34,7 @@
 #include <asm/vtime.h>
 #include <asm/fpu.h>
 #include <asm/fault.h>
+#include <asm/processor.h>
 #include "entry.h"
 
 struct pgm_stat {
@@ -283,6 +285,11 @@ static void monitor_event_exception(stru
 	}
 }
 
+void arch_do_panic(void)
+{
+	disabled_wait();
+}
+
 void kernel_stack_invalid(struct pt_regs *regs)
 {
 	/*
--- a/kernel/panic.c~s390-implement-arch_do_panic
+++ a/kernel/panic.c
@@ -753,9 +753,6 @@ void vpanic(const char *fmt, va_list arg
 			 "twice on console to return to the boot prom\n");
 	}
 #endif
-#if defined(CONFIG_S390)
-	disabled_wait();
-#endif
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
 	arch_do_panic();
_

Patches currently in -mm which might be from meted@linux.ibm.com are



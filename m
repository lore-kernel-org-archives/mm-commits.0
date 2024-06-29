Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEC7125A9
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628279; cv=none; b=KW0KkqH2jHCsHVxNv1DwzcImKKmpnqu8/iwbrsULD/x1wM7OwnxHl60MhozMYKyDhoHhSSR+CMCSjbBWhWsWhPoc/jAfJ89OEGzK3nwBiZ5XVUKC2fEMM+J9NM2r9fWsVV6tnM21GgTkGAArcanBfr0xpx8vyBRerCvjENNnHJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628279; c=relaxed/simple;
	bh=2Q7SaFL6hluFjHzcNM1O4hp5bV39GrsNmMaS0AFizGI=;
	h=Date:To:From:Subject:Message-Id; b=c7B+pLaghkMgy59W8Nh8sV1dgva3d1nWmR1iS3gyM6FQG7QnOgU690Y5PYlBzv7uuK66VPMbP15u1ShxYQIo6c2bRZcLpZrvxazmgRE75yvyfMysiUctgVEXuZKWWLGZmyskobdpBosHrPqaHbV8zyisuy5bzdoml0yDMPdmQl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RRBzHHKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RRBzHHKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ECAC116B1;
	Sat, 29 Jun 2024 02:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628279;
	bh=2Q7SaFL6hluFjHzcNM1O4hp5bV39GrsNmMaS0AFizGI=;
	h=Date:To:From:Subject:From;
	b=RRBzHHKCEW9DLRQRjlFKTdXEpENftkKqZ1eKcW+zBgzcVo7+k1Dln6MY9z8vmAKqX
	 RCsB3T9eOL5AXl3+KFOkYU3hcfSOlkQTMnNoFbD+MvvbmzRMwqVuYDfiMUy8pe+oeu
	 9x+9vf9MweOMTMqcAYCUpcrbzF0aC8CbBdSkKkEg=
Date: Fri, 28 Jun 2024 19:31:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-traps-unpoison-the-kernel_stack_overflows-pt_regs.patch removed from -mm tree
Message-Id: <20240629023119.84ECAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/traps: unpoison the kernel_stack_overflow()'s pt_regs
has been removed from the -mm tree.  Its filename was
     s390-traps-unpoison-the-kernel_stack_overflows-pt_regs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/traps: unpoison the kernel_stack_overflow()'s pt_regs
Date: Fri, 21 Jun 2024 13:35:17 +0200

This is normally done by the generic entry code, but the
kernel_stack_overflow() flow bypasses it.

Link: https://lkml.kernel.org/r/20240621113706.315500-34-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/s390/kernel/traps.c~s390-traps-unpoison-the-kernel_stack_overflows-pt_regs
+++ a/arch/s390/kernel/traps.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/cpu.h>
 #include <linux/entry-common.h>
+#include <linux/kmsan.h>
 #include <asm/asm-extable.h>
 #include <asm/vtime.h>
 #include <asm/fpu.h>
@@ -262,6 +263,11 @@ static void monitor_event_exception(stru
 
 void kernel_stack_overflow(struct pt_regs *regs)
 {
+	/*
+	 * Normally regs are unpoisoned by the generic entry code, but
+	 * kernel_stack_overflow() is a rare case that is called bypassing it.
+	 */
+	kmsan_unpoison_entry_regs(regs);
 	bust_spinlocks(1);
 	printk("Kernel stack overflow.\n");
 	show_regs(regs);
_

Patches currently in -mm which might be from iii@linux.ibm.com are



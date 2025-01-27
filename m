Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3618E756
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010758; cv=none; b=JOMb0PDeg2U29WzEbVNtmqFy3+AE8vCq91c5bZCfe9YE+6o6sn+F3slyAZr58LIFtIqOv1KjU3siQTWI55ph5N9cBSqSsUt8XUsnauRLjFkDMQslA/5CUGbHLSxPA1r4jO83a4Vo57beC9hUNhxFtKklLt1t+Jt4N++pfVns16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010758; c=relaxed/simple;
	bh=3QzTp4CZxxQy/KOp6BB1Z85eJPM/s7vwV+6O66jp2+o=;
	h=Date:To:From:Subject:Message-Id; b=Dp/CcCOah/zyVDv7IMKeKj6UuvyJyrGI4r8Q6Wl850FR0Bn0kydQBqVu2dlMdc+j09d8XtFMrFh93GpkRu58aPtPV+dHwbdmgRV7EjdqERMPeSSnb9SZ8PCBWFV5m/o9yZQ1VItR+MSZyJZWxUQ5iRCSpyxWXx+rxQItSkLPcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBMGMSJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBMGMSJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37326C4CED2;
	Mon, 27 Jan 2025 20:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010758;
	bh=3QzTp4CZxxQy/KOp6BB1Z85eJPM/s7vwV+6O66jp2+o=;
	h=Date:To:From:Subject:From;
	b=fBMGMSJJ23aieN6iTqKGQkndHZJZdTyvdkOecvc9T7mkYzr/XQvg5rFKg4Ue5P5Iw
	 XTCr4AbIJFtZYNKxqoOtQ1Aho/KfZmRhjAF20lm2ofBTBA58lEW9DcdXuRplcr0Eia
	 ppvFFAB30jJcbWkeRCHMQWsWSzZMUDSgcy+UD/mQ=
Date: Mon, 27 Jan 2025 12:45:57 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch added to mm-unstable branch
Message-Id: <20250127204558.37326C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: use TYPEOF_UNQUAL() in *_cpu_ptr() accessors
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: use TYPEOF_UNQUAL() in *_cpu_ptr() accessors
Date: Mon, 27 Jan 2025 17:05:08 +0100

Use TYPEOF_UNQUAL() macro to declare the return type of *_cpu_ptr()
accessors in the generic named address space to avoid access to data from
pointer to non-enclosed address space type of errors.

Link: https://lkml.kernel.org/r/20250127160709.80604-5-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/percpu.h |    8 ++++++--
 include/linux/percpu-defs.h   |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/percpu.h~percpu-use-typeof_unqual-in-_cpu_ptr-accessors
+++ a/arch/x86/include/asm/percpu.h
@@ -73,10 +73,14 @@
 	unsigned long tcp_ptr__ = raw_cpu_read_long(this_cpu_off);	\
 									\
 	tcp_ptr__ += (__force unsigned long)(_ptr);			\
-	(typeof(*(_ptr)) __kernel __force *)tcp_ptr__;			\
+	(TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;		\
 })
 #else
-#define arch_raw_cpu_ptr(_ptr) ({ BUILD_BUG(); (typeof(_ptr))0; })
+#define arch_raw_cpu_ptr(_ptr)						\
+({									\
+	BUILD_BUG();							\
+	(TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)0;			\
+})
 #endif
 
 #define PER_CPU_VAR(var)	%__percpu_seg:(var)__percpu_rel
--- a/include/linux/percpu-defs.h~percpu-use-typeof_unqual-in-_cpu_ptr-accessors
+++ a/include/linux/percpu-defs.h
@@ -221,7 +221,7 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p))
+	(TYPEOF_UNQUAL(*(__p)) __force __kernel *)((__force unsigned long)(__p))
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch


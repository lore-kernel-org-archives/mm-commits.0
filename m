Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AEF748D
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 03:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734061801; cv=none; b=WwdNdjoHQ0v5rw580YtalGmsVPOadsq0v0kmE9HilnkTxgwMXLc/uKd+SFV1/pLjS/QciOHBmRLAxQSlg63gXSkZNRco8HJReXJoaKwZAsDrzejscQBBFWXAAS9Qfx/JpjCUVxbBJRfZ+OAT3FS8ZO+9dxvFzJQ7dFrde/Yq/Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734061801; c=relaxed/simple;
	bh=eMTiL9hzl/knEQmNjl2ldA/nBO3x+SNY2R7ainRDHyw=;
	h=Date:To:From:Subject:Message-Id; b=V1jnoHBTQF7RNDZ9id/GURgV4aXOAA5w1yVI/2RoSRmYQaVD2FsbO+MNjwG4Sgcd6yQJxJQ/aX5DCVH7x2GYkw7U5BEIpi1qX4TwwOvtJGhI/nuSWJXy/0p+7IHPtEyqew8jaS3damgB+K5xtKS0ge47GktK/sTtoh77HN4cF1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mg1Zf2ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mg1Zf2ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD70FC4CED2;
	Fri, 13 Dec 2024 03:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734061800;
	bh=eMTiL9hzl/knEQmNjl2ldA/nBO3x+SNY2R7ainRDHyw=;
	h=Date:To:From:Subject:From;
	b=Mg1Zf2urQHsvFeuRkIJLxuXGeOyB5BfvhbvHNaOOA91SuqcV3PWr+hI1WKjN0k5MP
	 DhTPC321lqWsOYxtJq8GIfY2jM8owits/P1IrO255Y97FGi2s8HOVStrMi9nXKaMb0
	 DT79vABEPLGGGxFe80yiIpCC/q4kZYJf2jR4Q8F4=
Date: Thu, 12 Dec 2024 19:50:00 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch added to mm-unstable branch
Message-Id: <20241213035000.AD70FC4CED2@smtp.kernel.org>
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
Date: Sun, 8 Dec 2024 21:45:19 +0100

Use TYPEOF_UNQUAL() macro to declare the return type of *_cpu_ptr()
accessors in the generic named address space to avoid access to data from
pointer to non-enclosed address space type of errors.

Link: https://lkml.kernel.org/r/20241208204708.3742696-5-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
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
@@ -223,7 +223,7 @@ do {									\
 #define PERCPU_PTR(__p)							\
 ({									\
 	unsigned long __pcpu_ptr = (__force unsigned long)(__p);	\
-	(typeof(*(__p)) __force __kernel *)(__pcpu_ptr);		\
+	(TYPEOF_UNQUAL(*(__p)) __force __kernel *)(__pcpu_ptr);		\
 })
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from ubizjak@gmail.com are

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch


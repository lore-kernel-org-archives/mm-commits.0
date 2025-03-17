Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92727A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188164; cv=none; b=G7JhO0B6i+h1i7V0oSb2bZjTg/qUneDnnMwmO95xKBoYyLZzGJABXIZUpwQIPfLz4h6nsSTIC8nifdOTD22WX/RHLv+XsGWcNYvrlGkd4rviuQOmNNTI53tAah2c6SZx6UsAm2TaU8LG83BOQDpXzTtMardemPuTWR4ief22QvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188164; c=relaxed/simple;
	bh=je9uXq2jgDPFl4sbHt7w0LjwOZ0esGJi3O14nXH25+U=;
	h=Date:To:From:Subject:Message-Id; b=kYeGULP4HpzeEX/8bp1cjph2KVq/F5UkdG5q74yT9M/fDuO4fwI9pNAnbj7G3Y4rWNwAR/RxL/wq6TTo+z1xjmV5MoU//uQ6zla7kuEYWBwy/uGft61KU52Kucm0lWbaWY7jNB/JJZ5QtF2o5BVRn+LSzED8+OaMQYLhKYDOtfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PFYFgWtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PFYFgWtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1059AC4CEEC;
	Mon, 17 Mar 2025 05:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188164;
	bh=je9uXq2jgDPFl4sbHt7w0LjwOZ0esGJi3O14nXH25+U=;
	h=Date:To:From:Subject:From;
	b=PFYFgWtfxtt7bm1kGmhphQDo/gsJ1Q8z1glUaL6Zcd7/8bwQDTST9/K67+90lfBhO
	 msqbNAJqR3VuwaOFvzcN1jNm//dgIOw+3lxWpCHdM3jGGMbNnG7GkGKdPapMdV/Cdd
	 QzA+paniyntWesmjjmjoxGsiJjhS6asjHj9mJAx4=
Date: Sun, 16 Mar 2025 22:09:23 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch removed from -mm tree
Message-Id: <20250317050924.1059AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: use TYPEOF_UNQUAL() in *_cpu_ptr() accessors
has been removed from the -mm tree.  Its filename was
     percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



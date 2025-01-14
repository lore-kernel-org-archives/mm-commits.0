Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A59623D3E8
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837077; cv=none; b=RufZmizuAlwBBVGFnkoENzwWt0FlutkZj+LGg5VAToTw9YdD3I1WDwvwOv8acjFBeZotwUbo9nUsrqPJ1IUuj1noAnki0WwZbQ861+OdgqxmauOFi2kKSPkqPGhWyppolfQY8cpjihPV5lxY9+qk0p1sTwGRmnQpDw8ay6O0rV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837077; c=relaxed/simple;
	bh=E4BwRHKhJqG7rjCD61gl5Sz2Hdp6SpBpW6YAg27nYE4=;
	h=Date:To:From:Subject:Message-Id; b=eTdl1UNKXBkNNTyd9bm1Bj1alf7G0N+tlEMSPZt1qV7uviof1wght+BCV6Lh6pRGF6YYIM/5cR8fjyU0+zRjaQeAMqedvSdNtdKZxci5Wur51o6oFtSY1YGVx0dZqpjN0mrcu9lv3cBH8gQV1oaGIrjQ7g8AZsBMhYjTMaklsOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d9NW4uef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d9NW4uef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E152C4CEDD;
	Tue, 14 Jan 2025 06:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837077;
	bh=E4BwRHKhJqG7rjCD61gl5Sz2Hdp6SpBpW6YAg27nYE4=;
	h=Date:To:From:Subject:From;
	b=d9NW4uefYmp8hn2k8S5TJV3FzlMDHupJFIa06zi8NT0J8jk2eK1HPVdkkGru3RmmB
	 iI3KavosATvsWbrMtqM6bqRjpQVx1Gp2RIgYXmrER0GIADRRXH8CFlKPxpFHrmnfTa
	 +YmFfFJSmB2EZlNGrhn4vMJrJuIX2sC98chpxDTc=
Date: Mon, 13 Jan 2025 22:44:36 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch removed from -mm tree
Message-Id: <20250114064437.4E152C4CEDD@smtp.kernel.org>
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
@@ -221,7 +221,7 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p))
+	((TYPEOF_UNQUAL(*(__p)) __force __kernel *)(__force unsigned long)(__p))
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are



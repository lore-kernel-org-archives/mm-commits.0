Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19928A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188168; cv=none; b=bvkQQaCd/V1qT1FmzcJ3LCq2vhat1Uju7+bLQTXrtR4VSuQkgwYz6iqk/5P0Jk2V/TKLGnsLTZbvADxbjWoAcC3qQbl8GqSTjlwNkBUO2Ev2AKZTxyZfA6FJp2Azo3lniA3wzjUpnUh+V7qWetBP8dEzgEfUzy45V+OTFfIMBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188168; c=relaxed/simple;
	bh=xafF7aXVxVfhfOzM/sbca6oiq18sUyyLCdrctmnB83E=;
	h=Date:To:From:Subject:Message-Id; b=Fa/CQN+AUsWUBPzlPmYR+MozE1jqOmAPxVDTwLurmOP8JpCYWbxBDZOit8WqtPf/UQ86kc4Px+TnExxYVbR8+cNbcff/hRk7PYcnE3ami5SY9nt36apF3iA8ATq9p3CZsllDEji/vb2elYZjGCWvSO3WR8GsvLZCSgpu+nSMJXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zoagb4GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zoagb4GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BBC4CEEC;
	Mon, 17 Mar 2025 05:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188167;
	bh=xafF7aXVxVfhfOzM/sbca6oiq18sUyyLCdrctmnB83E=;
	h=Date:To:From:Subject:From;
	b=zoagb4GHa8OpKwwV80azlz7eILmgC3owEP4PCOTz1y4+AiCa4ovn8xW1FwZDlGm9R
	 jA4IGmnO2BLrE/X3m/Cvdw3Wd0+Uyf6Fc3RgQX9hjUEQ9UztkTQ9bwH1qpuj7bd3uV
	 HULfwZ/upNOHOuao3+vzmcvP9U3+PNRhoajc38l8=
Date: Sun, 16 Mar 2025 22:09:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch removed from -mm tree
Message-Id: <20250317050927.7A5BBC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu/x86: enable strict percpu checks via named AS qualifiers
has been removed from the -mm tree.  Its filename was
     percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu/x86: enable strict percpu checks via named AS qualifiers
Date: Mon, 27 Jan 2025 17:05:10 +0100

This patch declares percpu variables in __seg_gs/__seg_fs named AS and
keeps them named AS qualified until they are dereferenced with percpu
accessor.  This approach enables various compiler check for
cross-namespace variable assignments.

Link: https://lkml.kernel.org/r/20250127160709.80604-7-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
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

 arch/x86/include/asm/percpu.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/percpu.h~percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers
+++ a/arch/x86/include/asm/percpu.h
@@ -95,9 +95,18 @@
 
 #endif /* CONFIG_SMP */
 
-#define __my_cpu_type(var)	typeof(var) __percpu_seg_override
-#define __my_cpu_ptr(ptr)	(__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
-#define __my_cpu_var(var)	(*__my_cpu_ptr(&(var)))
+#if defined(CONFIG_USE_X86_SEG_SUPPORT) && defined(USE_TYPEOF_UNQUAL)
+# define __my_cpu_type(var)	typeof(var)
+# define __my_cpu_ptr(ptr)	(ptr)
+# define __my_cpu_var(var)	(var)
+
+# define __percpu_qual		__percpu_seg_override
+#else
+# define __my_cpu_type(var)	typeof(var) __percpu_seg_override
+# define __my_cpu_ptr(ptr)	(__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
+# define __my_cpu_var(var)	(*__my_cpu_ptr(&(var)))
+#endif
+
 #define __percpu_arg(x)		__percpu_prefix "%" #x
 #define __force_percpu_arg(x)	__force_percpu_prefix "%" #x
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are



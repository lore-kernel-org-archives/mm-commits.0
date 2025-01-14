Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2821923D3C8
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837080; cv=none; b=n9Ef8g81MN2TRAv2eH0tls3Bza5DMp/Quj5oTXuOo0coIOMfinD9nVM3RbHqCX0vJqIxScbZYRgHu1uk4KcuthqE+Eojr/XpUOVjMVEnfPzahHgafFgvNoTMwe08Qn+zW6g25TcDSmhTaRTTYH9GfsJ2jCsRlmyR1bfGHKcQBLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837080; c=relaxed/simple;
	bh=dDnVWvEjMR2X/RLKjicCO7+nwv3DwOcJY63YC248zhw=;
	h=Date:To:From:Subject:Message-Id; b=atPZSSFs+bx0S0ENUU0SNyHmzEFHEBpdrfkY2SZd33tcHApkAgmzwHC4dy9Y+QlBNk1SH50aY6UYoV78OGzOBsbg+cckluf2PMocs8WlhPbX9LaqcoZCvOM0u8VldfDa6txXfA6+pK+4K/xpU9V3pwxyjJzq3hGvbqG5wbEtits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AvYvriAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AvYvriAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0090C4CEE4;
	Tue, 14 Jan 2025 06:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837080;
	bh=dDnVWvEjMR2X/RLKjicCO7+nwv3DwOcJY63YC248zhw=;
	h=Date:To:From:Subject:From;
	b=AvYvriAt/65foDUPeRVRFR/sWic9RctjzKMYfAGEqFhDc0XW/d+xXHvEPn6S/7oTy
	 9MDZ7s+7a6c7TUdl0cVLKpCPBLzlGsK5KMezW5z6EEvQov5Wvy5eBdCph1W00Nx/6C
	 rHSpgniBWEuT6MhPtlgz4kenumOfF6ZixuHoi1Gg=
Date: Mon, 13 Jan 2025 22:44:39 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch removed from -mm tree
Message-Id: <20250114064439.F0090C4CEE4@smtp.kernel.org>
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
Date: Sun, 8 Dec 2024 21:45:21 +0100

This patch declares percpu variables in __seg_gs/__seg_fs named AS and
keeps them named AS qualified until they are dereferenced with percpu
accessor.  This approach enables various compiler check for
cross-namespace variable assignments.

Link: https://lkml.kernel.org/r/20241208204708.3742696-7-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
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

 arch/x86/include/asm/percpu.h |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/percpu.h~percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers
+++ a/arch/x86/include/asm/percpu.h
@@ -95,9 +95,23 @@
 
 #endif /* CONFIG_SMP */
 
-#define __my_cpu_type(var)	typeof(var) __percpu_seg_override
-#define __my_cpu_ptr(ptr)	(__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
-#define __my_cpu_var(var)	(*__my_cpu_ptr(&(var)))
+/*
+ * XXX: Remove test for __CHECKER__ once
+ * sparse learns about __typeof_unqual__.
+ */
+#if defined(CONFIG_USE_X86_SEG_SUPPORT) && \
+    defined(CONFIG_CC_HAS_TYPEOF_UNQUAL) && !defined(__CHECKER__)
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



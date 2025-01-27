Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E271118E756
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010764; cv=none; b=kQD8a61oKQUQkuV5gAfR5asf9lMaxmUb8470TNx0k2DYDyAQfYoFmILDR5vyf72pkWe5OSsQ97uDTeixGPlGHlqIiQhsMirtmQfFbOUJSes25qedwpbzJFySiAQwRI41NLxu9laW9qpFLvO7dkmZNcptEevapdZbBgnitdQZGYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010764; c=relaxed/simple;
	bh=dmPyUuYAvl+v1A5hiJ7rkVtAz/ASIjKBt8idrJLYH5I=;
	h=Date:To:From:Subject:Message-Id; b=Vo/qJi1hVYL9jJX7qteTLfEKeeIo1zSKO7ybhTVznLuqLWeKKihkgaHTN5SiRDJubOCVzVDxhoG6FtjgsqnNxgBcPomaHrF3nNie5OdLPd2QFK9pYPLmMh0BDda7A9Bc4JiKjqca5IWj3Nnbwhzgk9bKJ93XHWs+sgvKUMMCzgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziMotxFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziMotxFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385A5C4CEE0;
	Mon, 27 Jan 2025 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010763;
	bh=dmPyUuYAvl+v1A5hiJ7rkVtAz/ASIjKBt8idrJLYH5I=;
	h=Date:To:From:Subject:From;
	b=ziMotxFuFrTvSD92KTL1DpsU9UWHab0W7U/AcbhxwY1lpuJvbSXPg3dgkuX2tDS11
	 81J4Tc6xcOCUvQUstKXt4B73gzkAgqu1CFcE+qjca8bM9nPFt5DDk/zncA2byhT63Z
	 l8UVw7Nkj/VXMNXKSmQBB0cYF/+WE0Aophj5UWlA=
Date: Mon, 27 Jan 2025 12:46:02 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch added to mm-unstable branch
Message-Id: <20250127204603.385A5C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu/x86: enable strict percpu checks via named AS qualifiers
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

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

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91588376F1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738540; cv=none; b=b9jvcUQJ0HlnFWiyUhPe4OME+yV5K7GPFN1D/0R+OFzsIQ5kfu15tXuzeD3d14auKXuDQELmh1xi1rKms+e5vuY9/gkQhhVDw/EBQCuEWvWBLmOEuzIrMxrlnebcL4cIf2GLQFzZ5t2gMoSnRV6M9GsvarRX0WfCHwPSPPnxTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738540; c=relaxed/simple;
	bh=cosIiS7/0NWcqRjnZw6xcAY1bXEsV3oCK7icKfpIGw8=;
	h=Date:To:From:Subject:Message-Id; b=JTpFTnJAjfXoELPrYhBLp65ECpGhIC+x6rWm3uJ14JccRO44bKO4Fb1PvM+pnel/1aKXUT5/WHyhu1zRqDDicH8B4RbDk5enlYOwPjmei9FpqluLGj6Jrqfj7rD5+Tfo+z+fDiPJucWsA33qc6fEbdpg/F/d+7bC1IQhGYQfq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M1lEn5Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M1lEn5Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A53C4CEC6;
	Thu, 24 Oct 2024 02:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738540;
	bh=cosIiS7/0NWcqRjnZw6xcAY1bXEsV3oCK7icKfpIGw8=;
	h=Date:To:From:Subject:From;
	b=M1lEn5SicS5FezjR9NunRSzeyOC6nZkn0D6qstG2S8kaLDYtBWDRKYWRP8uPbFN45
	 fdGq3IlchCHcBhkhMynyWuLblZQPSugcQ8ppYGZFa53yUv6n+3U4q84qhpY+aPTWOS
	 ZrOrHXo5WT631rrKLQWnctNf5NGm6cpGmuSGw9gA=
Date: Wed, 23 Oct 2024 19:55:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-introduce-percpu_ptr-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20241024025540.59A53C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: introduce PERCPU_PTR() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu-introduce-percpu_ptr-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-introduce-percpu_ptr-macro.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: introduce PERCPU_PTR() macro
Date: Mon, 21 Oct 2024 10:07:37 +0200

Introduce PERCPU_PTR() macro to cast the percpu pointer from the percpu
address space to a generic (kernel) address space.  Use it in
per_cpu_ptr() and related SHIFT_PERCPU_PTR() macros.

Also remove common knowledge from SHIFT_PERCPU_PTR() comment, "weird cast"
is just a standard way to inform sparse of a cast from the percpu address
space to a generic address space.

Link: https://lkml.kernel.org/r/20241021080856.48746-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-introduce-percpu_ptr-macro
+++ a/include/linux/percpu-defs.h
@@ -220,15 +220,17 @@ do {									\
 	(void)__vpp_verify;						\
 } while (0)
 
+#define PERCPU_PTR(__p)							\
+	(typeof(*(__p)) __force __kernel *)(__p);
+
 #ifdef CONFIG_SMP
 
 /*
- * Add an offset to a pointer but keep the pointer as-is.  Use RELOC_HIDE()
- * to prevent the compiler from making incorrect assumptions about the
- * pointer value.  The weird cast keeps both GCC and sparse happy.
+ * Add an offset to a pointer.  Use RELOC_HIDE() to prevent the compiler
+ * from making incorrect assumptions about the pointer value.
  */
 #define SHIFT_PERCPU_PTR(__p, __offset)					\
-	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
+	RELOC_HIDE(PERCPU_PTR(__p), (__offset))
 
 #define per_cpu_ptr(ptr, cpu)						\
 ({									\
@@ -258,7 +260,7 @@ do {									\
 ({									\
 	(void)(cpu);							\
 	__verify_pcpu_ptr(ptr);						\
-	(typeof(*(ptr)) __kernel __force *)(ptr);			\
+	PERCPU_PTR(ptr);						\
 })
 
 #define raw_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
_

Patches currently in -mm which might be from ubizjak@gmail.com are

perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch
percpu-merge-verify_percpu_ptr-into-its-only-user.patch
percpu-introduce-percpu_ptr-macro.patch
percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch


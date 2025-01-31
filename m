Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6171D24B34
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 00:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738283687; cv=none; b=pPsniI8e0+o7xflEn+ckxA4sQaFvMBayFcVx7BmjtLVwKbQMRZqYYNP6avJmtm4j679RQzQfZw450b8g+iW4ZedSrDEsjDH33Gh9vRRSIASLwJufP06q6aSs2KMIdBTPbMHA7BQlesqy13ybs+pGgMBnVdb5CiAlKc9qCCJrOgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738283687; c=relaxed/simple;
	bh=r84O2egzxgGd8P6nAobc/0FB9v3ts6BAfdpXNbTeje0=;
	h=Date:To:From:Subject:Message-Id; b=gm/oETF3zu4+crykP4UzKogDuu/pa457YciK7qdKO6wxmQO7Fb25Zm5nhg4Rz49jnhrg6pTMHuX+0kJUGak1AUEEOgfeNDMLbw5DuNVRHmQ7zPbOglAuZFV8c0wUsEh91HUy1vQT6TWaZPyAVIKeRrns24bkZxpoGk6ksZJ89Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sFfBcWHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sFfBcWHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF93C4CED3;
	Fri, 31 Jan 2025 00:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738283686;
	bh=r84O2egzxgGd8P6nAobc/0FB9v3ts6BAfdpXNbTeje0=;
	h=Date:To:From:Subject:From;
	b=sFfBcWHuEaHZg/9MaI4NWCpy6Fr9Tw53Ukudpdx3x2ZcuG/0HyV/IctG/6s48m3jP
	 zoKK7JWJaXt2yD4SzUyY+gtC2XgWbUYkRi8SDuA4u9Qw4G2u/ClIKXoKs3bS6+pEJz
	 icGbPw3YkUAM0BQsiZ6+uq3pEC6GDtQK1IIG6Lz4=
Date: Thu, 30 Jan 2025 16:34:46 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bchc-use-__builtin_parity-when-available.patch added to mm-nonmm-unstable branch
Message-Id: <20250131003446.BEF93C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bch.c: use __builtin_parity() when available
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bchc-use-__builtin_parity-when-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bchc-use-__builtin_parity-when-available.patch

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
Subject: lib/bch.c: use __builtin_parity() when available
Date: Wed, 29 Jan 2025 21:57:31 +0100

Compilers (GCC and clang) provide optimized __builtin_parity() function
that returns the parity of X, i.e.  the number of 1-bits in X modulo 2.

Use __builtin_parity() built-in function to optimize parity(). This
improves generated code on x86_64 from:

	movl    %edi, %edx
	shrl    %edx
	xorl    %edi, %edx
	movl    %edx, %eax
	shrl    $2, %eax
	xorl    %edx, %eax
	andl    $286331153, %eax
	imull   $286331153, %eax, %eax
	shrl    $28, %eax
	andl    $1, %eax

to an optimized:

	movl    %edi, %ecx
	shrl    $16, %ecx
	xorl    %edi, %ecx
	xorl    %eax, %eax
	xorb    %ch, %cl
	setnp   %al

Please note SETNP instruction that exercises hardware parity
calculation of x86 processors. When POPCNT instruction is
available, the generated code gets optimized even further:

	popcntl %edi, %eax
	andl    $1, %eax

Compile-tested only.

Link: https://lkml.kernel.org/r/20250129205746.10963-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/bch.c~lib-bchc-use-__builtin_parity-when-available
+++ a/lib/bch.c
@@ -313,6 +313,9 @@ static inline int deg(unsigned int poly)
 
 static inline int parity(unsigned int x)
 {
+#if __has_builtin(__builtin_parity)
+	return __builtin_parity(x);
+#else
 	/*
 	 * public domain code snippet, lifted from
 	 * http://www-graphics.stanford.edu/~seander/bithacks.html
@@ -321,6 +324,7 @@ static inline int parity(unsigned int x)
 	x ^= x >> 2;
 	x = (x & 0x11111111U) * 0x11111111U;
 	return (x >> 28) & 1;
+#endif
 }
 
 /* Galois field basic operations: multiply, divide, inverse, etc. */
_

Patches currently in -mm which might be from ubizjak@gmail.com are

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch
lib-bchc-use-__builtin_parity-when-available.patch


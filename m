Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1E0187876
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738362985; cv=none; b=Tk8t7z/l8LOjKjmJQQa11X58bqP1kIvVYrwQRrlyB9s5kF0acgeM/yr8RLNwLxkXRq2ZSvVqpdcul2Itc6SHkSx2iNDtD3MDgwcgZ+iLJUg/7g70SLqysH0mKoqwtydNHrQb8KK27k55HTHHqkEAsiumrsM6RXGk7ZYsg4Xj18o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738362985; c=relaxed/simple;
	bh=J3katI86Y7WrjmmCq6dx/ffVng04QaKqNdbjuCe8LHU=;
	h=Date:To:From:Subject:Message-Id; b=Lhk1mVeDT7QsnQlvR/8vD6X1lio41eOoWQ/64aJK2okWSeNhe42sQkVUWtpzh4WP0Fn/BBVQGj4OsSVUgj2r/+hxMGU/m3+2ndpF2g/Jy8aCw68ObABywqTog7yKs9GwJyaZG6IdIBFNIJrLlsY3kB94yNrpx6ho/vItE/jUBiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EEexI0CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEexI0CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DB1C4CED1;
	Fri, 31 Jan 2025 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738362985;
	bh=J3katI86Y7WrjmmCq6dx/ffVng04QaKqNdbjuCe8LHU=;
	h=Date:To:From:Subject:From;
	b=EEexI0CYMbBasE/95oXnqfUiAibqferRO70rOJb3qJRYUazWAjoP73AyfwZQNxaQT
	 4H9avY8FVnfVQAfK+E90vr29kD9zasn+8rDFNQ12XmhLhJJb1W5ju8B3BMw22Ygsrj
	 GLpfbAP8xr/+1GOOZeKjepCSXxJ5SsyDy/MFv9mk=
Date: Fri, 31 Jan 2025 14:36:24 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] lib-bchc-use-__builtin_parity-when-available.patch removed from -mm tree
Message-Id: <20250131223625.41DB1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bch.c: use __builtin_parity() when available
has been removed from the -mm tree.  Its filename was
     lib-bchc-use-__builtin_parity-when-available.patch

This patch was dropped because it was withdrawn

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


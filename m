Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496E21862BB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855638; cv=none; b=MqmRw42CKOEin07oXwA3LaGZrAqh7VnM+1Sa3ysqDtafHiwScX62kO/2vuh6A1jkUpMo/KICpAAAB5eRMZaXSz84w1Oj+BTmOi/ILLLW3iMyONKs+0E+kh/r3Vd6wEZrPvwnmEBqhR1EitF5sXFZ/cnsW5V1jq40kQiFG7bU2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855638; c=relaxed/simple;
	bh=cHjAqrVZYR3vlP+Vb4jI5NDIYsWmVVFHOlGsDk/nZl0=;
	h=Date:To:From:Subject:Message-Id; b=Vf7Bv1z7ji0bkJbjXRJpaLTc4w11Rnc7NAOeqCH+bsK1rc5Z+YaUSKMQ8F/JB4YOwPc+5COzmSSUvFp1UfVESYqwKJCHDqACvpBdOWZCWs5ZN7Qb/DuSM2e7ICxVRGAI+qBRG6VbdHic+oLsZwjh5mm5RnxA5tOxdFydtI0J9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=edBlhFhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="edBlhFhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E0EC4CECF;
	Wed,  6 Nov 2024 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855637;
	bh=cHjAqrVZYR3vlP+Vb4jI5NDIYsWmVVFHOlGsDk/nZl0=;
	h=Date:To:From:Subject:From;
	b=edBlhFhbaCeiU294jcy5KgsR7uLuzmtLkSVWhsW5zULxj3JRDM/NfS/5kwqkjoHpf
	 niU3ZqvWlDx5MTzI6bjqqB5k9rrYF0T2p2xcHgKYmx9sHbVJaPs2+p8DztzTjayPZP
	 7NcaToKvA/zD3+oAgFs4vkpnqGvPnfhI4h5LDdSA=
Date: Tue, 05 Nov 2024 17:13:57 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] percpu-introduce-percpu_ptr-macro.patch removed from -mm tree
Message-Id: <20241106011357.D4E0EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: introduce PERCPU_PTR() macro
has been removed from the -mm tree.  Its filename was
     percpu-introduce-percpu_ptr-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



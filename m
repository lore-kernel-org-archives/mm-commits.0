Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1B219A86
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743098994; cv=none; b=sGVVwdE6KMb0FCftSN+n8rTSeseso4AG7JteIKdSsy5cNUqxR2P9dIspQhDvTE8XGY8tJJuK4zJzVkNn7b7h0WPn0E4WzvLTQiODs5bJT0n9+Lv+YqPVdPw5Mf6kBVZ2n9fLNpkEqfrImtZITrEsmzYxHJ/3/zx7k5FWJavD2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743098994; c=relaxed/simple;
	bh=QuMG/DYbyZ4IwrEt4yeAZUU+Ndb7vJ6qztPl0RyNzVg=;
	h=Date:To:From:Subject:Message-Id; b=CNLlLr1CDPt7UL3knLcn8gq6xEghMiZCgnDXuNfFvSS+GXzfEICFYe6d2AMIkSqrvHv9ed8+Sb5NlsIWEQyNSocv+DCwNYPqQ5P1izWUgrOCTvu2TVTw+V0FawUjoRaPXGQjHcZAruzcgvQCEPqwayWY952WJA/zz8DvaXjlMj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNFOL2Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNFOL2Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B60EC4CEE5;
	Thu, 27 Mar 2025 18:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743098994;
	bh=QuMG/DYbyZ4IwrEt4yeAZUU+Ndb7vJ6qztPl0RyNzVg=;
	h=Date:To:From:Subject:From;
	b=hNFOL2FlUDpmhgwGxV/CFax3Z6anfuuMS/k1gL2m6xN2n2hn0cf+nhO3P1ZX/AFc4
	 PZ7R4yKQLbnnbGrf+ME68sferAFrZQP/ptDElG7G+BHuglxCJS1Gav88Hqr0Usnkm2
	 Wg+n63+S8VHJgaHBum3OUXMnVQl2+gzmWg0YJxQ8=
Date: Thu, 27 Mar 2025 11:09:53 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sortc-add-_nonatomic-variants-with-cond_resched.patch added to mm-nonmm-unstable branch
Message-Id: <20250327180954.2B60EC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort.c: add _nonatomic() variants with cond_resched()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: lib/sort.c: add _nonatomic() variants with cond_resched()
Date: Wed, 26 Mar 2025 11:26:06 -0400

bcachefs calls sort() during recovery to sort all keys it found in the
journal, and this may be very large - gigabytes on large machines.

This has been causing "task blocked" warnings, so needs a
cond_resched().

Link: https://lkml.kernel.org/r/20250326152606.2594920-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sort.h |   11 +++++++++
 lib/sort.c           |   46 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 5 deletions(-)

--- a/include/linux/sort.h~lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/include/linux/sort.h
@@ -13,4 +13,15 @@ void sort(void *base, size_t num, size_t
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func);
 
+/* Versions that periodically call cond_resched(): */
+
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func);
+
 #endif
--- a/lib/sort.c~lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/lib/sort.c
@@ -186,6 +186,8 @@ static size_t parent(size_t i, unsigned
 	return i / 2;
 }
 
+#include <linux/sched.h>
+
 /**
  * sort_r - sort an array of elements
  * @base: pointer to data to sort
@@ -212,10 +214,11 @@ static size_t parent(size_t i, unsigned
  * O(n*n) worst-case behavior and extra memory requirements that make
  * it less suitable for kernel use.
  */
-void sort_r(void *base, size_t num, size_t size,
-	    cmp_r_func_t cmp_func,
-	    swap_r_func_t swap_func,
-	    const void *priv)
+static void __sort_r(void *base, size_t num, size_t size,
+		     cmp_r_func_t cmp_func,
+		     swap_r_func_t swap_func,
+		     const void *priv,
+		     bool may_schedule)
 {
 	/* pre-scale counters for performance */
 	size_t n = num * size, a = (num/2) * size;
@@ -286,6 +289,9 @@ void sort_r(void *base, size_t num, size
 			b = parent(b, lsbit, size);
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
+
+		if (may_schedule)
+			cond_resched();
 	}
 
 	n -= size;
@@ -293,8 +299,25 @@ void sort_r(void *base, size_t num, size
 	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
 		do_swap(base, base + size, size, swap_func, priv);
 }
+
+void sort_r(void *base, size_t num, size_t size,
+	    cmp_r_func_t cmp_func,
+	    swap_r_func_t swap_func,
+	    const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, false);
+}
 EXPORT_SYMBOL(sort_r);
 
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, true);
+}
+EXPORT_SYMBOL(sort_r_nonatomic);
+
 void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func)
@@ -304,6 +327,19 @@ void sort(void *base, size_t num, size_t
 		.swap = swap_func,
 	};
 
-	return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, false);
 }
 EXPORT_SYMBOL(sort);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func)
+{
+	struct wrapper w = {
+		.cmp  = cmp_func,
+		.swap = swap_func,
+	};
+
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, true);
+}
+EXPORT_SYMBOL(sort_nonatomic);
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

lib-sortc-add-_nonatomic-variants-with-cond_resched.patch


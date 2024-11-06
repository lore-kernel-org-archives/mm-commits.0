Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B97B1862BB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855639; cv=none; b=o9aHoXMHNtYBxqid9BKOyNDsgvTDFEgU5O3ccTJ1n+ZDB0Ckto7S0Drup/TYrSLIQPDJ7L8SFkhBnnOpr/kTKt67yRZuJWeTGojR16cDGVzlL6iLFqd3Ea/KszWetvo5RDWFwmzfqxVMthGF+Y7sZGOTZS9/4ie4s2724fPe4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855639; c=relaxed/simple;
	bh=oKBdK8Qys/9yMlDtc1CkOpY61ZBro7njs0EfUOYn9q8=;
	h=Date:To:From:Subject:Message-Id; b=J5TePPYC9KJfgYwaFw5KJvFA0dLCAGEHOQjVFi7bWnbbKgtjlf0IYRaCOlHTeDiaqgRcB7egdomoY2uSoK3C8quDc8HQHrPFOVGKtL62Dj4Wo9yp0R6BVwmCQn0G3+tiv0XUeyywyKC10463eHOpgW+kl6CYy2+5qJhUhaIwlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXOPFyDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXOPFyDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014BDC4CECF;
	Wed,  6 Nov 2024 01:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855639;
	bh=oKBdK8Qys/9yMlDtc1CkOpY61ZBro7njs0EfUOYn9q8=;
	h=Date:To:From:Subject:From;
	b=aXOPFyDL8eA7pNfF9MtI6iPuQ9MdF6okkvtMZ2TvYsY5WWcfxs30SZnhjD1RTzKeZ
	 QC3Xgp95D5ZzuojOA4d7QhhNpnm3BSFqKWUXvkqIskMl97EtThKNRKVbUK05DiDxLJ
	 aMFJn8H7Kz2fU+ylIJsmiG5fYiEuK8rCGP13stj8=
Date: Tue, 05 Nov 2024 17:13:58 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch removed from -mm tree
Message-Id: <20241106011359.014BDC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: cast percpu pointer in PERCPU_PTR() via unsigned long
has been removed from the -mm tree.  Its filename was
     percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: cast percpu pointer in PERCPU_PTR() via unsigned long
Date: Mon, 21 Oct 2024 10:07:38 +0200

Cast pointer from percpu address space to generic (kernel) address space
in PERCPU_PTR() macro via unsigned long intermediate cast [1].  This
intermediate cast is also required to avoid build failure when GCC's
strict named address space checks for x86 targets [2] are enabled.

Found by GCC's named address space checks.

[1] https://sparse.docs.kernel.org/en/latest/annotations.html#address-space-name
[2] https://gcc.gnu.org/onlinedocs/gcc/Named-Address-Spaces.html#x86-Named-Address-Spaces

Link: https://lkml.kernel.org/r/20241021080856.48746-3-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/percpu-defs.h~percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long
+++ a/include/linux/percpu-defs.h
@@ -221,7 +221,10 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-	(typeof(*(__p)) __force __kernel *)(__p);
+({									\
+	unsigned long __pcpu_ptr = (__force unsigned long)(__p);	\
+	(typeof(*(__p)) __force __kernel *)(__pcpu_ptr);		\
+})
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are



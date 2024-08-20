Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5936B0D
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131735; cv=none; b=qeDvO952bljjFoB5yUZHzakfAzMyvAwRvAfebRe0R2FmJBphyZJm3JHFupNjhvJ1By+UtOnL6sbGpdvXmuGSx0GgfaZ3/iw69dXLZ8wkws4BDHJ6XzWYvQ19wlwLdA3hu2Gerv9Z8R0A3io6+daky8gdfEv+LdAX2AkssNA/w2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131735; c=relaxed/simple;
	bh=dA+Uq99bpXaov6CsQYf/vkTCfL3mZkS/RojEUKhWLzk=;
	h=Date:To:From:Subject:Message-Id; b=tLHtKqgH3pcS2shEOFZlNt8i7nPEy70lGXdoe/2FAfeBMi250K107SbAQ8MmV2oKDtt2ZIl692ARgyH9DFWRu9S02ewk1vzXo1pKGoUtR8KkLPXrNHXYJYBaybtwRs2pCJUbCf8rtNaP5evwvcOJoWf9XB0Orz8xNksdu3g8h7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uiEQ98Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiEQ98Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC45C4AF0B;
	Tue, 20 Aug 2024 05:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724131734;
	bh=dA+Uq99bpXaov6CsQYf/vkTCfL3mZkS/RojEUKhWLzk=;
	h=Date:To:From:Subject:From;
	b=uiEQ98TaucahP8RtkJii8+nU0rDepJHHKgv9nMsOHIttEcD7lUaoobV5sgv/bK5/5
	 f1Gsfdm5Iu/nWercc/8Pof/pP4wYkeFX8ABvDmfYw4f3dQXp/ee2skDiIxgyEVzmKU
	 UwLUeqAwNTCgDfskqg51wMOEvKRpVADVMFiH6Ykc=
Date: Mon, 19 Aug 2024 22:28:54 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch added to mm-nonmm-unstable branch
Message-Id: <20240820052854.ACC45C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch

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
Subject: mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space
Date: Sun, 18 Aug 2024 23:01:52 +0200

Use IS_ERR_PCPU() instead of IS_ERR() for pointers in the percpu address
space.  The patch also fixes following sparse warnings:

kmemleak.c:1063:39: warning: cast removes address space '__percpu' of expression
kmemleak.c:1138:37: warning: cast removes address space '__percpu' of expression

Link: https://lkml.kernel.org/r/20240818210235.33481-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space
+++ a/mm/kmemleak.c
@@ -1070,8 +1070,8 @@ void __ref kmemleak_alloc_percpu(const v
 {
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
-		create_object_percpu((unsigned long)ptr, size, 1, gfp);
+	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
+		create_object_percpu((__force unsigned long)ptr, size, 0, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 
@@ -1145,8 +1145,8 @@ void __ref kmemleak_free_percpu(const vo
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
-		delete_object_full((unsigned long)ptr, OBJECT_PERCPU);
+	if (kmemleak_free_enabled && ptr && !IS_ERR_PCPU(ptr))
+		delete_object_full((__force unsigned long)ptr, OBJECT_PERCPU);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch
errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch


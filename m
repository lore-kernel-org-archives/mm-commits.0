Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E45C47A5C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247724; cv=none; b=DJkKes2A2UrVKcPErCEGgfuH1+fLk9pVc4lxkOMbw9mL8OGe+AQLPkE/fgcByXVURWqbb/rTHiT8ua1M4U7EaH7BgnBG4ZLDLerFpLVwgQnJzzKkkojPwGh06OY0xILsALRw2RtqZpkESRPsxULQQUcS/MOrQmIsWFOxW2bsZ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247724; c=relaxed/simple;
	bh=unliyZpN9+9IuumP7ILTrvlPTkRbhgs5LMTMqORss3s=;
	h=Date:To:From:Subject:Message-Id; b=qd8ALpj77vabdrD5VVUDLp8GIJnv1UcJFrNHVvde2jGm5QkCWaLYnii7WHJKzOi91rqSIrZpI2zzS4qogifOr3tL/ZbvS15JhjmecNeki+APJcRX1MNS9wMAdbreOSGxwOcbcTFS1P43BWyqA4lignq/6tJP5Y7EQRSSDhCJHTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHLZDLaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHLZDLaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F02C4CEC2;
	Mon,  2 Sep 2024 03:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247724;
	bh=unliyZpN9+9IuumP7ILTrvlPTkRbhgs5LMTMqORss3s=;
	h=Date:To:From:Subject:From;
	b=lHLZDLaKSgcsO+jnGvqlAyPHT/woOecpv7JhSxynUideG2JKzWOuRM10q08bN/Q31
	 jH1D1wXUd0PyNNBvLGz0JihIB/ty5FRYtmXh/OPNQt8+JF/qprPmJ5UK4rnw8zqF95
	 5CfS/vRoMU9kQe9OyoyV3INdvZoBswuSeRLg+4dg=
Date: Sun, 01 Sep 2024 20:28:43 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,linmiaohe@huawei.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch removed from -mm tree
Message-Id: <20240902032844.53F02C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/z3fold: add __percpu annotation to *unbuddied pointer in struct z3fold_pool
has been removed from the -mm tree.  Its filename was
     mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/z3fold: add __percpu annotation to *unbuddied pointer in struct z3fold_pool
Date: Tue, 30 Jul 2024 14:34:17 +0200

Compiling z3fold.c results in several sparse warnings:

z3fold.c:797:21: warning: incorrect type in initializer (different address spaces)
z3fold.c:797:21:    expected void const [noderef] __percpu *__vpp_verify
z3fold.c:797:21:    got struct list_head *
z3fold.c:852:37: warning: incorrect type in initializer (different address spaces)
z3fold.c:852:37:    expected void const [noderef] __percpu *__vpp_verify
z3fold.c:852:37:    got struct list_head *
z3fold.c:924:25: warning: incorrect type in assignment (different address spaces)
z3fold.c:924:25:    expected struct list_head *unbuddied
z3fold.c:924:25:    got void [noderef] __percpu *_res
z3fold.c:930:33: warning: incorrect type in initializer (different address spaces)
z3fold.c:930:33:    expected void const [noderef] __percpu *__vpp_verify
z3fold.c:930:33:    got struct list_head *
z3fold.c:949:25: warning: incorrect type in argument 1 (different address spaces)
z3fold.c:949:25:    expected void [noderef] __percpu *__pdata
z3fold.c:949:25:    got struct list_head *unbuddied
z3fold.c:979:25: warning: incorrect type in argument 1 (different address spaces)
z3fold.c:979:25:    expected void [noderef] __percpu *__pdata
z3fold.c:979:25:    got struct list_head *unbuddied

Add __percpu annotation to *unbuddied pointer to fix these warnings.

Link: https://lkml.kernel.org/r/20240730123445.5875-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool
+++ a/mm/z3fold.c
@@ -144,7 +144,7 @@ struct z3fold_pool {
 	const char *name;
 	spinlock_t lock;
 	spinlock_t stale_lock;
-	struct list_head *unbuddied;
+	struct list_head __percpu *unbuddied;
 	struct list_head stale;
 	atomic64_t pages_nr;
 	struct kmem_cache *c_handle;
_

Patches currently in -mm which might be from ubizjak@gmail.com are

errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch
squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch


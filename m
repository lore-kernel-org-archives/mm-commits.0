Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C30513BC0C
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723671058; cv=none; b=EcUg4e2aGTf/Uwyb2keXG7qXkgGdXS3uM+1O8j2B2ibu65YcKwlge5CgcACg2DwBu1c6ag6PkjtJt/C6vqRo7OtF+MzcMIIf+9P2KRfpi4ESH2jjB6n2gvp/avMWDXXLpS5jIZvhuWNY8uhluRyQfBbDSmVF7xwoWwacA0Ne1Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723671058; c=relaxed/simple;
	bh=u7B02F29GBjNFUjWfnTr7913yn9c+eAJY8fOAuolqNs=;
	h=Date:To:From:Subject:Message-Id; b=CFUokNPFJgqxuf5DP0ku61jHDDB5KNbX6c30VUaiSHqIWIwZszbYjiNoYiDSuvEuZqwS9+huVXQZlO0LDJ7QlPf0RqNpmT76aKO56Y9yuxzn4Q235MQfZpaCogj3NcG2rQlYky+54ptCnh0VLDoslkkn146w81g4dJ9XP3rfbLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ikzj6Hox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ikzj6Hox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DE6C116B1;
	Wed, 14 Aug 2024 21:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723671057;
	bh=u7B02F29GBjNFUjWfnTr7913yn9c+eAJY8fOAuolqNs=;
	h=Date:To:From:Subject:From;
	b=ikzj6HoxVyfdjnI5GKhRS1ZZ+Zo9KcsaRjkk1QzND33oz6eqkakHvwwd94tr6aAJa
	 uuQQw7En9hqFc3RS65l+khzoJHh4aghuNfA3EPLAtZNJk++SOsoVIb9F14NgREwG0x
	 o8mBBcHCyxib8GurIsmi4uahip7cGzTRyMpbSyMw=
Date: Wed, 14 Aug 2024 14:30:56 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch added to mm-nonmm-unstable branch
Message-Id: <20240814213057.73DE6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/percpu_counter: add missing __percpu qualifier to a cast
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch

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
Subject: lib/percpu_counter: add missing __percpu qualifier to a cast
Date: Wed, 14 Aug 2024 08:44:13 +0200

Add missing __percpu qualifier to a (void *) cast to fix

percpu_counter.c:212:36: warning: cast removes address space '__percpu' of expression
percpu_counter.c:212:33: warning: incorrect type in assignment (different address spaces)
percpu_counter.c:212:33:    expected signed int [noderef] [usertype] __percpu *counters
percpu_counter.c:212:33:    got void *

sparse warnings.

Found by GCC's named address space checks.

There were no changes in the resulting object file.

Link: https://lkml.kernel.org/r/20240814064437.940162-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c~lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast
+++ a/lib/percpu_counter.c
@@ -209,7 +209,7 @@ int __percpu_counter_init_many(struct pe
 		INIT_LIST_HEAD(&fbc[i].list);
 #endif
 		fbc[i].count = amount;
-		fbc[i].counters = (void *)counters + (i * counter_size);
+		fbc[i].counters = (void __percpu *)counters + i * counter_size;
 
 		debug_percpu_counter_activate(&fbc[i]);
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-functions.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA5F1AA3E8
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378686; cv=none; b=Yk+LoEtnVZjhQebhupYw9qFlxoug64peFdOXzTMvZPyHuN2/vXODYXzmelVR7bWBBL57MXauqyx4iUywNqYMwGR6b35cUt+gZiUApv0DvH3InPdsk+p5eyI+yNTF/wCyEhLxedYLI9fetndvSqRf4d2TDr+BzuYnR8UHKsE92kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378686; c=relaxed/simple;
	bh=57YMfJGMPBBDqkTtvTw+QPelFkO0QL0R9sG90kSzmII=;
	h=Date:To:From:Subject:Message-Id; b=UUrt8lAG5chLiCFxWOqxvrkfyySY8DSpLi9ZRW6h2pZeu1Cliup1sUBiTo17AVTal5HCh5gJFD8tEHtnHKXfIfbwvXgqbvL5svnyb2fmuK7Kg/7kAIoQWUjeG/PksuvCkTDB6a8LiHeW4j5CbSq1AbFjx4mVaexso4xmFvyZ+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVZeXzyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVZeXzyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97506C32782;
	Tue, 30 Jul 2024 22:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722378685;
	bh=57YMfJGMPBBDqkTtvTw+QPelFkO0QL0R9sG90kSzmII=;
	h=Date:To:From:Subject:From;
	b=JVZeXzyUo5RUZslB6B5sWszLlastq6fH/MbsXlOOPzouTMqvH+twDGNYjxla25A5m
	 zR6kDVtPSGAsNAsapCSu7mgPMFNp06aAgSZneughveoeikbWYHEjDj4KTORt7YcijI
	 dmHPKyCA8ZwUT5Ki4lkYl5P7W4XwMkooxyLYv2F8=
Date: Tue, 30 Jul 2024 15:31:25 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,linmiaohe@huawei.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch added to mm-unstable branch
Message-Id: <20240730223125.97506C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/z3fold: add __percpu annotation to *unbuddied pointer in struct z3fold_pool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch

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
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch


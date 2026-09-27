Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EDF3A6B76
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790532250; cv=none; b=To2lNBx3/SjpI6Yb0xh1kwmBj0EBvw3OOr0itXNtal6pu9Okz5tk6hPjiC3poiDUSv8J7vrnpfjhfFiU6fwyWGJNmXDxyu++yso7Y/QcZRAQPEjHzszdudjW/gnm1x1Db335NLEvj0izmjc/2MHaoPqempP+gphS6lalNBAlJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790532250; c=relaxed/simple;
	bh=IvEvjRqDFWX61CuvkKQ2RB9P3s0O+J/9Y9Qxe/HZ4kA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=FAdIxR6fEnsK0LrRVq1Yb+ED4Vv21xugmqxrROYY+cjro1bWO3ikc0gRWLtkCBW84OYa1fD9UZunHVDERp8qB99bBCcnDD3BG6SvkZw+x6SaYzmdn+DCNbRCHBb+s1SszUTFuWdxjVwnyvzzJNn+Cyy/3CJl+RaLkI36En/q92Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1+gIxXqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1+gIxXqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA281F000FF;
	Sun, 27 Sep 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790532248;
	bh=L+RKmLiYfTpJkWgh05f6iD9CmiYu1dygz6jWZXppG/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1+gIxXqt4g4HuWKnn2k8ZEI+shrk8xmzUblcBd5zZDHaoT6vGGPrAEVpZitnR66wc
	 54KDMAbGwdXODbbzBZVXpal9rczV/BKAMk3YX0sVPZtPwZdxQa6G1LGVKicrxLNwgd
	 gnt1lnpP4ee3pXX54g2sV0A+Lr1GOMYoTb2grwHM=
Date: Sun, 27 Sep 2026 11:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 b4fc90c82982d98959af08b4320420bcfc01303b
Message-Id: <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
In-Reply-To: <202609271644.eX9EFdJw-lkp@intel.com>
References: <202609271644.eX9EFdJw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 16:00:49 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: b4fc90c82982d98959af08b4320420bcfc01303b  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com
> 
>     aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>     aarch64-linux-ld: Unexpected run-time procedure linkages detected!
>     arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
>     fs/proc/task_mmu.c:3450:17: error: implicit declaration of function 'drop_rcu' [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3452:17: error: implicit declaration of function 'reacquire_rcu' [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3452:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
>     gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
>     hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
>     memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
>     mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'

Thanks.  Against "proc/task_mmu: remove unnecessary inlines in function
definitions":


From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Sun Sep 27 10:59:53 AM PDT 2026

fix CONFIG_NUMA=y && CONFIG_PROC_PAGE_MONITOR=n build

show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers are
currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
with CONFIG_NUMA=y and CONFIG_PROC_PAGE_MONITOR=n therefore fails to build
with implicit declarations for both helpers.

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
+#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_


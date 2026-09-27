Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC7C1A6836;
	Sun, 27 Sep 2026 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790541062; cv=none; b=GCed4FddnsHvKPc9ddZhhXUq1lF+scevbsGovDuUEhL74KA0pDtNlOv42+wrSdJayyiP+yfZMKbY7WsWTfK5LrSteevPEPyBmWeJQVUXJ3G6UMiv7wG7ijq3KTYABVXlIbjCAcu8gRAv/qwO6HobKDeZOzY6EAC1k5Xg+ksyf3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790541062; c=relaxed/simple;
	bh=5YQQHTAuOEar06tx6HfMtvakfC4k28uDuJgvCl6jW5k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pDYCk+uD1S1VgBOE6ACnXu57idF6Dn1t4wf2TeYjpZayQKFj1Oru0y47Oh8wPCVlZGYBB3xUxiZY0IjdVJkMsnguvls2fDKHT2iJyw7vnYGZARa/FPrJLH1bT+nyFKOnHTbJDcrhMlj0fgN2U9+ADut5/x5YiuWy4drJiWlvMwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bZCFoArE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bZCFoArE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B591F000FF;
	Sun, 27 Sep 2026 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790541060;
	bh=eO1GbP2uuZa4hrp2kTCOpYiuFc7Q8kusK/y74limaec=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bZCFoArExGIZS0u/zlqwhpNYP3EhjQ6VjHC3TDViHMWIi14nyx1LJjiqOzHBWx+/f
	 kkKiUa9YyEqhCSs+ddVuXJpQLrknpYA5av9fRlCWCjHW4ecvys5Zl2f8S8OM46Ji2m
	 MkmUEqR6W5oGGtF8GihVH2w+zfJh7emXltzcHys8=
Date: Sun, 27 Sep 2026 13:31:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-Id: <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
In-Reply-To: <202609270030.Y0QVBPmK-lkp@intel.com>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   b4fc90c82982d98959af08b4320420bcfc01303b
> commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
> config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 8.5.0

Thanks.  It works for me, but I'm using gcc-15.2.0.

> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> >> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
>    aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
> >> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
> >> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
> >> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
> >> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
> >> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow
> 


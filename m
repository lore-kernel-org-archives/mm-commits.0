Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591220;
	b=IRFPTjEXYeI4wN8sgVMcbzr/KCLuj6GJ1HfGZqbEXqNhNxKHSoX2RV7oWjJx9bfSDl2u
	 6MxtgAJvrPZvEgHfyFdrf0q0STr8ntHOFFSwk42vuuXMGIlpNDi1BQOl6T6ZzLR2wEoe5
	 x2wfKxKUNBq1vllNsXFZG/3qStacT5F8mASwM+deShRg3HsznIIQcbtTsY7i9fIHnSr2j
	 087QgNihdSrb7mJ6GH5Y4EEV4mnzn8wrPP4USkY1uo1QgzChtGRFylanzbGEGYkmvenYF
	 mN+UqUuknDHHtTJ+rosnIKiXdm6gpr5xOxxBFl4jaQxX+BId/EcT3XfCYN1Q3Q5HTpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591220;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Kv7BDGPBwuPWEZQhR2InhXR34RPBwAkzXgdKO+ZahP0=;
	b=mUdsJphsqYY9DPwliRHOhkbw3H8ANc+v/HhbE7pBSpCMDq6pSRasqGCnszxuBrVNn45d
	 wHJeSsfDTebNJURy+ymX0Db+9IYZrIo8LSH75PvitCLXzrts3tvvhgY6KCb/lUzbH1/WG
	 onF5J0h6Y7IjeNQ5r4AnuQHLbPAJqDOQhaB+9tFVSWhFZ/NeFbO7/F9RyUDdp795vC48P
	 ScSZegZUseneKk1c+Q7KapM4fuR8jbNZ457KYe9wlYxt6WuNK4zEu2Mww1Ns00QWMxI0P
	 NEQpGz+oFPIP2/p/JSKkT9QT9sBy464reQg6X0fkgwSVtThnR+o2TleMpqo24/lFRDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nj+gYvOx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB064607587E;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nj+gYvOx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB71F000CC;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794591219;
	bh=Kv7BDGPBwuPWEZQhR2InhXR34RPBwAkzXgdKO+ZahP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nj+gYvOxuaFa8U1PjQSbesNMnJI3ApEvBsFxziUXX9m3XAIWX/O/zj/09CAgFUjDi
	 7J7qLXRvj/JULay/QFLajS4qrGhpc7sB0xJSMHNMj3FZmdk7mmRsP1VLuF7h8C0I1p
	 BnQHlmoGn4aZPQk98/laiaoOkBUu5s2YqcuXYP34=
Date: Fri, 13 Nov 2026 09:33:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 "Liam R. Howlett (Google)" <liam@infradead.org>, "Oscar Salvador (SUSE)"
 <osalvador@kernel.org>
Subject: Re: [akpm-mm:mm-new 307/308] mm/cma.c:493 cma_find_free_range()
 warn: always true condition '(start < (4294967296)) => (0-u32max <
 4294967296)'
Message-Id: <20261113093338.c9ac760d6f6010f8108d4cba@linux-foundation.org>
In-Reply-To: <202611131415.4Nn1yaIf-lkp@intel.com>
References: <202611131415.4Nn1yaIf-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Nov 2026 14:29:18 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   31a696f9c37defab0f28f774e00ac7f135889ec3
> commit: 4cbc68cde0e185ae7cefed74c1b56e61cfe13277 [307/308] mm/cma: simplify cma_declare_contiguous_multi()
> config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131415.4Nn1yaIf-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> smatch: v0.5.0-9187-g5189e3fb
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611131415.4Nn1yaIf-lkp@intel.com/
> 
> smatch warnings:
> mm/cma.c:493 cma_find_free_range() warn: always true condition '(start < (4294967296)) => (0-u32max < 4294967296)'
> 
> vim +493 mm/cma.c
> 
>    476	
>    477	/*
>    478	 * Find the largest free range above 4G that can hold a part of a multi-range
>    479	 * CMA area.
>    480	 */
>    481	static phys_addr_t __init cma_find_free_range(phys_addr_t align,
>    482			phys_addr_t size_align, int nid, phys_addr_t *basep)
>    483	{
>    484		phys_addr_t start, end, size;
>    485		phys_addr_t max = 0;
>    486		u64 i;
>    487	
>    488		/* no point searching if the system can't addres above 4G */
>    489		if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
>    490			return 0;

silly smatch.  But I'll fix that typo!

>    492		for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
>  > 493			if (start < SZ_4G)
>    494				continue;


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7415E2BB1D;
	Tue, 30 Jun 2026 00:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778751; cv=none; b=PqDRmUQBGqDop6NO6l4sEreNbBbiOA+F1w58ioDrpKf7wUnFiuK36b+eLVCg3Zg89PL5i4PyRmIkd+zMiTG4qkYZUxFMmCueosEjjHL/I5JGfwg/E+06tIFJZmAWRerjHYW9ON4HZrG47ETXgbJ0N+2ec57vuvPC6p+1Bn3HFMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778751; c=relaxed/simple;
	bh=EqAg5SzOGJ0RD2yzW+ToK1+4IxCF7uqU9AadQ6uLmqo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i0vipgy8ky9iS5fjpdgGjURGxSPuOcp43r9d8iI62fY4Z5rWfrDKr0fN4nTckojJckVNCgAhSRfI2/lSa+b2Ar4i96rCnx46IkgHKSCclQgvL5vjSjoDplfKwXm0X8NLbiOZmSjZwMCqieNWBZeDCz5MI4jXl//5bxlSkrIKEV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nv9rkHwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nv9rkHwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A15A1F000E9;
	Tue, 30 Jun 2026 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778750;
	bh=D8J7zyOljJxIqZB5f7uwdIkFI5+z/zXnpkVRuCp1TkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nv9rkHwLKumPriu4HCUOBpBwWTkj8j7Oi0Qpx09LjAX42ImcenX3nSswjKvLS9ewS
	 Rr48m2UzsJKtSW0rKOoiW5ZPJFNxG+cUZgxFtrpIpG6tve4XaoJXIEmck9twg191WB
	 z7b68thqB94mCvK4qCcrTf33doOMfHBBD42c7rCI=
Date: Mon, 29 Jun 2026 17:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, Guo Ren
 <guoren@kernel.org>, linux-csky@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
Message-Id: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <202606291606.9h8aGniQ-lkp@intel.com>
References: <202606291606.9h8aGniQ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jun 2026 16:58:34 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   88cefc306c43b58d9bb65c9e96e284306710d961
> commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: map contiguous pages in batches for vmap() if possible
> config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/vmalloc.c: In function 'vmap_batched':
> >> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
>     3590 |         unsigned long start = addr, map_addr = addr;
>          |                       ^~~~~

Sigh.

	unsigned long start = addr, map_addr = addr;
	...
	flush_cache_vmap(start, end);

See, this is our punishment for writing kernel code in CPP rather than
in C.

I'll queue (and test) the below.  It should be OK -
arch/csky/abiv1/inc/abi/cacheflush.h directly includes asm/cache.h
which declares cache_wbinv_all().


From: Andrew Morton <akpm@linux-foundation.org>
Subject: csky: implement flush_cache_vmap() in C
Date: Mon Jun 29 05:07:51 PM PDT 2026

To avoid getting an unused-var warning from

	unsigned long start = something;
	...
	flush_cache_vmap(start, ...);

Cc: Guo Ren <guoren@kernel.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv1/inc/abi/cacheflush.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-flush_cache_vmap-in-c
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -42,7 +42,12 @@ static inline void flush_anon_page(struc
  * Use cache_wbinv_all() here and need to be improved in future.
  */
 extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
-#define flush_cache_vmap(start, end)		cache_wbinv_all()
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	cache_wbinv_all();
+}
+
 #define flush_cache_vmap_early(start, end)	do { } while (0)
 #define flush_cache_vunmap(start, end)		cache_wbinv_all()
 
_


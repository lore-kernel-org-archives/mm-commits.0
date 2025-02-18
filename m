Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F65B239086;
	Tue, 18 Feb 2025 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739904087; cv=none; b=s//2y8dEgE89wHMPPS4UCUA/bbEzfEp62QmaXmUBKn1ma/5CN5xjYulKLdkp9uFU4yUk8JETTHQWPcbrn7xRlS+0YOjn6c9pazG37aqdFjP5dZIVIbW46jmUJVCz9hwZFg10dgbyibVJqM/vYMSTadUdwTDuUG47oxz7yUjnxTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739904087; c=relaxed/simple;
	bh=SwR1sd0bsb1Ldfx0iR+Z11qCAEsWof8L4vEOyN0rOlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g9l38CtO2O9I4G/RWH1ffATxPQXHoWOOMJsHsWiif48Ao0pKwFCjwowHXSXGV4j1y0UI3LH2fT0xA2FnrmuNxYpOixW7A48PJAj2ndnLRudS/BF///DevRMh1MXSMzK8RiH0BIf5bdjcxgrCH6mkb4A45LbP6v9ESdiOWlH7kXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4DAXhgC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4DAXhgC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739904086; x=1771440086;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=SwR1sd0bsb1Ldfx0iR+Z11qCAEsWof8L4vEOyN0rOlo=;
  b=Y4DAXhgCLh8Fc2hhFVNoayk/P+gYlPC20MP0ZQiEHitl9aialCwxd7EU
   Hz+dA/XwpjQtv6GLnUQZnJkQ0HrylKq3gPsJyUzf5ySNAOLpZwarzlsiW
   kQLURt6CiufVnMjSXeMnhc1RIAPilFA2dOh4cLfQEmsHBzxwiqJpJBDPG
   00c7DD4D7+7IsFQdyze3u3AN3Biq63xdAxk5XuatWoZGWEfNkwI+2Mrcj
   bU/4rPYlKLKyv1atqYXsS8jdzg5qz2UXjg4xcUWPcPXIXXc3kHE3ZFye9
   VpRZXvZpKH1VmqfjRbwkVTKbvDKb+9tDhr5+JuYIRxH80G3jvpF/maOn7
   Q==;
X-CSE-ConnectionGUID: 2a57/VjJT6+qHqKfh0Vr9w==
X-CSE-MsgGUID: 4GFAS9R2Qz+Z0xYcEFvM4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51259542"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="51259542"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 10:41:25 -0800
X-CSE-ConnectionGUID: 7XuQNNHZSmSDOvzohj0vQg==
X-CSE-MsgGUID: 4NASh5FJQZamsnkb5fsAyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114334949"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.167]) ([10.125.109.167])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 10:41:23 -0800
Message-ID: <24fae382-2dc4-4658-b9b5-b73ea670b0b0@intel.com>
Date: Tue, 18 Feb 2025 10:41:27 -0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, peterz@infradead.org, osalvador@suse.de,
 luto@kernel.org, dave.hansen@linux.intel.com, byungchul@sk.com,
 42.hyeyoo@gmail.com, gwan-gyeong.mun@intel.com
References: <20250218054551.344E2C4CEE6@smtp.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <20250218054551.344E2C4CEE6@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/17/25 21:45, Andrew Morton wrote:
> When a process leads the addition of a struct page to vmemmap
> (e.g. hot-plug), the page table update for the newly added vmemmap-based
> virtual address is updated first in init_mm's page table and then
> synchronized later.
> If the vmemmap-based virtual address is accessed through the process's
> page table before this sync, a page fault will occur.

So, I think we're talking about the loop in vmemmap_populate_hugepages()
(with a bunch of context chopped out:

        for (addr = start; addr < end; addr = next) {
		...
                pgd = vmemmap_pgd_populate(addr, node);
                if (!pgd)
                        return -ENOMEM;
		...
		vmemmap_set_pmd(pmd, p, node, addr, next);
        }

This both creates a mapping under 'pgd' and uses the new mapping inside
vmemmap_set_pmd(). This is generally a known problem since
vmemmap_populate() already does a sync_global_pgds(). The reason it
manifests here is that the vmemmap_set_pmd() comes before the sync:

vmemmap_populate() {
	vmemmap_populate_hugepages() {
		vmemmap_pgd_populate(addr, node);
		...
		// crash:
		vmemmap_set_pmd(pmd, p, node, addr, next);
	}
	// too late:
	sync_global_pgds();
}

I really don't like the idea of having the x86 code just be super
careful not to use the newly-populated PGD (this patch). That's fragile
and further diverges the x86 implementation from the generic code.

The quick and dirty fix would be to just to call sync_global_pgds() all
the time, like:

pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
{
        pgd_t *pgd = pgd_offset_k(addr);
        if (pgd_none(*pgd)) {
                void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
                if (!p)
                        return NULL;
                pgd_populate(&init_mm, pgd, p);
+		sync_global_pgds(...);
        }
        return pgd;
}

That actually mirrors how __kernel_physical_mapping_init() does it:
watch for an actual PGD write and sync there. It shouldn't be too slow
because it only calls sync_global_pgds() during actual PGD population
which is horribly rare.

Could we do something like that, please? It might mean defining a new
__weak symbol in mm/sparse-vmemmap.c and then calling out to an x86
implementation like vmemmap_set_pmd().

Is x86 just an oddball with how it populates kernel page tables? I'm a
bit surprised nobody else has this problem too.

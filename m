Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B524679C;
	Tue, 13 Oct 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929564; cv=none; b=KnDuG/9lGJKTH/RpPi6CsRJtFTA/GrOMzVzQ1pDNj3hZoMCyq5ylZ5B9bxyEif9BR+ytX7VVpty2OM8ykGFYd2HyDv4RxAiHdnVmrcBWZ9kTX6F4m1RkxANIMe4VgTiaGSVNAt2YHk8oCMGI/mLRyNqIGVJgmpUa5ZdpTqfl6rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929564; c=relaxed/simple;
	bh=zsgg6SSXEswE+MQtEJ0JCweKWbY56CvbZaeuSGJxBXw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DaV/jfBK1yc++2g20qnz84PmnrZ9ot+pQS6+DOUUJfG2zVo9NjewcsKmGdDPNKjuNwWwMgAxzuXFqFhYQCeBg10XNpJkuAwIE3W49q42Ph2pi2e9OLplW57oOeSTbMAmCYv7xQ7mJk2QHa0NDGe4+mPzYAMy8T67XxgQwvTqINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aME28oZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aME28oZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12551F000FF;
	Tue, 13 Oct 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791929562;
	bh=4IWTZDsa935wj21bGB8vBONkihK5G/3DpXxeoZPCgiQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aME28oZGAgzYgLlb5N4BWBzXkODcJumjTJWJClMakkjxh4PuNcEGo+/y1pM9SeUrr
	 LSYYATmt3K9iTX+RJ9RY0jB2LTx6fp1HXFl/AX/HYdyNC4U1mWl1uxwOmHXSfifmgM
	 yih1bCuSr11rL5OGCdWDkD15YFbyAoJG68EfL84w=
Date: Tue, 13 Oct 2026 15:12:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Muchun Song <muchun.song@linux.dev>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 183/193] arch/riscv/mm/init.c:1544:2:
 error: implicit declaration of function 'free_pgtable_page'; did you mean
 'pmd_pgtable_page'?
Message-Id: <20261013151241.c8982a44c32d93a8ec010fee@linux-foundation.org>
In-Reply-To: <202610131439.F2KDdzRA-lkp@intel.com>
References: <202610131439.F2KDdzRA-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Oct 2026 14:18:21 +0200 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   7186f1bd21b9094cc063c10f8492fd135522d3cb
> commit: cf6402c085736133c835e1f815f79e7e1faf97a0 [183/193] riscv/mm: fix missing destructor for hotplug PUD tables
> config: riscv-randconfig-r2109-20261013 (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/config)
> compiler: riscv64-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610131439.F2KDdzRA-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/riscv/mm/init.c: In function 'free_pud_table':
> >> arch/riscv/mm/init.c:1544:2: error: implicit declaration of function 'free_pgtable_page'; did you mean 'pmd_pgtable_page'? [-Werror=implicit-function-declaration]
>     1544 |  free_pgtable_page(page);
>          |  ^~~~~~~~~~~~~~~~~
>          |  pmd_pgtable_page
>    cc1: some warnings being treated as errors

OK, thanks, that patch is dependent on "riscv/mm: fix hotplug
page-table destructor handling", which I've disabled to simplify
merging with riscv.

I'll temporarily disable "riscv/mm: fix missing destructor for hotplug
PUD tables" as well.

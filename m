Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E58721FF25;
	Fri,  3 Jul 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783092246; cv=none; b=fFGD4lJn2qDSAmQZzuWOhg0mdTknLgLIYGd+EdGSt2Y+FVYpIDYryzMsENRy7CLJC95SBz/c922vHnNxbTMJaVa+UvaBZ1ijkeRHwDX2sRjCIvPDTLfis+mhFe/ALaW3+2h6WozeQiMj9gztU1dZxu8fgeuaU3GuRq+4B0jJXT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783092246; c=relaxed/simple;
	bh=i5iyIVzLq78RhKR8WlKHXqjURewEsYxFaz3paPzLjnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqGUb6LYLfErsB2OWMxDhQqL8W6k3TrcUbENq2zbsQRbWO5hc2jt34RyfE0VgDG3f5nMp6WCt0iahF4kfayZG/1iWj02tkYCEVSZ83n3XHKULFewowkq8myg8dP8lSDv6AAy4qtJKXM2fMkNZ5HXSINAgGObvGWD97dPcn2X0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Q8Aih6AY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Q8Aih6AY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2osf34xTIrbXNjSX6meB3wb3DJ/HNiHPpxtcmn5q1zA=; b=Q8Aih6AY6Sz7z7RVwjGmox87mH
	Ng2rRHQG/prv6AL4r1pPZRXJ+psCD8/2zyIbZfZOWLGJCvJAKrfc9PsKMyMDlQz41IBeYlxAR2ML8
	2P9XOssci1hpi3HIyQAGf6J/heJOrBLK1ZUwVVkd4Jpibt/b9oPffpgpKkIwsuqIhJ0OmDj/DgWe5
	h2VsnJBHk6SVjKc1KB98wc/nMu0r/SqgiNyzNf62+Y3S3RhgRBDAdyftwHwD6wafSIpy6VCOAzUwx
	yWmQjpLS65yEVv8yTPdqwbs9tivltqsttkzdHoNhtMuPUQTjEP/QQoJOJQ2ACKZxnLdE8awc98oAg
	2a+yQoyg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wffkH-009Ue3-1p;
	Fri, 03 Jul 2026 15:24:02 +0000
Date: Fri, 3 Jul 2026 08:23:57 -0700
From: Breno Leitao <leitao@debian.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 242/252] radix-tree.c:459:17: error: implicit
 declaration of function 'kmemleak_transient_leak'
Message-ID: <akfT1s9f-3HgxGlD@gmail.com>
References: <202607031019.AffpLUyg-lkp@intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607031019.AffpLUyg-lkp@intel.com>
X-Debian-User: leitao

On Fri, Jul 03, 2026 at 10:30:59AM +0200, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e031e55776cf9193b4720a253e92539ca536d224
> commit: 58b5601b28c144be1905eef7964bfa8457f58292 [242/252] radix-tree: fix kmemleak false positives on tree head reassignment
> config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/config)
> compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607031019.AffpLUyg-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    radix-tree.c: In function 'radix_tree_extend':
> >> radix-tree.c:459:17: error: implicit declaration of function 'kmemleak_transient_leak' [-Wimplicit-function-declaration]
>      459 |                 kmemleak_transient_leak(node);
>          |                 ^~~~~~~~~~~~~~~~~~~~~~~

Ack. This seems to be used by userspace tool that compile radix-tree in 
userspace, and it doesn't understand kmemleak_transient_leak().

V2 should have a fix for this:

https://lore.kernel.org/all/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org/

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC922D753
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266700; cv=none; b=JIFqjx4o/siJU7FfxoneH+HadGygtNeKwbshc/KgYo6boykTZ+YK7B3hWNLTy/ZHkPMyW/1c4w60aTPcG5RKu30aHVqw63Vp1mvipjsmT2iV8moMF7ZUdkRzv2ImCZ6GvhpBJImOFEEIr4RYU00KTFeKkin9VmBSc6OqInHxs14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266700; c=relaxed/simple;
	bh=t1zXb2trRwQJO17AbvRrDE44Lm7b8psf1spv/ibhgXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPCsoz/yMf5+lE4hypNjoyb36T3dL7ShvnlVNO84hzJOHO/5uQiULdRqFL4J6NLrVnSjUeEgUXT0Ub43Otoy+0j7Bg7Q6z1IMZmsB4sqQD3bPDv50Tmcj55seVSUfFYC/MAxadQWmdCIQNg/HZH8RYBlRi0gIfD6ZrRQTPkvIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tqu8rH70; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tqu8rH70"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O9zRMg73MApQbDqMkq3ZvbscKAG9NVNy3ItN7Fzip6k=; b=Tqu8rH70rJphS667J3t89pNoNI
	dPHqGu1/HiqTbLq+J/brCxWLBUhEEmtt+Zd93D7xizqSqE+SwoqVl351/FvHcz/kKDdvgTh++HlEn
	ytiF3RPZXNph4qV83AAkt9ZBovPS2eLqtZkBSIJo4aXDCF4ikoPF1W9lckMC6Z/Bg160jzeM8E2LO
	4BhAKToaDzJRAcICsQ9+BELPT0DgYvz95jF6aKL5hXAZNr8PEHQBjZEfM77fNSPl2umPFTCDcXuLP
	4KI8x2mtkvOmxJ8tAF3YPG05B5Z8uzQaC5Hr1rPVJjhKCqvno1XlTNOGE+y05yj9qnILt7pZ02X22
	Vk5aHjPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stQyC-00000003wxO-0EJP;
	Wed, 25 Sep 2024 12:18:12 +0000
Date: Wed, 25 Sep 2024 13:18:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
	peterz@infradead.org, oleg@redhat.com, mhiramat@kernel.org,
	sunnanyong@huawei.com
Subject: Re: + mm-move-mm-flags-to-mm_typesh.patch added to mm-unstable branch
Message-ID: <ZvP_g757PkAb6thl@casper.infradead.org>
References: <20240925100517.DFC29C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925100517.DFC29C4CEC3@smtp.kernel.org>

On Wed, Sep 25, 2024 at 03:05:17AM -0700, Andrew Morton wrote:
> +++ a/include/linux/mm_types.h
> @@ -1499,4 +1499,85 @@ enum {
>  	/* See also internal only FOLL flags in mm/internal.h */
>  };
>  
> +/* mm flags */
> +
> +/* core dumpable occupy bit0 and bit1 */

... but why is that important?

> +#define MMF_DUMPABLE_BITS 2
> +#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)

> +++ a/include/linux/sched/coredump.h
> @@ -8,12 +8,6 @@
>  #define SUID_DUMP_USER		1	/* Dump as user of process */
>  #define SUID_DUMP_ROOT		2	/* Dump as root */
>  
> -/* mm flags */
> -
> -/* for SUID_DUMP_* above */

the old comment told us why!

> -#define MMF_DUMPABLE_BITS 2
> -#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)

NAK this patch.

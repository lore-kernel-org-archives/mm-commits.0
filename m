Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0003B47CA96
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944409; cv=none; b=N7rPzj0FUebGGsA4vnengOlykGMI5f8LyrYzI4b/KZwr3A787tQkossOn9jdd3Zlnd1Z3zOlmrxFc0SHW8K3n6Tuhq6nSq3EmMCfFTAM52XyOZ6dfnZQO7xLHNoEH1dV2x5HX5l7/eMjTXyHWKDGEJ5l6VGqsXxZ4YxCr4ytk/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944409; c=relaxed/simple;
	bh=Kv8TEyj07KgAlCBdc+NZjfZORji21a8Z3p+M6qQtCdc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=smH/gtlSB9aPWTx8st50cJkNx24+jZeH4zTzTqwPQ4JOieKrp0B571U2xkDMA/jlCpKuH1oULG30T6Syy4nsOyzrE7O4xlVtb3uvRmoAhOgQVTJ51rfZ+rm8oTsHT0Xp3LB19iL9MRpcIV33UBoAc/tB2VLEVZ5q90tMKYce88c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYYMgLUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYYMgLUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38131F000E9;
	Wed,  5 Aug 2026 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785944405;
	bh=Yyp1Jx5TsTnjgSPHEVsBIOepBcBoQsHK8XWBCZVl2R0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AYYMgLUBM0HBs2ErJaGcEb66aVopXjcrNQWSryY0zMd9FSd7NOnZ4C6e3lfcPh2kR
	 XCLgvmnP+9PsHbhHPlKJ2hJrHYK/TFkC6CA9V/EgJrqGDuJ+zRIzdVw2XX6j+Hcm1L
	 Idzlw2CMtozwkJjP0EfhM2EdECZ5QZe+XLqDVXIw=
Date: Wed, 5 Aug 2026 08:40:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Pratyush Mallick
 <pratmal@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 e47602c51d20a93fa1711ed896dc9480de4374d9
Message-Id: <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
In-Reply-To: <202608052027.LCDnsFT0-lkp@intel.com>
References: <202608052027.LCDnsFT0-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 05 Aug 2026 20:32:52 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: e47602c51d20a93fa1711ed896dc9480de4374d9  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202608042227.XDO54bZk-lkp@intel.com
> 
>      .gitignore files
>      ignored by one of the .gitignore files
>      of the .gitignore files
>     /mm/write_hugetlb_memory.sh: warning: ignored by one of the .gitignore files
>     /selftests/mm/ksft_hugevm.sh: warning: ignored by one of the .gitignore files
>     _hugetlb.sh: warning: ignored by one of the .gitignore files
>     a.sh: warning: ignored by one of the .gitignore files
>     arning: ignored by one of the .gitignore files
>     fd.sh: warning: ignored by one of the .gitignore files
>     files
>     g/selftests/mm/ksft_memfd_secret.sh: warning: ignored by one of the .gitignore files
>     les
>     nore files
>     s
>     s/mm/ksft_ksm.sh: warning: ignored by one of the .gitignore files
>     selftests/mm/ksft_pfnmap.sh: warning: ignored by one of the .gitignore files

Thanks.

I'm guessing this is due to "selftests/mm: use pattern matching in
.gitignore"?


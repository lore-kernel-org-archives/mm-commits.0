Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA741C6A;
	Sun, 26 Jul 2026 02:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785034270; cv=none; b=onBf7zc/QtCswWFoPzQ43s3M7Dz7fgqq1LCcnhMoDTlt6NtCxAtX9JjikToYGGWT/+YUK6CGV4iT0HYcqO/e28Gyjds9+pg1ujJK1sYQWFEE2JzWdhHxHDgEzzgKCBo8FoN30X8UjK2jPiAOZAx0CwvmoHg19tZTK/ub8UfNCI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785034270; c=relaxed/simple;
	bh=ftX+jeoEnC7fTuImJuKIGJgezCpEbcnVZbW3AmOZbHQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=g3mjdorBV33AjLWtaYZqaEtmBxABNRvp0A7O96G4ODY/+6yDWLVYjhfLkQDd8ShRO22M7k+405URUGcCu9b1m4NPUlEUTtiFOoIqcetj9hAccQn5+mg/O6AJKCtbqlobRrUA+Ms9DoL9lRsL619wrLYOujSKCxGYNT8rKD7NeQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vs/G0SX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vs/G0SX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D11F000E9;
	Sun, 26 Jul 2026 02:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785034269;
	bh=uJqo0KAzdrTFteiLyXiwHItJklOekXH2ZJCIKZBTq1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vs/G0SX2LvUBaB5f47wVVZ4IU34Pbvqdf2ByrOMvD2TbNVqAs45qqix+KYHqZGLW+
	 LElKKXECKoOKC20W7/PLESsPwuTNRdowUZjjpWacQZMbh8I3GpvI4bVkXiUN3VIW8A
	 4DxKo27pmPJR/9Xed4JBG3G5TBPVxXME0+tOoRDc=
Date: Sat, 25 Jul 2026 19:51:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-Id: <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>
In-Reply-To: <202607250853.VaJWGLeA-lkp@intel.com>
References: <202607250853.VaJWGLeA-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Jul 2026 08:56:41 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
> commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
> config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from <command-line>:
>    mm/huge_memory.c: In function 'move_pages_huge_pmd':
> >> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
>      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                          ^
>    include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
>        prefix ## suffix();    \

Well dang.

I can't reproduce with sparc64 gcc-15.2.0. 
Documentation/process/changes.rst says we support 8,1, released in
2018.  Your 8.5 was released in 2021 so perhaps three other people are
still using it :(

https://www.kernel.org/pub/tools/crosstool/ doesn't appear to have
sparc64 gcc-8.5 so I gave up.

So I dunno.  I'm inclined to ignore and assume that if someone else hits
this one day, they'll either fix it or provide us with enough details
to figure it out.


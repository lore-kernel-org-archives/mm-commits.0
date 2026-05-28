Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDDE3BE621;
	Thu, 28 May 2026 16:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779986758; cv=none; b=aogcoqegAjJ386rqa6dbW/TzEKIkdgBFLgSeHEDotMhxoWLyLVqhI8NxejDryf4NHdVuLh7gBwpHdKqMv16rCjWSx4waMuu7undZeKFp+KN5oMW4uoNzkkWUCNmxrsFkqBgzuOT2rWfHPiCCrkpZ10DVGHtrrpOK9HewDaEuGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779986758; c=relaxed/simple;
	bh=b4eTULCyI7iEviMRJ/tS/fhvenP/+Sn2WM0zItUkuF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7s9Y4J6S2jSjzweIzoKx9s9XBciB+r5zdKLu/LgQwQgWHjZpUL2iOLKORtHBhMoAw3HgPLrJYgiJbHJ40vem8GJcehVV291BaR89uXkjZpSXCp7mf6wbzoK9JsT4U/cEuabG/Pox9KeETjgnDcKsG2jlEvNfzYrkIed97JC77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsrHQpmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsrHQpmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369EC1F000E9;
	Thu, 28 May 2026 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779986756;
	bh=uD/DS6x9bXsYcWxd2veAzMu1GEe3GHOeMibHtLaSx4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dsrHQpmRu32R77qDus+MtT68nh/wLDtzQgHn0bQ8lrb6rHBhve04WlkL27LzZyhYW
	 yGFQgr7Ykg4+SEPK9/NBKs35kZMmBl9RTGAU+cNNVUss5WZIlXy1c41hEnXQijtvRg
	 A+lVb86uEjpmRfPZHejTCeJ22hmpqlplwwE2FoICWx95xO3Lm6hetRLOVpMu8e3Xqg
	 D4OoKIlrLnBMz0phA6x6ORSbPbbOpgIEYvfXsDyficSjR26WqAqiqE2ItIu8MWHMi5
	 ++W1+fvxlq37OwvBF4PNdJW03RkscFyKqoNaKtA8Xpa3xzBmQkNSsCoEbJrk22qLJX
	 BHnXZfZRDNkug==
Date: Thu, 28 May 2026 09:45:52 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 273/420] mm/userfaultfd.c:4475:1: warning:
 alias and aliasee have different types 'long (int)' and 'long (typeof
 (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof
 (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))),
 0...
Message-ID: <20260528164552.GB1342076@ax162>
References: <202605282311.BlbuvsRF-lkp@intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605282311.BlbuvsRF-lkp@intel.com>

On Thu, May 28, 2026 at 11:28:25PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> commit: 688eee218159283140c8c4b48429cfe400cb64e4 [273/420] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
> config: arm-randconfig-003-20260528 (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605282311.BlbuvsRF-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (int)' and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
>     4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
>          | ^
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    include/linux/syscalls.h:251:18: note: expanded from macro '__SYSCALL_DEFINEx'
>      251 |                 __attribute__((alias(__stringify(__se_sys##name))));    \
>          |                                ^
>    mm/userfaultfd.c:4475:1: note: aliasee is declared here
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    include/linux/syscalls.h:255:18: note: expanded from macro '__SYSCALL_DEFINEx'
>      255 |         asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))  \
>          |                         ^
>    <scratch space>:46:1: note: expanded from here
>       46 | __se_sys_userfaultfd
>          | ^
>    1 warning generated.

Sorry for the noise, this is from a compiler upgrade, not a fault of
the blamed patch. I plan to submit a fix for this to Linus soon:

  https://git.kernel.org/nathan/c/175db11786bde9061db526bf1ac5107d915f5163

-- 
Cheers,
Nathan

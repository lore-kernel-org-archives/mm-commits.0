Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0DB19539F;
	Thu,  4 Jun 2026 01:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780535967; cv=none; b=pjSqA5AXLgaBZyzwHBiOYUlB89ZHxoVhysSmFVrbjhK0ILGFzhwqrlTZorQEGDFdlK173XTWg2nXeh7jh4FD66jtO2zcxnnTq5lp95PmSZHj8kXEjTkzqeG33n8o8SyiaKJY04AKW9Wr3uzz3ND89Zf+R0NXkGB7M9ZUGbj91vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780535967; c=relaxed/simple;
	bh=1WwmzN29ORLbTFjtCM9yLOjbWCGZTYTvPIh2Ofj0H74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggmoRX7GBZppAy9xqzVxlWkNNTj3c3+KfTDLmQbyK4BuiFBdes64E6NjIClkrk6ad//wIB1hIBtHXEWtnYrKS5BPAZE8xgIDxB/r1IrQCfMN1Cz53c+cRTe/2XpSbhNJQPCrCxRoIEQ9Rv/ZUqQnwD2UG/KzCHsRPe1a7gNrtrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5XsDUv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5XsDUv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCE51F00893;
	Thu,  4 Jun 2026 01:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780535966;
	bh=OC2aLlOHe9nbxKbN6iiUmt49s8yh8/9Q9SdTr4G6ru4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N5XsDUv2Kw9VML6g5U88DT7ZNzkDdXLZ3aiuBI5+XlksR3H0zkVI7T6i8FI+L7i1N
	 kDM2b5yqi90rQ99EaQJI3g8XegeKFyG5usithsAxx7AJfs54vfFl2Toklmzv0xqVxQ
	 FTJRYaWolql9UZgyPe0VbRkbDzj/LWeVSGBTMUfSa/Z2ncObNAnZECsbhjZ88aHKUh
	 zoWhcSajOOzMGd7Z5+eTsK4lG6DNI4NbSm5f/TqZ5C62gqAvBmZdkL++TMWylww2kp
	 oK/lABLtuRocYBIaoGFT0j3HDDmMfZuru5jrSJKkeoH+rZjQzy9aJpkzOrZFptM+CL
	 J9pcdu5QNZbAQ==
Date: Wed, 3 Jun 2026 18:19:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 274/423] mm/userfaultfd.c:4475:1: warning:
 alias and aliasee have different types 'long (ulong, ulong, ulong, ulong,
 ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned
 long, unsigned long, unsigned long, unsigned long, unsigned long)') and
 'l...
Message-ID: <20260604011921.GA1329739@ax162>
References: <202606031038.1aPfmoCm-lkp@intel.com>
 <ah_BbB_BnjnNh85i@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah_BbB_BnjnNh85i@kernel.org>

On Wed, Jun 03, 2026 at 08:53:48AM +0300, Mike Rapoport wrote:
> (adding Nathan)
> 
> On Wed, Jun 03, 2026 at 10:29:32AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   6bb9014e347a15dfa837cbc52451035466d86ddf
> > commit: 53313230f720eaaf9f1f6d20faafd7e01a9e09b7 [274/423] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
> > config: riscv-randconfig-r122-20260529 (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202606031038.1aPfmoCm-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> 
> Looks the same as https://lore.kernel.org/all/20260528164552.GB1342076@ax162
> Nathan said it's a compiler issue.

Indeed, this should be resolved in Linus's tree with

  175db11786bd ("Disable -Wattribute-alias for clang-23 and newer")

> > >> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (ulong, ulong, ulong, ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)') and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
> >     4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
> >          | ^
> >    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
> >      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> >          |                                    ^
> >    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
> >      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
> >       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:37:19: note: expanded from macro '__SYSCALL_SE_DEFINEx'
> >       37 |                         __attribute__((alias(__stringify(___se_##prefix##name))));      \
> >          |                                        ^
> >    mm/userfaultfd.c:4475:1: note: aliasee is declared here
> >    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
> >      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> >          |                                    ^
> >    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
> >      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
> >       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:41:14: note: expanded from macro '__SYSCALL_SE_DEFINEx'
> >       41 |         static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
> >          |                     ^
> >    <scratch space>:148:1: note: expanded from here
> >      148 | ___se_sys_userfaultfd
> >          | ^
> >    1 warning generated.
> > 
> > 
> > vim +4475 mm/userfaultfd.c
> > 
> >   4474	
> > > 4475	SYSCALL_DEFINE1(userfaultfd, int, flags)
> >   4476	{
> >   4477		if (!userfaultfd_syscall_allowed(flags))
> >   4478			return -EPERM;
> >   4479	
> >   4480		return new_userfaultfd(flags);
> >   4481	}
> >   4482	
> > 
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Cheers,
Nathan

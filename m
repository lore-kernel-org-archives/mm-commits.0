Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A38384CE8
	for <mm-commits@vger.kernel.org>; Wed,  3 Jun 2026 02:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780453797; cv=none; b=MltH1ACwqlgN9kzmm3wRrknmo5XN3hA7mXBCDejXN6oGHsg4SLgl5+cmGkTXGkB1OqxR0L88xFL56wDwNh0KwJr47Fl+z7/lvbpgO6gXaSPR7rUcutOcItYeGt2Z5bOVIsQhAt1JMYgMbVLg6qmLnEU5E5UjMTjuji9Q8rox7dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780453797; c=relaxed/simple;
	bh=0hpiZUig1nwVDn3JUe8JPcPCOSz4i0rXxP9ntSiqqzQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=A2VSzSPTqHDCB0i+T/gFVq+FLIC7Brz52qxOzStDJ5F+O0wXBiWPav0wc2ccgc8P/mU9F/lfWDvaAQIHY/ev5nreSAq5bvgHXRh+RUcq0ZtdNXw+iYwvjFTQK4fBR0OnEN1epdBNzVs/Es9QJXjvYSFo7vkBdzJQRttKjbhx13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=au5eL3J7; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="au5eL3J7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780453795; x=1811989795;
  h=date:from:to:cc:subject:message-id;
  bh=0hpiZUig1nwVDn3JUe8JPcPCOSz4i0rXxP9ntSiqqzQ=;
  b=au5eL3J7JIdHLsxKzFzZEgUhhaEBIzJryevEH4lvNSGsvUlpf3OU4AbS
   A/J0gCx3X4z3qpLHEyC7WrRloZ1RUewz4eI6b7I26+/UPcPiOlzFwnOaT
   dFwnF3P8tKZxTRKD5djupXEtC8Mb+2OYfbZMYgAK4Eb3omLgP5Qz7f0QX
   X7cl+N5rsezjhCgMCfobWwXheYU9A1VUfC2w79D30PeWWReBsDCvMSlVj
   u9P0mJ1Z5qCxr37AbfnVIaPpkzlKVDx++9DiXpZAXu+dt0TcnVj9bFJwg
   GCg9qmGH78It7HQEPa1mDFG6qoOzBH7xt4Nt944zJACDJfMy1XwZKdm4a
   Q==;
X-CSE-ConnectionGUID: mxFPcGWoSJi84CiVtcvLig==
X-CSE-MsgGUID: xj3dKsVqQoCNRm0f7lC6Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80281798"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="80281798"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 19:29:54 -0700
X-CSE-ConnectionGUID: LW+6TSgwSSC01zF7ZPdyWQ==
X-CSE-MsgGUID: LmfBN84/T2qtUe0hh1hVXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241597280"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 02 Jun 2026 19:29:52 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUbMb-00000000Cpm-3I7o;
	Wed, 03 Jun 2026 02:29:49 +0000
Date: Wed, 03 Jun 2026 10:29:32 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [akpm-mm:mm-unstable 274/423] mm/userfaultfd.c:4475:1:
 warning: alias and aliasee have different types 'long (ulong, ulong, ulong,
 ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long,
 unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)')
 and 'l...
Message-ID: <202606031038.1aPfmoCm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   6bb9014e347a15dfa837cbc52451035466d86ddf
commit: 53313230f720eaaf9f1f6d20faafd7e01a9e09b7 [274/423] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
config: riscv-randconfig-r122-20260529 (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606031038.1aPfmoCm-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (ulong, ulong, ulong, ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)') and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
    4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
         | ^
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
      82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:37:19: note: expanded from macro '__SYSCALL_SE_DEFINEx'
      37 |                         __attribute__((alias(__stringify(___se_##prefix##name))));      \
         |                                        ^
   mm/userfaultfd.c:4475:1: note: aliasee is declared here
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
      82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:41:14: note: expanded from macro '__SYSCALL_SE_DEFINEx'
      41 |         static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
         |                     ^
   <scratch space>:148:1: note: expanded from here
     148 | ___se_sys_userfaultfd
         | ^
   1 warning generated.


vim +4475 mm/userfaultfd.c

  4474	
> 4475	SYSCALL_DEFINE1(userfaultfd, int, flags)
  4476	{
  4477		if (!userfaultfd_syscall_allowed(flags))
  4478			return -EPERM;
  4479	
  4480		return new_userfaultfd(flags);
  4481	}
  4482	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

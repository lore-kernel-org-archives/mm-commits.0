Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52EB28488D
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982118; cv=none; b=dvUFKWve/gwKGmhd+83PUjJysuU7Tsvodi2qGA+9gxrdx3ldfLz3Rn5QEbTnJu3y53NQtOUOpPWxoVVdMzmYjpvs5T48iAzelmiB1V+E6XyzvKq3u9Kq2+rwnmfCgPiypVmklrPAeuMtigKSf12mFkOg1eeYFyxZV+/MpsanI3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982118; c=relaxed/simple;
	bh=h6gIQSh7EnSLP0hziwCdjn4VeCMknpf+zkhPz4Yk5XQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=jA03YWKwfMdkpkl2t65S+ssZJODUMSW3d8EeknZus+krcOeniDYHacddTszq9+o3+Z8NZ6X++s0nCH4C+Mat/QXe70RfPZumRh1662ALnzLJxcF/6G1v8946Ev/8aCL5sNQSp/9h8ezpEGiyWGP2+Zt/4jFLQOd3XxcsutWIdFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKTxhQRi; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKTxhQRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779982118; x=1811518118;
  h=date:from:to:cc:subject:message-id;
  bh=h6gIQSh7EnSLP0hziwCdjn4VeCMknpf+zkhPz4Yk5XQ=;
  b=IKTxhQRiXivgtvBs7dDkMWacEOrHMNFfp6l5X+Cby62zp1WracOjyJ74
   FXHAs86jMG3xMVEz26UkWqxxgAnMe+DerXmuO7PE7ozqxIIQLUTFV3SAX
   orw3VFKabzQJYKxTJmByxG+29Ara8OEBcllwObOyOOlJz216sTuH8BVP9
   Meh9kgYDeuRzf1UQ/7ktTlqNy1w94I44ZlfflcM5HVnw9XRRbw01IDleO
   iVlACyNgPC9MEAVNFvbE0f334MNYHyK5+lxpPqX5+H6GyD4okonmtSZI+
   if9PS5D+h0j08IJXeHaADhz2sAhWULMG/lT9lo52rgyPjA3rDqR3NvCPR
   g==;
X-CSE-ConnectionGUID: ZkJN3xJxRNejtEeXlqWJrg==
X-CSE-MsgGUID: LP+aWqJHSgCqidnZSR54Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="79975583"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79975583"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:28:37 -0700
X-CSE-ConnectionGUID: DMwmCKApSv+F9qWfLRbzpA==
X-CSE-MsgGUID: e7+FBSsnRKK8gBnb32NJVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="238399635"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 28 May 2026 08:28:35 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSceu-0000000064g-0QZ5;
	Thu, 28 May 2026 15:28:32 +0000
Date: Thu, 28 May 2026 23:28:25 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 273/420] mm/userfaultfd.c:4475:1:
 warning: alias and aliasee have different types 'long (int)' and 'long
 (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0),
 typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof
 (0ULL))), 0...
Message-ID: <202605282311.BlbuvsRF-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   8a74e22643189e0ae339afc91110ddb4cab1941b
commit: 688eee218159283140c8c4b48429cfe400cb64e4 [273/420] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
config: arm-randconfig-003-20260528 (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605282311.BlbuvsRF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (int)' and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
    4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
         | ^
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   include/linux/syscalls.h:251:18: note: expanded from macro '__SYSCALL_DEFINEx'
     251 |                 __attribute__((alias(__stringify(__se_sys##name))));    \
         |                                ^
   mm/userfaultfd.c:4475:1: note: aliasee is declared here
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   include/linux/syscalls.h:255:18: note: expanded from macro '__SYSCALL_DEFINEx'
     255 |         asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))  \
         |                         ^
   <scratch space>:46:1: note: expanded from here
      46 | __se_sys_userfaultfd
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

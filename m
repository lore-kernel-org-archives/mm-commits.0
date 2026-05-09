Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B67383C80
	for <mm-commits@vger.kernel.org>; Sat,  9 May 2026 12:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778330709; cv=none; b=IIUs8XDFZCbaxPOSsYHyftZiMYbbmm4XrWaSWZNjxvY8RJvnTbiDd2ECuTEMsghlAUfcXcbkeN9mvtv2bG5+EDUKLX7G/MHCIBwnOCvvInh3/T7JzR1eVZPxAd/k8h/MFGCJttMz+lVDQuwh66OlFFq5CkuUglrZyjAGcrghddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778330709; c=relaxed/simple;
	bh=PZUmvWKfk7e0sy8zXMC5sqRs+3lIo/RPX7h8rdfkXr0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=YiZdo1MRMhWvUeB723UAIcxlg6gIaGmk0VMhGYZWhPLJ7irHl9BN8cXWkUPh2gE5S99OaeUmMBRYpB8L3k3xC9GNcLPccU4Wbaa8QHWKO2XUdp7YRTvnbxazm6YU533GuyEby0WJz2eZ1fH21rbQNa+SxWifJNLkbM427+OCpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQsy6F7L; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQsy6F7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778330708; x=1809866708;
  h=date:from:to:cc:subject:message-id;
  bh=PZUmvWKfk7e0sy8zXMC5sqRs+3lIo/RPX7h8rdfkXr0=;
  b=BQsy6F7LDk1cO1ryyLsaP3N+Sz5Nwgn7Por/V7FQS4UehqImaTLMA3Nu
   v2ojkncO7f1dCUCBVYZ+W4s26e/Ar7GQckeCmiM/CAqWekwRPBcpxBLJz
   HVNNWLlRJ4b57PswxHlc+itFs0+dspwZfj6KWZyVw60AHYLezbqBVy10A
   4lxsFxa6nDMjQB9SJumpKlawo4KJBr23q9b5G3g0rOWbdPPzBEZC8BXj7
   6seCoY6f8Noz/8iyOP3olGd9IPYsSQ3/6VndabSDoO3XnmvYnWjgoVT8j
   wlSwFrCcz2wREoOM/UAMYN9fWtdntN022X31lmrCBKMM6k9HkKduQz+vi
   w==;
X-CSE-ConnectionGUID: AdZTRFleQwOOTzwwlw47og==
X-CSE-MsgGUID: ghuB9uxMSH6I9dtr6sXPrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79472645"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="79472645"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 05:45:07 -0700
X-CSE-ConnectionGUID: P6lBYFujSIqbxLGDDIJAWA==
X-CSE-MsgGUID: VWT1n90qRQ2srTMb+CoJPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="242015322"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 May 2026 05:45:05 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLh3G-000000000zN-1riu;
	Sat, 09 May 2026 12:45:02 +0000
Date: Sat, 09 May 2026 20:44:33 +0800
From: kernel test robot <lkp@intel.com>
To: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [akpm-mm:mm-new 222/223] include/linux/damon.h:869
 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <=
 u32max)'
Message-ID: <202605092036.9mdDJbEZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   7505bb13a9bb1f214310915ccc06643119fdafc9
commit: 8b7c38eb9621c71d288eca45c8dd4dc92357dc07 [222/223] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
config: riscv-randconfig-r071-20260509 (https://download.01.org/0day-ci/archive/20260509/202605092036.9mdDJbEZ-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
smatch: v0.5.0-9065-ge9cc34fd

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com/

smatch warnings:
include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'

vim +869 include/linux/damon.h

   861	
   862	/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
   863	static inline unsigned long damon_rand(struct damon_ctx *ctx,
   864					       unsigned long l, unsigned long r)
   865	{
   866		unsigned long span = r - l;
   867		u64 rnd;
   868	
 > 869		if (span <= U32_MAX) {
   870			rnd = prandom_u32_state(&ctx->rnd_state);
   871			return l + (unsigned long)((rnd * span) >> 32);
   872		}
   873		rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
   874		      prandom_u32_state(&ctx->rnd_state);
   875		return l + mul_u64_u64_shr(rnd, span, 64);
   876	}
   877	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

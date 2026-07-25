Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B72367DF
	for <mm-commits@vger.kernel.org>; Sat, 25 Jul 2026 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784941083; cv=none; b=OA4m4C9b4yVxsM6FkUNyyZBngkjx8ueL757chEreYmwIxoI3MC7pCfPmc6ZX7SbkEaEpshqruwdaYocBsWawVtJyShGqsQQL+4wfe6yZQYVZvs1g6jlmPLGQysDUjaZwC2JcGklcdp2TjvACzXyZCSpI9uNqRGzsDj5knlKBPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784941083; c=relaxed/simple;
	bh=OAC6lBYbl8VKrUKfiQCex2CU2yUl/JiNEBgpQiMRODM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=knk8kjnRx9HY/PBkUm6uGDGzdZNA3kitO8GuUU6xTwBUQuErHghaTifrrW3m4lyzkv9wIUV9xAPZJ9R8YWq64m1MmiJm5PDJPJ63mrpwk9/LDNuWTFSeYrTbwLIBd3qzqTJhHgb1mg6gwmSJ0tsXBls8e8fwGxmz8il68H+O0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSwVacUg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSwVacUg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784941081; x=1816477081;
  h=date:from:to:cc:subject:message-id;
  bh=OAC6lBYbl8VKrUKfiQCex2CU2yUl/JiNEBgpQiMRODM=;
  b=mSwVacUgqVGE3K3lQyNith4rOM99IRWhwfqjHtgoEyxIqQJlrryBeOCS
   XHHH0zvKyCYO/PdrCVZU+YQWktgmt6NRiUZcnpfmGAstwT2FT0/to2CEY
   /P7H+T0SSORthGwCOWQPH5BR488zPVLGt6rxdsoLCr0U40M7Cr57aQ4BX
   0kCq+SVr7ai3iqLhPzz/77RmlaIjrmQNP0N7YXmH3HSclhPR2uGTEXLSf
   10aZ3VhgkJziO9PhNOmOXr7AJIJcCq71r/EqZHqngXoWilzcWrZfm3FoN
   PDyyVEVMIXTMEEKJKCf8nQcYL0YTGbHYNeTNRiQt/DVLMNn47jqQ+eFXp
   g==;
X-CSE-ConnectionGUID: kxiDR9GrQsSiQi4VCJGSMw==
X-CSE-MsgGUID: ioU9JU/LTEKcaSJt1N5KfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="96984155"
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="96984155"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 17:58:00 -0700
X-CSE-ConnectionGUID: WWJvxTpxS3yqv0N+7GfukQ==
X-CSE-MsgGUID: HVpGNqwLR3q7V+kGTWL2/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="263850546"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 24 Jul 2026 17:57:58 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnQiB-00000000bNy-2WA9;
	Sat, 25 Jul 2026 00:57:55 +0000
Date: Sat, 25 Jul 2026 08:56:41 +0800
From: kernel test robot <lkp@intel.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-ID: <202607250853.VaJWGLeA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/huge_memory.c: In function 'move_pages_huge_pmd':
>> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:702:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:60:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
    #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                        ^~~~~~~~~~~~~~~~
   include/linux/pgtable.h:2145:22: note: in expansion of macro 'BUILD_BUG'
    #define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
                         ^~~~~~~~~
   mm/huge_memory.c:2874:35: note: in expansion of macro 'PAGE_NONE'
      _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
                                      ^~~~~~~~~


vim +/__compiletime_assert_501 +702 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  688  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  689  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  690  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  691  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  692  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  693   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  694   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  695   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  696   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  697   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  698   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  699   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  700   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  701  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @702  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  703  

:::::: The code at line 702 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

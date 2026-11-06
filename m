Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793998007;
	b=NnOfGEkjnsYnnDuut+LD6IQNr/SA4/PjyKhYeMVQAs6mROqGisenGuBlC30+2y47OsMa
	 GEEmud/9OdgZczxf5T2se9miilJfSa0V/4weTuVc/wFWqjJadPuz3VbAqfJD2Yypl5qhy
	 jujYxfQ8ar34SYOJpOSeWYqCrRuxtGt+6xFemD9YX2wLYA7BgUq5jaUBjlX/24EFWpiZB
	 zPc+cwhwXvfKi04IDnr4ywDqpk4DzOH6VT0Gdxgeez2kho0ryDkxIqaODAL5HD3NUlJKH
	 CFl3iV4MjMshj/SDiCipmZS/x78FWnkv283dEGKYgX+HWPBELhKV9IOBiU14AjgeDZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793998007;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=jIADSJVPuQfL5gsl75hN5umXlpPdcC0mAOe4mGJ7x+I=;
	b=Buet4ZIcnTFopVmwIBkkYJDXJprF+L3Ly36uRwzZv5iZNFvx+0t9wIeRf5yDP+qvEEie
	 tK5DlqWCHifWmTIP6LTPl1cYdDzU1yRfHz5+PaPUjkHs3BVFV6npen68emt7ACLhEpLcb
	 MxeEdhpMcLw0PvsYT71uCFq2digsrfcO/18PpOQdEThanPRWlqLrAfTuD+MBNMlaGWBlI
	 lWy7LL3to6dTqsBU0ENfeJNg5OxEQ/NYaxAGFABTKcXUxjjoP5LyLVXalSIilViNkirEm
	 ubkuY55A7svoouD0kdzOAW7QAYaPlVPLudoU90MHtw++0K1g5ze2TZl08SXw40Xp3Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TlwOujbp;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FC8606A32C
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 20:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25FC8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TlwOujbp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793998005; x=1825534005;
  h=date:from:to:cc:subject:message-id;
  bh=Sn7im5GOD3/X9wwaDEsBsmyh+uQ16veT7IBG7auDrGY=;
  b=TlwOujbp+d5hR5nziJFpovgE8YD+5VkzBwg25Qvah7d+d5cwlzVV4xcr
   4eY1Aoe1x7bk8ni4B2h851pw9TngITh7MdR2+TR43cTRDKgy0xRo3sgO9
   6i8Jb6Xxp744TZTjyEzHrw82Gbwyovu/U47z9yXQbTkJREjP35ANBe+I0
   FnjDKTlre9a9zgSwGLh87XdkjuKN/p2I9GI3SP+alk/e6pHhHJyxViA1S
   4TUXLLcGLeA4EumqxwyAptgfrCo439I5Tgu/7TBSC39NuiM0YMsKGDdzm
   xPXN4bJ/zEAH3TvmYbkoxKem3gBd6bj1Ov4OVtiKxd9Debt+yjhWLJ3a1
   w==;
X-CSE-ConnectionGUID: 2KpG2eLhR1WOaQHwxJvsjA==
X-CSE-MsgGUID: Hj8bicy1S/S85n1iSjRLUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2814867"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2814867"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 12:46:44 -0800
X-CSE-ConnectionGUID: RmYHFKgPTAK/HmYv62iIjA==
X-CSE-MsgGUID: K015T0MIQVeqNBldG5g6hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7259002"
Received: from igk-lkp-server01.igk.intel.com (HELO 58ca8a381a5c) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2026 12:46:42 -0800
Received: from kbuild by 58ca8a381a5c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPQpb-00000000AM7-2c1b;
	Fri, 06 Nov 2026 20:46:39 +0000
Date: Fri, 06 Nov 2026 21:46:08 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: [akpm-mm:mm-unstable 225/232]
 include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration
 specifier
Message-ID: <202611062117.gKtstiMc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   a3d27154a205f6b32000e7e2734b2a6a4d22c65b
commit: cb335644ac2611749ab17d3eb6f29c8f77450fa6 [225/232] alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20261106/202611062117.gKtstiMc-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261106/202611062117.gKtstiMc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611062117.gKtstiMc-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:16:
   In file included from include/linux/uprobes.h:18:
   In file included from include/linux/timer.h:6:
   In file included from include/linux/ktime.h:25:
   In file included from include/linux/jiffies.h:10:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
--
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
--
   In file included from lib/test_bitops.c:10:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 error generated.
--
   In file included from lib/tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   lib/tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:118:8: note: expanded from macro '__static_all'
     118 |                                           .two = 0,                     \
         |                                           ^~~~~~~~
   lib/tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:117:33: note: expanded from macro '__static_all'
     117 | #define __static_all                    { .one = 0,                     \
         |                                                  ^
   lib/tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:119:8: note: expanded from macro '__static_all'
     119 |                                           .three = 0,                   \
         |                                           ^~~~~~~~~~
   lib/tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
--
   In file included from tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:118:8: note: expanded from macro '__static_all'
     118 |                                           .two = 0,                     \
         |                                           ^~~~~~~~
   tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:117:33: note: expanded from macro '__static_all'
     117 | #define __static_all                    { .one = 0,                     \
         |                                                  ^
   tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:119:8: note: expanded from macro '__static_all'
     119 |                                           .three = 0,                   \
         |                                           ^~~~~~~~~~
   tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
--
   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:16:
   In file included from include/linux/uprobes.h:18:
   In file included from include/linux/timer.h:6:
   In file included from include/linux/ktime.h:25:
   In file included from include/linux/jiffies.h:10:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:8:
   In file included from include/linux/prandom.h:13:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
   In file included from rust/helpers/helpers.c:43:
   In file included from rust/helpers/auxiliary.c:3:
   In file included from include/linux/auxiliary_bus.h:11:
   In file included from include/linux/device.h:16:
   In file included from include/linux/energy_model.h:7:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   In file included from rust/helpers/helpers.c:43:
   In file included from rust/helpers/auxiliary.c:3:
   In file included from include/linux/auxiliary_bus.h:11:
   In file included from include/linux/device.h:16:
   In file included from include/linux/energy_model.h:7:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
   1 warning generated.
   1 warning generated.


vim +/inline +159 include/linux/alloc_tag.h

   158	
 > 159	static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
   160	{
   161		return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
   162	}
   163	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

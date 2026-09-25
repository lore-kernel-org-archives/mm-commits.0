Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707DC4D5970
	for <mm-commits@vger.kernel.org>; Fri, 25 Sep 2026 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350794; cv=none; b=WZiTmuY5j8U+5NHUmQs9i0AdTGPP58obPv+dW7kbr9CWRTRhRAYYeqQa8zaljnnwyU9Gh2vD5G4J9/YJuLnf14aVi2O4TMoPf/V2scL58AVOVynchl9vXKHTtfUgWkIrTEkqq56+YDG8NnPYUzyio9CuxqA2xB79uEJ14yk7ekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350794; c=relaxed/simple;
	bh=oyfZc8QGmpTxZC9TZKNxXJleoBm39tCdAH6Z0Cndv6o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ZTyj3/0AwWSEM2dTNjO4tqUIyJ3h5uA7VzS8DC3fAGDRyhtp0t0vWQrxlPWJ3cCDZTg5apvSbis8ormqixcCNj61suErbK1tLGMOY7TbVdlm+6Pq+QGGwIyXzjBoVQ9YjW//G/Ck0kt40x4D4a/TrrP5hAX2fCmfEMjAbZ5+9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ghnstwgd; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ghnstwgd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790350792; x=1821886792;
  h=date:from:to:cc:subject:message-id;
  bh=oyfZc8QGmpTxZC9TZKNxXJleoBm39tCdAH6Z0Cndv6o=;
  b=ghnstwgdZxCrQMspnS26/qt5DWJ2QLUAXAP8ODgYPMU8Jzqz+43sG+ab
   2i3BuCfL9W6p1wl227t3x7BYNUpEKQ9SGXyJ7I1Vva1qrrPgX5aa/so1l
   ESwW4Z5ANtsSi8DDQx1rdZm6UTcUDIKOdEThJUYNGX/4OffQxcuzQzsQc
   1RijYOSFwVdwPNYpGq1ZyRMQGRKz2tWvmJDbz6bWeRTwuOR7iunP6zhSw
   os/mo2kxAfCoESx+Bxe3MWdH5//8rngulai3IB10Jin4jC845FBAjIvl/
   n9rxyEzh/+fQ7ze523Vnav41R+IswzsID7Cm+jlu7HIulcwXOIDqZPPeP
   g==;
X-CSE-ConnectionGUID: DBjUYvGORjK4hbsQUW3Sog==
X-CSE-MsgGUID: H+MPpfHBT5eYjVsZ/1JIKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="91155504"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="91155504"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 08:39:51 -0700
X-CSE-ConnectionGUID: ANmwTY+XTY2H3VDKycWS4A==
X-CSE-MsgGUID: eBDYurDMTGy3tEFYi9ORxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="277728605"
Received: from igk-lkp-server01.igk.intel.com (HELO a88263cc608e) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 25 Sep 2026 08:39:49 -0700
Received: from kbuild by a88263cc608e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xA81a-000000000ni-47ya;
	Fri, 25 Sep 2026 15:39:46 +0000
Date: Fri, 25 Sep 2026 17:38:47 +0200
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: [akpm-mm:mm-new 661/676] ld.lld: error: undefined symbol:
 __check_safe_pte_update
Message-ID: <202609251702.X00bYqkV-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2589c5593c200e5146db848730baa1d7dd0c9f4e
commit: f0284d9baaf7144fa87bc9ef9f3c64ccfd9600e1 [661/676] arm64/mm: move __check_safe_pte_update()
config: arm64-randconfig-r2200-20260925 (https://download.01.org/0day-ci/archive/20260925/202609251702.X00bYqkV-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 7e4b8ae111298941e0c31052a7124ab36f5365b5)
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260925/202609251702.X00bYqkV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609251702.X00bYqkV-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __check_safe_pte_update
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               arch/arm64/mm/mmu.o:(modify_prot_commit_ptes) in archive vmlinux.a
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               arch/arm64/mm/mmu.o:(modify_prot_commit_ptes) in archive vmlinux.a
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               kernel/bpf/arena.o:(apply_range_set_cb) in archive vmlinux.a
   >>> referenced 57 more times

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

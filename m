Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848EC16CD33
	for <mm-commits@vger.kernel.org>; Sat,  2 May 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777743336; cv=none; b=o6FjSvcXHgMhe07wtfzMNogFtqLEnfpVsiDmlPsZQ0ZQuSOB9KhmrCPKy5YJxoxXQG5u32XbuBqQsFo94Eq+IcsPRWDbeYa8+yqo4ejZbaGg0gLBp7djTi1LTlxYs2e/Oup/x+34I3xhkkNwWcHhrxCm7gM3ddk8BqEEqJsBg7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777743336; c=relaxed/simple;
	bh=AesQvQNbjaaC+r2iklMjj4pQICUW0xiAJ95B+t6KN4Q=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TGu4pBQbHTdz54mG2W1ahRZIqfr/CdQilgSmFAQA/OQBWJ+axqXg3zJiuewVCqmcjcb+elyEpoDJoA2dZCNOrX01Y4WyYDnPPqJz4VqUZbEHNjXb0JdEgKXRNOLuDKukK2hWWmQdAWlVg+53mVJlQ3d9EtaPn1liulSAINuZkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ua0yoXp9; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ua0yoXp9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777743334; x=1809279334;
  h=date:from:to:cc:subject:message-id;
  bh=AesQvQNbjaaC+r2iklMjj4pQICUW0xiAJ95B+t6KN4Q=;
  b=Ua0yoXp9874KhVu5sFgiPmIKjCYYBzCTN5GBUnZ1XmwsXJ9pAdIV+QK1
   YQVWk2/IZUFnUCBzOj4sf38W+6hTIQiVDcHDKFTPlsjCVjZqjjAAgBscr
   tkzU/hfOCINis6nKmjChaSFthx41RkW2uijxQGBU22qZYAMDz/EYl9+gT
   3S0INlcW+/Ok/N7jgjDKvJFEktF5For9dIePL6+M5oXwSGboBsTpQmzL8
   6FgEdjiSmfsPaOCk08ldROe0Dslo2nfMwpPIYBaUgA+xmXZKyTFjvu5z7
   uivtkwTbogOx4wgrOZ5l4VaSaGMe+SFC2m7wBlau1BMlX6tB5i8FyEX89
   w==;
X-CSE-ConnectionGUID: 1q/vPadzRcWqzVLdSuzH1A==
X-CSE-MsgGUID: /kF8AtT4SOSSSTSzv2h1IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="78378909"
X-IronPort-AV: E=Sophos;i="6.23,212,1770624000"; 
   d="scan'208";a="78378909"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 10:35:33 -0700
X-CSE-ConnectionGUID: lyl3T18kQl2LF8dzenLlxw==
X-CSE-MsgGUID: H02/k5nKQlag0dTnlEuEdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,212,1770624000"; 
   d="scan'208";a="240114267"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 02 May 2026 10:35:31 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJEFU-000000001gH-146H;
	Sat, 02 May 2026 17:35:28 +0000
Date: Sun, 03 May 2026 01:35:18 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 4272f8035313cadb031cc24f82b2545d78c17c92
Message-ID: <202605030131.IN0OTGzV-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4272f8035313cadb031cc24f82b2545d78c17c92  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202604300401.oBmk76Q3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300638.A3yVzhM3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300817.QeXlZapz-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604302039.yKocJk8m-lkp@intel.com

    arch/openrisc/include/asm/fixmap.h:38:33: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
    arch/riscv/mm/init.c:113:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
    arch/riscv/mm/init.c:235:48: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]
    arch/sh/include/asm/fixmap.h:82:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
    include/asm-generic/fixmap.h:107:26: error: use of undeclared identifier 'PAGE_KERNEL_IO'
    include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function)
    include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function); did you mean 'SI_KERNEL'?
    include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
    include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function); did you mean 'PAGE_KERNEL_READ'?
    include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function); did you mean 'PAGE_KERNEL_RO'?
    include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function); did you mean 'PAGE_KERNEL_ROX'?
    include/asm-generic/fixmap.h:57:24: error: 'PAGE_KERNEL_IO' undeclared (first use in this function)
    include/asm-generic/fixmap.h:57:24: error: 'PAGE_KERNEL_IO' undeclared (first use in this function); did you mean 'PAGE_KERNEL_RO'?
    include/asm-generic/fixmap.h:77:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:77:2: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:84:40: error: use of undeclared identifier 'PAGE_KERNEL'
    include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
    mm/internal.h:847:26: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- arm64-allnoconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- arm64-defconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- arm64-randconfig-001-20260502
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- arm64-randconfig-002-20260502
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- arm64-randconfig-003-20260502
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- arm64-randconfig-004-20260502
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- arm64-randconfig-r053-20260502
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- arm64-randconfig-r112-20260503
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- csky-allmodconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-allnoconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-defconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-001-20260502
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-002-20260502
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r061-20260502
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r073-20260502
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r111-20260503
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r122-20260503
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- loongarch-defconfig
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- loongarch-randconfig-001-20260502
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- loongarch-randconfig-002-20260502
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- microblaze-allnoconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- microblaze-allyesconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- microblaze-defconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- mips-allmodconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allnoconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allyesconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-ath79_defconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-randconfig-r051-20260502
|   |-- include-asm-generic-fixmap.h:error:call-to-undeclared-function-__set_fixmap-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_IO
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- openrisc-allmodconfig
|   |-- arch-openrisc-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- openrisc-allnoconfig
|   |-- arch-openrisc-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- openrisc-defconfig
|   |-- arch-openrisc-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- riscv-allmodconfig
|   |-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|   `-- mm-internal.h:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- riscv-allnoconfig
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- riscv-allyesconfig
|   |-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|   `-- mm-internal.h:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- riscv-defconfig
|   |-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_NOCACHE
|-- riscv-randconfig-001-20260502
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- riscv-randconfig-002-20260502
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|-- sh-allmodconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- sh-allnoconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- sh-allyesconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- sh-defconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- sh-randconfig-001-20260502
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- sh-randconfig-002-20260502
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- xtensa-allyesconfig
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- xtensa-randconfig-002-20260502
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
`-- xtensa-randconfig-r054-20260502
    |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
    |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
    `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap

elapsed time: 1289m

configs tested: 177
configs skipped: 10

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260502    gcc-15.2.0
arc                   randconfig-002-20260502    gcc-10.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260502    clang-23
arm                   randconfig-002-20260502    gcc-10.5.0
arm                   randconfig-003-20260502    gcc-13.4.0
arm                   randconfig-004-20260502    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260502    clang-23
arm64                 randconfig-002-20260502    clang-23
arm64                 randconfig-003-20260502    gcc-8.5.0
arm64                 randconfig-004-20260502    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260502    gcc-13.4.0
csky                  randconfig-002-20260502    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260502    clang-18
hexagon               randconfig-002-20260502    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260502    gcc-14
i386        buildonly-randconfig-002-20260502    gcc-14
i386        buildonly-randconfig-003-20260502    gcc-14
i386        buildonly-randconfig-004-20260502    clang-20
i386        buildonly-randconfig-005-20260502    gcc-14
i386        buildonly-randconfig-006-20260502    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260502    clang-20
i386                  randconfig-002-20260502    gcc-14
i386                  randconfig-003-20260502    gcc-14
i386                  randconfig-004-20260502    gcc-14
i386                  randconfig-005-20260502    gcc-14
i386                  randconfig-006-20260502    clang-20
i386                  randconfig-007-20260502    clang-20
i386                  randconfig-011-20260502    gcc-14
i386                  randconfig-012-20260502    clang-20
i386                  randconfig-013-20260502    gcc-14
i386                  randconfig-014-20260502    clang-20
i386                  randconfig-015-20260502    gcc-14
i386                  randconfig-016-20260502    clang-20
i386                  randconfig-017-20260502    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260502    clang-23
loongarch             randconfig-002-20260502    clang-18
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          ath79_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260502    gcc-11.5.0
nios2                 randconfig-002-20260502    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260502    gcc-12.5.0
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260502    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260502    gcc-9.5.0
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260502    clang-18
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260502    gcc-8.5.0
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260502    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260502    gcc-14.3.0
riscv                 randconfig-002-20260502    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260502    clang-23
s390                  randconfig-002-20260502    gcc-11.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260502    gcc-13.4.0
sh                    randconfig-002-20260502    gcc-12.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260502    gcc-15.2.0
sparc                 randconfig-002-20260502    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260502    clang-23
sparc64               randconfig-002-20260502    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260502    gcc-14
um                    randconfig-002-20260502    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260502    clang-20
x86_64      buildonly-randconfig-002-20260502    gcc-14
x86_64      buildonly-randconfig-003-20260502    clang-20
x86_64      buildonly-randconfig-004-20260502    gcc-14
x86_64      buildonly-randconfig-005-20260502    gcc-14
x86_64      buildonly-randconfig-006-20260502    gcc-14
x86_64                              defconfig    gcc-14
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260502    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260502    clang-20
x86_64                         randconfig-003    clang-20
x86_64                randconfig-003-20260502    clang-20
x86_64                         randconfig-004    clang-20
x86_64                randconfig-004-20260502    clang-20
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260502    gcc-14
x86_64                         randconfig-006    clang-20
x86_64                randconfig-006-20260502    clang-20
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260502    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260502    clang-20
x86_64                randconfig-013-20260502    clang-20
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260502    clang-20
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260502    clang-20
x86_64                         randconfig-016    clang-20
x86_64                randconfig-071-20260502    gcc-14
x86_64                randconfig-072-20260502    gcc-14
x86_64                randconfig-073-20260502    gcc-14
x86_64                randconfig-074-20260502    gcc-14
x86_64                randconfig-075-20260502    gcc-14
x86_64                randconfig-076-20260502    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260502    gcc-8.5.0
xtensa                randconfig-002-20260502    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

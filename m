Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B6B38F236
	for <mm-commits@vger.kernel.org>; Sat,  3 Oct 2026 21:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791063508; cv=none; b=nVk7f+bFyht8hvRBpMuAXJwIvDIM0EUSPkUA+zNsYbsxaUth4asNdRjGSsb86xULHCLLQObojKt1bHHOhF5bcs7cWEFBobly1HSgyyqU5wNO9VEZJY1SCLu22Yid/6qQhSxvXa4IT4NRV6szAkh7umS+vapsSGhKvsK7TxAARAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791063508; c=relaxed/simple;
	bh=cx36rMgiwcPy9oVey3JMSzcMVcknurHX1+JG67Nx9UM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Gk7IkO8L4/IP7yz9gEqFkU7q5zOwkDWEi35h+4MztgDkPOyR42UBDPuMcyqv8720vCYKduoF1GcRsobgoW/f7Vf/mwrcBQS82qLqqc+Mcz4by46i4FvzrHGMHlpqRf2GmuKqeqaqU76B+tZc9c7EcHWjyJ8fBIOnG2pm1rRHWvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZ3A+84f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZ3A+84f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CF21F0089B;
	Sat,  3 Oct 2026 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791063506;
	bh=nL1kFWA02J+CzKH55Qk9oUZtxvNAsf+bQMZwWsLE56M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sZ3A+84fPLBWWkRx+Hr5zV7TJGZtLrxLloOQuHQSZrKaPpIr4KQMjQrMGSDZIGHyU
	 SgO/BonHjH5j4djwzsqJmrPybzn7lri/KzgTjyS5qz3JYR89gUQYCsdRSwTlYRBFl7
	 EnooqbCxAKHuAEunXRZ6xzBEkU13nsK05gHpklt4=
Date: Sat, 3 Oct 2026 14:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 763ad0211c7b587344f03bc4d1299810aeb736f4
Message-Id: <20261003143826.be180aae972aa1e6a24956e7@linux-foundation.org>
In-Reply-To: <202610040408.3LHzXZUE-lkp@intel.com>
References: <202610040408.3LHzXZUE-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 04 Oct 2026 04:27:12 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 763ad0211c7b587344f03bc4d1299810aeb736f4  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Error/Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com
> 
>     drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
>     fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

It would help if these reports told us which tool emitted the warning. 
This one was smatch.


"proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock" has:

	vma_iter_init(&priv->iter, mm, 0);
	vma = proc_get_vma(m, &pos);
	if (unlikely(!vma))
		goto empty_set;

	if (!IS_ERR(vma))
		vma_start = vma->vm_start;

	while (vma) {
		if (IS_ERR(vma)) {
			ret = PTR_ERR(vma);
			goto out_unlock;
		}

The code is funky-looking but I think it correctly handles all three
cases: NULL, IS_ERR, valid vma*.


> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> |-- alpha-randconfig-r2107-20261003
> |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> |-- alpha-randconfig-r2200-20261003
> |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> |-- i386-randconfig-2103-20261003
> |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> |-- nios2-randconfig-r2202-20261003
> |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> |-- powerpc-randconfig-r2201-20261003
> |   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> |-- powerpc64-randconfig-r2101-20261003
> |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> |-- x86_64-randconfig-2100-20261003
> |   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
> `-- x86_64-randconfig-2200-20261003
>     `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
> 
> elapsed time: 882m
> 
> configs tested: 200
> configs skipped: 13
> 
> tested configs:
> alpha                              allnoconfig    gcc-16.1.0
> alpha                             allyesconfig    gcc-16.1.0
> alpha                                defconfig    gcc-16.1.0
> alpha                                defconfig    gcc-16.1.0
> alpha                randconfig-r2105-20261003    gcc-8.5.0  cocci
> alpha                randconfig-r2107-20261003    gcc-8.5.0  cocci
> alpha                randconfig-r2200-20261003    gcc-8.5.0  smatch
> arc                               allmodconfig    gcc-16.1.0
> arc                                allnoconfig    gcc-16.1.0
> arc                               allyesconfig    gcc-16.1.0
> arc                       axs103_smp_defconfig    gcc-16.1.0
> arc                                  defconfig    gcc-16.1.0
> arc                   randconfig-1000-20261003    gcc-13.4.0
> arc                   randconfig-1001-20261003    gcc-11.5.0
> arc                  randconfig-r2100-20261003    gcc-8.5.0  cocci
> arm                                allnoconfig    clang-17
> arm                          at91_dt_defconfig    clang-17
> arm                                  defconfig    clang-24
> arm                   randconfig-1000-20261003    clang-17
> arm                   randconfig-1001-20261003    clang-24
> arm                   randconfig-1002-20261003    gcc-11.5.0
> arm                   randconfig-1003-20261003    gcc-8.5.0
> arm                          wpcm450_defconfig    gcc-16.1.0
> arm64                              allnoconfig    gcc-16.1.0
> arm64                                defconfig    gcc-16.1.0
> arm64                 randconfig-1000-20261003    gcc-10.5.0
> arm64                 randconfig-1001-20261003    clang-17
> arm64                 randconfig-1002-20261003    clang-17
> arm64                 randconfig-1003-20261003    gcc-8.5.0
> arm64                randconfig-r2106-20261003    clang-24   cocci
> csky                              allmodconfig    gcc-16.1.0
> csky                               allnoconfig    gcc-16.1.0
> csky                                 defconfig    gcc-16.1.0
> csky                  randconfig-1000-20261003    gcc-9.5.0
> csky                  randconfig-1001-20261003    gcc-11.5.0
> hexagon                           allmodconfig    clang-24
> hexagon                            allnoconfig    clang-24
> hexagon                              defconfig    clang-24
> hexagon               randconfig-1000-20261003    clang-17
> hexagon               randconfig-1001-20261003    clang-24
> i386                              allmodconfig    gcc-14
> i386                               allnoconfig    gcc-14
> i386        buildonly-randconfig-1000-20261003    gcc-14
> i386        buildonly-randconfig-1001-20261003    clang-22
> i386        buildonly-randconfig-1002-20261003    clang-22
> i386        buildonly-randconfig-1003-20261003    clang-22
> i386        buildonly-randconfig-1004-20261003    clang-22
> i386        buildonly-randconfig-1005-20261003    clang-22
> i386                                 defconfig    clang-22
> i386                  randconfig-1000-20261003    clang-22
> i386                  randconfig-1001-20261003    clang-22
> i386                  randconfig-1002-20261003    clang-22
> i386                  randconfig-1003-20261003    clang-22
> i386                  randconfig-1004-20261003    clang-22
> i386                  randconfig-1005-20261003    clang-22
> i386                  randconfig-1006-20261003    gcc-14
> i386                  randconfig-2100-20261003    gcc-14     cocci
> i386                  randconfig-2101-20261003    clang-22   cocci
> i386                  randconfig-2102-20261003    gcc-14     cocci
> i386                  randconfig-2103-20261003    clang-22   cocci
> i386                  randconfig-2200-20261003    gcc-14     smatch
> i386                  randconfig-2300-20261003    clang-22   sparse
> i386                  randconfig-2301-20261003    gcc-14     sparse
> i386                  randconfig-2302-20261003    gcc-14     sparse
> loongarch                          allnoconfig    clang-20
> loongarch                            defconfig    clang-24
> loongarch             randconfig-1000-20261003    gcc-14.3.0
> loongarch             randconfig-1001-20261003    gcc-16.1.0
> loongarch            randconfig-r2304-20261003    gcc-13.4.0 sparse
> m68k                              allmodconfig    gcc-16.1.0
> m68k                               allnoconfig    gcc-16.1.0
> m68k                              allyesconfig    gcc-16.1.0
> m68k                                 defconfig    gcc-16.1.0
> m68k                         stmark2_defconfig    gcc-16.1.0
> microblaze                         allnoconfig    gcc-16.1.0
> microblaze                        allyesconfig    gcc-16.1.0
> microblaze                           defconfig    gcc-16.1.0
> mips                               allnoconfig    gcc-16.1.0
> mips                              allyesconfig    gcc-16.1.0
> mips                          db1xxx_defconfig    clang-24
> mips                 randconfig-r2102-20261003    gcc-13.4.0 cocci
> mips                 randconfig-r2305-20261003    gcc-8.5.0  sparse
> mips                        rbtx49xx_defconfig    gcc-16.1.0
> nios2                             allmodconfig    gcc-11.5.0
> nios2                              allnoconfig    gcc-11.5.0
> nios2                                defconfig    gcc-11.5.0
> nios2                 randconfig-1000-20261003    gcc-9.5.0
> nios2                 randconfig-1001-20261003    gcc-11.5.0
> nios2                randconfig-r2202-20261003    gcc-8.5.0  smatch
> nios2                randconfig-r2307-20261003    gcc-11.5.0 sparse
> openrisc                          allmodconfig    gcc-16.1.0
> openrisc                           allnoconfig    gcc-16.1.0
> openrisc                             defconfig    gcc-16.1.0
> parisc                            allmodconfig    gcc-16.1.0
> parisc                             allnoconfig    gcc-16.1.0
> parisc                            allyesconfig    gcc-16.1.0
> parisc                               defconfig    gcc-16.1.0
> parisc                randconfig-1000-20261003    gcc-11.5.0
> parisc                randconfig-1001-20261003    gcc-8.5.0
> parisc               randconfig-r2103-20261003    gcc-8.5.0  cocci
> parisc               randconfig-r2306-20261003    gcc-9.5.0  sparse
> parisc64                             defconfig    gcc-16.1.0
> powerpc                            allnoconfig    gcc-16.1.0
> powerpc               randconfig-1000-20261003    gcc-12.5.0
> powerpc               randconfig-1001-20261003    gcc-8.5.0
> powerpc              randconfig-r2201-20261003    clang-17   smatch
> powerpc              randconfig-r2309-20261003    clang-21   sparse
> powerpc64             randconfig-1000-20261003    clang-24
> powerpc64             randconfig-1001-20261003    clang-22
> powerpc64            randconfig-r2101-20261003    gcc-13.4.0 cocci
> riscv                              allnoconfig    gcc-16.1.0
> riscv                                defconfig    clang-24
> riscv                 randconfig-1000-20261003    clang-24
> riscv                 randconfig-1001-20261003    clang-24
> riscv                 randconfig-2000-20261003    clang-17
> riscv                 randconfig-2001-20261003    gcc-9.5.0
> riscv                randconfig-r2308-20261003    gcc-15.2.0 sparse
> s390                              allmodconfig    clang-24
> s390                               allnoconfig    clang-24
> s390                                 defconfig    clang-18
> s390                  randconfig-1000-20261003    gcc-12.5.0
> s390                  randconfig-1001-20261003    clang-24
> s390                  randconfig-2000-20261003    clang-24
> s390                  randconfig-2001-20261003    gcc-13.4.0
> s390                 randconfig-r2104-20261003    clang-17   cocci
> sh                                allmodconfig    gcc-16.1.0
> sh                                 allnoconfig    gcc-16.1.0
> sh                                allyesconfig    gcc-16.1.0
> sh                                   defconfig    gcc-16.1.0
> sh                    randconfig-1000-20261003    gcc-9.5.0
> sh                    randconfig-1001-20261003    gcc-15.2.0
> sh                    randconfig-2000-20261003    gcc-16.1.0
> sh                    randconfig-2001-20261003    gcc-16.1.0
> sh                   randconfig-r2302-20261003    gcc-12.5.0 sparse
> sparc                              allnoconfig    gcc-16.1.0
> sparc                                defconfig    gcc-16.1.0
> sparc                 randconfig-1000-20261003    gcc-8.5.0
> sparc                 randconfig-1001-20261003    gcc-8.5.0
> sparc                 randconfig-2000-20261003    gcc-16.1.0
> sparc                 randconfig-2001-20261003    gcc-16.1.0
> sparc64                           allmodconfig    clang-20
> sparc64                              defconfig    clang-24
> sparc64               randconfig-1000-20261003    gcc-16.1.0
> sparc64               randconfig-1001-20261003    clang-24
> sparc64               randconfig-2000-20261003    gcc-8.5.0
> sparc64               randconfig-2001-20261003    gcc-8.5.0
> um                                allmodconfig    clang-17
> um                                 allnoconfig    clang-17
> um                                allyesconfig    gcc-14
> um                                   defconfig    clang-24
> um                              i386_defconfig    gcc-14
> um                    randconfig-1000-20261003    clang-17
> um                    randconfig-1001-20261003    clang-22
> um                    randconfig-2000-20261003    clang-24
> um                    randconfig-2001-20261003    gcc-14
> um                            x86_64_defconfig    clang-24
> x86_64                             allnoconfig    clang-22
> x86_64      buildonly-randconfig-1000-20261003    clang-22
> x86_64      buildonly-randconfig-1001-20261003    gcc-14
> x86_64      buildonly-randconfig-1002-20261003    clang-22
> x86_64      buildonly-randconfig-1003-20261003    gcc-14
> x86_64      buildonly-randconfig-1004-20261003    clang-22
> x86_64      buildonly-randconfig-1005-20261003    gcc-14
> x86_64                               defconfig    gcc-14
> x86_64                randconfig-1000-20261003    clang-22
> x86_64                randconfig-1001-20261003    clang-22
> x86_64                randconfig-1002-20261003    clang-22
> x86_64                randconfig-1003-20261003    gcc-13
> x86_64                randconfig-1004-20261003    clang-22
> x86_64                randconfig-1005-20261003    clang-22
> x86_64                randconfig-1006-20261003    gcc-14
> x86_64                randconfig-1007-20261003    gcc-14
> x86_64                randconfig-1008-20261003    gcc-14
> x86_64                randconfig-1009-20261003    clang-22
> x86_64                randconfig-1010-20261003    gcc-14
> x86_64                randconfig-1011-20261003    clang-22
> x86_64                randconfig-1012-20261003    clang-22
> x86_64                randconfig-1013-20261003    gcc-12
> x86_64                randconfig-1014-20261003    gcc-14
> x86_64                randconfig-1015-20261003    gcc-14
> x86_64                randconfig-1016-20261003    clang-22
> x86_64                randconfig-1017-20261003    gcc-14
> x86_64                randconfig-2100-20261003    clang-22   cocci
> x86_64                randconfig-2101-20261003    clang-22   cocci
> x86_64                randconfig-2102-20261003    gcc-14     cocci
> x86_64                randconfig-2103-20261003    gcc-13     cocci
> x86_64                randconfig-2200-20261003    gcc-14     smatch
> x86_64                randconfig-2300-20261003    gcc-14     sparse
> x86_64                randconfig-2301-20261003    gcc-14     sparse
> x86_64                randconfig-2302-20261003    clang-22   sparse
> x86_64               randconfig-r2300-20261003    clang-22   sparse
> x86_64               randconfig-r2301-20261003    gcc-14     sparse
> x86_64                           rhel-9.4-rust    clang-22
> xtensa                             allnoconfig    gcc-16.1.0
> xtensa                            allyesconfig    gcc-16.1.0
> xtensa                   nommu_kc705_defconfig    gcc-16.1.0
> xtensa                randconfig-1000-20261003    gcc-15.2.0
> xtensa                randconfig-1001-20261003    gcc-9.5.0
> xtensa                randconfig-2000-20261003    gcc-8.5.0
> xtensa                randconfig-2001-20261003    gcc-10.5.0
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

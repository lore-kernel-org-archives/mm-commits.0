Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D955335BBB
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 05:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780290857; cv=none; b=EQXMIZ+3BQvRkjNQJeJ+0Hjs6gNbMFZUF6egPZ3do7HhOceyQG2rIcwPKFj5nBIE+Qx85osTxWiPMi4MlMeNnsURqLkvBuSvvFSXa+eRMlao7bUBBkHtFtpmnBKtF4431+mHNPF8zAQkdQw6I5fH/g7LYrSeH8zW+Gg9KVbG9MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780290857; c=relaxed/simple;
	bh=XEsSwrxXPnxh14tVWWsBzq/4w2iQD9+xoV501oqp9KE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=vAVNKpYNGPQ41DdC8lAaT+oI0+TqJw1xRZSslPjwc1Yk+YWFL2F7AQyTaMjHql5736zFPMffJQveGDqI/xzjyhwewE6Urlxg+VPzzkU162F8tEZ1QXELMs/WgMafpXDbHzjw1vJRqhwpMSxlr+u42bFNH6RTmyc88vhl4jd3iPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A16G70Py; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A16G70Py"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780290855; x=1811826855;
  h=date:from:to:cc:subject:message-id;
  bh=XEsSwrxXPnxh14tVWWsBzq/4w2iQD9+xoV501oqp9KE=;
  b=A16G70PyucJ6XwlwLrZ6IInu92uAjy4qxY0KMHX4pvA4c/YgJQRPLBkQ
   jbwbl453vh+82g3z2K/DYuW0DB44YWCbQ49b92HFzlqOudnOXyNVo2XGG
   9G83NRMF0ZkFrNULFao5L7Us6k18zcRZyuo+Xe0BQmXB1iC+loKAi5Oc1
   hNqG70vKtWyBtevOPyCK5otUGnuJYXghsXb7orqvcGK+RKSKzZDmF0TEK
   93tpFJGfGCcJtJaC95TxNkqx6ZkBgxm6o/PoKcr580h2X5a1AFLLwAiK+
   dngJOpo+SSRcY9PwMzTmAp/T/oFJeUyrnIo4wUOgIPl7ZwocmeIZqsyF+
   A==;
X-CSE-ConnectionGUID: pkFOXny1SbS0u5qpoh2f9A==
X-CSE-MsgGUID: cu/HjBvsRH2Fvc+4oCG/jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11803"; a="83618056"
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="83618056"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 22:14:14 -0700
X-CSE-ConnectionGUID: WOsBk8fKR4CPbaLd+yYanA==
X-CSE-MsgGUID: GJAwtA1OQbabkRO2KsuETw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="242410366"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 31 May 2026 22:14:12 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTuyX-00000000ACg-3Cr9;
	Mon, 01 Jun 2026 05:14:09 +0000
Date: Mon, 01 Jun 2026 13:13:42 +0800
From: kernel test robot <lkp@intel.com>
To: Qiang Liu <liuqiang@kylinos.cn>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 386/420] lib/test_hmm.c:1170:21: sparse:
 sparse: incorrect type in assignment (different base types)
Message-ID: <202606011329.zWs2BKy4-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   d97bc98dadda29f23540b8490592962ebcf545ff
commit: d4ab4875497b1659c6c56dd9faefcb4a41c566e4 [386/420] lib/test_hmm: check alloc_page_vma() return value and handle OOM
config: s390-randconfig-r111-20260601 (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/test_hmm.c:1170:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted vm_fault_t @@
   lib/test_hmm.c:1170:21: sparse:     expected int [assigned] ret
   lib/test_hmm.c:1170:21: sparse:     got restricted vm_fault_t

vim +1170 lib/test_hmm.c

  1119	
  1120	static int dmirror_migrate_to_system(struct dmirror *dmirror,
  1121					     struct hmm_dmirror_cmd *cmd)
  1122	{
  1123		unsigned long start, end, addr;
  1124		unsigned long size = cmd->npages << PAGE_SHIFT;
  1125		struct mm_struct *mm = dmirror->notifier.mm;
  1126		struct vm_area_struct *vma;
  1127		struct migrate_vma args = { 0 };
  1128		unsigned long next;
  1129		int ret;
  1130		unsigned long *src_pfns;
  1131		unsigned long *dst_pfns;
  1132	
  1133		src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
  1134		dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
  1135	
  1136		start = cmd->addr;
  1137		end = start + size;
  1138		if (end < start)
  1139			return -EINVAL;
  1140	
  1141		/* Since the mm is for the mirrored process, get a reference first. */
  1142		if (!mmget_not_zero(mm))
  1143			return -EINVAL;
  1144	
  1145		cmd->cpages = 0;
  1146		mmap_read_lock(mm);
  1147		for (addr = start; addr < end; addr = next) {
  1148			vma = vma_lookup(mm, addr);
  1149			if (!vma || !(vma->vm_flags & VM_READ)) {
  1150				ret = -EINVAL;
  1151				goto out;
  1152			}
  1153			next = min(end, addr + (PTRS_PER_PTE << PAGE_SHIFT));
  1154			if (next > vma->vm_end)
  1155				next = vma->vm_end;
  1156	
  1157			args.vma = vma;
  1158			args.src = src_pfns;
  1159			args.dst = dst_pfns;
  1160			args.start = addr;
  1161			args.end = next;
  1162			args.pgmap_owner = dmirror->mdevice;
  1163			args.flags = dmirror_select_device(dmirror) | MIGRATE_VMA_SELECT_COMPOUND;
  1164	
  1165			ret = migrate_vma_setup(&args);
  1166			if (ret)
  1167				goto out;
  1168	
  1169			pr_debug("Migrating from device mem to sys mem\n");
> 1170			ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
  1171			if (ret) {
  1172				migrate_vma_finalize(&args);
  1173				goto out;
  1174			}
  1175	
  1176			migrate_vma_pages(&args);
  1177			cmd->cpages += dmirror_successful_migrated_pages(&args);
  1178			migrate_vma_finalize(&args);
  1179		}
  1180	out:
  1181		mmap_read_unlock(mm);
  1182		mmput(mm);
  1183		kvfree(src_pfns);
  1184		kvfree(dst_pfns);
  1185	
  1186		return ret;
  1187	}
  1188	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

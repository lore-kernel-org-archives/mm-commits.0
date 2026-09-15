Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95E1440629
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501147; cv=none; b=CRbCSeeYZgh5Qk7+qFyZ1EKiCyra8BYF/ccJ48jgg+u9f5tSj+WZgv4g7Hq4/wcRw9I2Nku9GPWKIStRbVM72SDG1rCqA0VXNHK3Hy6sT4JGCCGnBfWNUoLSdJSZpfSMwR316WqwBPiQCYUZ4zAYaKGBQIUBTtgpGNFYIyNGSGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501147; c=relaxed/simple;
	bh=mpETyrPnt2gx6qCCDWHtDXB7qf63CTS6QqeY1voYvjw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Tu7f93Ck+oGfnRsyQGY/wBVry/oCW00a9jzU1hByC1ffJFO4MPCGqcwCXJZeKWLeTKrXUj+Nms1F0e3z34Q5uFCCqQyPsV+bxykatq+PD4oa85Wlr2HHLhhiBmX0qZiswunKfvxnP0nzqQeUwimbRgvG8jPxiM7u/sIVI+TPtu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NIaQ59CV; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NIaQ59CV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789501146; x=1821037146;
  h=date:from:to:cc:subject:message-id;
  bh=mpETyrPnt2gx6qCCDWHtDXB7qf63CTS6QqeY1voYvjw=;
  b=NIaQ59CVE/KX+jDAi/Ly+Ht1j41HaR/vhbGIWU0uiFViQnwx6bl/jdy1
   +sIxOl9wW4idAjdAcxUQs00AqgF43G1bhiduxsCpa03T9OpjOiaRk1hxk
   S0RmOR7v4kYjJRQwKotNWfhfPRWtxzNrauZVN7PvZxds7BdzEmizSgG3c
   UeUGWkjgE/6igxtGXnj5pt870HAC9HAaHdsLO5vW25i4KHsHVFQcmX0+y
   7aP6GGOjpqpmfy767qg2H0ti2HHHlzYynrdagZ54DO5AW/28/ltNecGfI
   2ZjHwBd6igf9Lpmnghiqu7LEBCd5IJ7dvhPWAo1gJR/BsnzzhGERWq1Z9
   Q==;
X-CSE-ConnectionGUID: b2+Qo0+KQ8m/Xg0eATP+/g==
X-CSE-MsgGUID: +7B75EpdTrqT/PgasWBVJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89747451"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89747451"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 12:39:05 -0700
X-CSE-ConnectionGUID: 55YOG7vVTZOT4E7dkgfKvg==
X-CSE-MsgGUID: ewrPQrfwQLCfajMLxDFxDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="298166415"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 15 Sep 2026 12:39:02 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6Yzb-00000000501-3oSK;
	Tue, 15 Sep 2026 19:38:59 +0000
Date: Wed, 16 Sep 2026 03:38:32 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 478/560] fs/proc/task_mmu.c:3448:3: error:
 implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'?
Message-ID: <202609160337.WJiD9BqX-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   b08a65b93426d86e3f354d655d6225397b591877
commit: 35ba620bfe7feb76c85e06b9ea72c188e1e6e318 [478/560] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
config: riscv-randconfig-002-20260915 (https://download.01.org/0day-ci/archive/20260916/202609160337.WJiD9BqX-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260916/202609160337.WJiD9BqX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/proc/task_mmu.c: In function 'show_numa_map':
>> fs/proc/task_mmu.c:3448:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
      drop_rcu(proc_priv);
      ^~~~~~~~
      drop_slab
>> fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
      reacquire_rcu(proc_priv);
      ^~~~~~~~~~~~~
      get_file_rcu
   At top level:
   fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
    static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
               ^~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +3448 fs/proc/task_mmu.c

ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3400  
f69ff943df6972 Stephen Wilson     2011-05-24  3401  /*
f69ff943df6972 Stephen Wilson     2011-05-24  3402   * Display pages allocated per node and memory policy via /proc.
f69ff943df6972 Stephen Wilson     2011-05-24  3403   */
871305bb202808 Vlastimil Babka    2018-08-21  3404  static int show_numa_map(struct seq_file *m, void *v)
f69ff943df6972 Stephen Wilson     2011-05-24  3405  {
5b52fc890bece7 Stephen Wilson     2011-05-24  3406  	struct numa_maps_private *numa_priv = m->private;
5b52fc890bece7 Stephen Wilson     2011-05-24  3407  	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
f69ff943df6972 Stephen Wilson     2011-05-24  3408  	struct vm_area_struct *vma = v;
5b52fc890bece7 Stephen Wilson     2011-05-24  3409  	struct numa_maps *md = &numa_priv->md;
f69ff943df6972 Stephen Wilson     2011-05-24  3410  	struct file *file = vma->vm_file;
f69ff943df6972 Stephen Wilson     2011-05-24  3411  	struct mm_struct *mm = vma->vm_mm;
948927ee9e4f35 David Rientjes     2013-11-12  3412  	char buffer[64];
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3413  	struct mempolicy *pol;
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3414  	pgoff_t ilx;
948927ee9e4f35 David Rientjes     2013-11-12  3415  	int nid;
f69ff943df6972 Stephen Wilson     2011-05-24  3416  
f69ff943df6972 Stephen Wilson     2011-05-24  3417  	if (!mm)
f69ff943df6972 Stephen Wilson     2011-05-24  3418  		return 0;
f69ff943df6972 Stephen Wilson     2011-05-24  3419  
5b52fc890bece7 Stephen Wilson     2011-05-24  3420  	/* Ensure we start with an empty set of numa_maps statistics. */
5b52fc890bece7 Stephen Wilson     2011-05-24  3421  	memset(md, 0, sizeof(*md));
f69ff943df6972 Stephen Wilson     2011-05-24  3422  
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3423  	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
498f237178a3d3 Oleg Nesterov      2014-10-09  3424  	if (pol) {
948927ee9e4f35 David Rientjes     2013-11-12  3425  		mpol_to_str(buffer, sizeof(buffer), pol);
f69ff943df6972 Stephen Wilson     2011-05-24  3426  		mpol_cond_put(pol);
498f237178a3d3 Oleg Nesterov      2014-10-09  3427  	} else {
498f237178a3d3 Oleg Nesterov      2014-10-09  3428  		mpol_to_str(buffer, sizeof(buffer), proc_priv->task_mempolicy);
498f237178a3d3 Oleg Nesterov      2014-10-09  3429  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3430  
f69ff943df6972 Stephen Wilson     2011-05-24  3431  	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
f69ff943df6972 Stephen Wilson     2011-05-24  3432  
f69ff943df6972 Stephen Wilson     2011-05-24  3433  	if (file) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3434  		seq_puts(m, " file=");
08582d678fcf11 Amir Goldstein     2023-10-09  3435  		seq_path(m, file_user_path(file), "\n\t= ");
11250fd12eb8a5 Kefeng Wang        2023-07-28  3436  	} else if (vma_is_initial_heap(vma)) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3437  		seq_puts(m, " heap");
11250fd12eb8a5 Kefeng Wang        2023-07-28  3438  	} else if (vma_is_initial_stack(vma)) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3439  		seq_puts(m, " stack");
f69ff943df6972 Stephen Wilson     2011-05-24  3440  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3441  
fc360bd9cdcf87 Andrew Morton      2011-10-31  3442  	if (is_vm_hugetlb_page(vma))
17c2b4ee40beae Fabian Frederick   2014-06-06  3443  		seq_puts(m, " huge");
fc360bd9cdcf87 Andrew Morton      2011-10-31  3444  
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3445  	/* Skip walking pages if gate VMA */
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3446  	if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3447  		/* Might sleep. Drop RCU read lock but keep the VMA locked. */
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25 @3448  		drop_rcu(proc_priv);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3449  		walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25 @3450  		reacquire_rcu(proc_priv);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3451  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3452  
f69ff943df6972 Stephen Wilson     2011-05-24  3453  	if (!md->pages)
f69ff943df6972 Stephen Wilson     2011-05-24  3454  		goto out;
f69ff943df6972 Stephen Wilson     2011-05-24  3455  
f69ff943df6972 Stephen Wilson     2011-05-24  3456  	if (md->anon)
f69ff943df6972 Stephen Wilson     2011-05-24  3457  		seq_printf(m, " anon=%lu", md->anon);
f69ff943df6972 Stephen Wilson     2011-05-24  3458  
f69ff943df6972 Stephen Wilson     2011-05-24  3459  	if (md->dirty)
f69ff943df6972 Stephen Wilson     2011-05-24  3460  		seq_printf(m, " dirty=%lu", md->dirty);
f69ff943df6972 Stephen Wilson     2011-05-24  3461  
f69ff943df6972 Stephen Wilson     2011-05-24  3462  	if (md->pages != md->anon && md->pages != md->dirty)
f69ff943df6972 Stephen Wilson     2011-05-24  3463  		seq_printf(m, " mapped=%lu", md->pages);
f69ff943df6972 Stephen Wilson     2011-05-24  3464  
f69ff943df6972 Stephen Wilson     2011-05-24  3465  	if (md->mapcount_max > 1)
f69ff943df6972 Stephen Wilson     2011-05-24  3466  		seq_printf(m, " mapmax=%lu", md->mapcount_max);
f69ff943df6972 Stephen Wilson     2011-05-24  3467  
f69ff943df6972 Stephen Wilson     2011-05-24  3468  	if (md->swapcache)
f69ff943df6972 Stephen Wilson     2011-05-24  3469  		seq_printf(m, " swapcache=%lu", md->swapcache);
f69ff943df6972 Stephen Wilson     2011-05-24  3470  
f69ff943df6972 Stephen Wilson     2011-05-24  3471  	if (md->active < md->pages && !is_vm_hugetlb_page(vma))
f69ff943df6972 Stephen Wilson     2011-05-24  3472  		seq_printf(m, " active=%lu", md->active);
f69ff943df6972 Stephen Wilson     2011-05-24  3473  
f69ff943df6972 Stephen Wilson     2011-05-24  3474  	if (md->writeback)
f69ff943df6972 Stephen Wilson     2011-05-24  3475  		seq_printf(m, " writeback=%lu", md->writeback);
f69ff943df6972 Stephen Wilson     2011-05-24  3476  
948927ee9e4f35 David Rientjes     2013-11-12  3477  	for_each_node_state(nid, N_MEMORY)
948927ee9e4f35 David Rientjes     2013-11-12  3478  		if (md->node[nid])
948927ee9e4f35 David Rientjes     2013-11-12  3479  			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
198d1597cc5a12 Rafael Aquini      2015-02-12  3480  
198d1597cc5a12 Rafael Aquini      2015-02-12  3481  	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
f69ff943df6972 Stephen Wilson     2011-05-24  3482  out:
f69ff943df6972 Stephen Wilson     2011-05-24  3483  	seq_putc(m, '\n');
f69ff943df6972 Stephen Wilson     2011-05-24  3484  	return 0;
f69ff943df6972 Stephen Wilson     2011-05-24  3485  }
5b52fc890bece7 Stephen Wilson     2011-05-24  3486  

:::::: The code at line 3448 was first introduced by commit
:::::: ea3085dd7a4ec212d6c4b50efca584e0928caa72 fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock

:::::: TO: Suren Baghdasaryan <surenb@google.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE3637C926
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779229101; cv=none; b=FlNUam6KJc+VTeJC77TZ+dabhaeimxJ5VFqAO2N9JPBaN0uZEieVEO4TOTsFMx/O91tFhQKUfIXlhVkOQyDHYC/aFNxamibFkkGg147TKWNhYgWXZvQH8TjsxRqEN5ESo9jgZgcQ1GshOrlC6HPqlrq8h8bI8elZv83MCb3tgEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779229101; c=relaxed/simple;
	bh=46cIP13NjFBNXD5ScduW0fUCMXqT/+0j1cSD/FS2JYk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=LCkAlIbeK6fW11Hbty90mb4h4FAySOJdIENlmX9wDelgsQ52Ei6W/uYKb8Y8xGz4opOIylbLHjGnD6ufxt6jfiZz72raURgsZkTqoaA98ywHva29PazPaWrN4d/qK3qi9ofK1HlwKdKsOgkiVOM9PMzOI5Ge1r8gqlLqD0V6T2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P5zzwo6h; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5zzwo6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779229100; x=1810765100;
  h=date:from:to:cc:subject:message-id;
  bh=46cIP13NjFBNXD5ScduW0fUCMXqT/+0j1cSD/FS2JYk=;
  b=P5zzwo6hUIWOLTZpKBhD/200YZ2Zrm+e5L4HEgGdZziwUs4m1vmFiXU0
   jrJJFhiHm4HotqZeLNIaoiuaNOF31YDOVVjSVx5veEIWm2/r328Pvq5ds
   +h15jwUyyJGiGbDkxCxcY0IBLJFkVcPZ1i9qmoAoyV5f0hrdyAVJNf061
   5+9lUrH1z6PE0dja8DTv4Ok2oX4lToYoZt6fSHuvWUCH1t66AsAl9+WoY
   hodU9Y0jbd4QLEsRwS7UHjmoo2s2TrzoVmdVNcOuokRhII7qhZoiL1d59
   xCY3Ih307Brik8RQOcJxmFvWXbuCJSiHjwovDvufSWFYet6dlKj0WpV52
   w==;
X-CSE-ConnectionGUID: IQmUEAh5QiqsddrhKwoAtQ==
X-CSE-MsgGUID: GmPhNtnfQvSW1zwyxneP+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="91516186"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="91516186"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 15:18:20 -0700
X-CSE-ConnectionGUID: FmZePiX/Rjq5BxipSG+Cvw==
X-CSE-MsgGUID: ImB/UQGwQZutYpLm2gfFUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="238922409"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 19 May 2026 15:18:17 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPSlE-0000000021T-06ZY;
	Tue, 19 May 2026 22:18:07 +0000
Date: Wed, 20 May 2026 06:16:25 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <kasong@tencent.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-ID: <202605200624.e9eMvkBW-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memcontrol-v1.c: In function '__memcg1_swapout':
>> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
     651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
         |                               ^~~~~~~~~~~~~~~~~~


vim +/swp_cluster_offset +651 mm/memcontrol-v1.c

   606	
   607	/**
   608	 * __memcg1_swapout - transfer a memsw charge to swap
   609	 * @folio: folio whose memsw charge to transfer
   610	 * @ci: the locked swap cluster holding the swap entries
   611	 *
   612	 * Transfer the memsw charge of @folio to the swap entry stored in
   613	 * folio->swap.
   614	 *
   615	 * Context: folio must be isolated, unmapped, locked and is just about to
   616	 * be freed, and caller must disable IRQs and hold the swap cluster lock.
   617	 */
   618	void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
   619	{
   620		struct mem_cgroup *memcg, *swap_memcg;
   621		struct obj_cgroup *objcg;
   622		unsigned int nr_entries;
   623	
   624		VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
   625		VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
   626		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
   627		VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
   628	
   629		if (mem_cgroup_disabled())
   630			return;
   631	
   632		if (!do_memsw_account())
   633			return;
   634	
   635		objcg = folio_objcg(folio);
   636		VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
   637		if (!objcg)
   638			return;
   639	
   640		rcu_read_lock();
   641		memcg = obj_cgroup_memcg(objcg);
   642		/*
   643		 * In case the memcg owning these pages has been offlined and doesn't
   644		 * have an ID allocated to it anymore, charge the closest online
   645		 * ancestor for the swap instead and transfer the memory+swap charge.
   646		 */
   647		nr_entries = folio_nr_pages(folio);
   648		swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
   649		mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
   650	
 > 651		__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
   652				  mem_cgroup_private_id(swap_memcg));
   653	
   654		folio_unqueue_deferred_split(folio);
   655		folio->memcg_data = 0;
   656	
   657		if (!obj_cgroup_is_root(objcg))
   658			page_counter_uncharge(&memcg->memory, nr_entries);
   659	
   660		if (memcg != swap_memcg) {
   661			if (!mem_cgroup_is_root(swap_memcg))
   662				page_counter_charge(&swap_memcg->memsw, nr_entries);
   663			page_counter_uncharge(&memcg->memsw, nr_entries);
   664		}
   665	
   666		/*
   667		 * The caller must hold the swap cluster lock with IRQ off. It is
   668		 * important here to have the interrupts disabled because it is the
   669		 * only synchronisation we have for updating the per-CPU variables.
   670		 */
   671		preempt_disable_nested();
   672		VM_WARN_ON_IRQS_ENABLED();
   673		memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
   674		preempt_enable_nested();
   675		memcg1_check_events(memcg, folio_nid(folio));
   676	
   677		rcu_read_unlock();
   678		obj_cgroup_put(objcg);
   679	}
   680	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

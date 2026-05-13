Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B400939099A
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778672966; cv=none; b=u/eTikEscxmk6BlLIg/UsIkqqq2wy4x04aXkM4LcRHDAMEOhPkqmfn8FiBSEVtCkMSXqKy/pN6hYHzWDQSPz7xm5EfnKdgO5bQAK8RdjBHIZka0AVa3FnypkdCNyOEtwUlPRa9cyzFrRXxPMZhlBc4U52mfWPzQBCHXkN4d7ybU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778672966; c=relaxed/simple;
	bh=u7jv4jN6Lh/mir8HFqotaq2V3/BMrw/PzxsSJsaVNNc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=A6T2gPxsi3I8bkK6CbGi9a3ivUuh3cg/bCCk7vzqvWpaLSAkXAhVrezXrC1LzxuYRL+HLRiBkH4QGpu0pjS7iheG70dk6zr9Pka67eE+rexHwpbqc996AvoKU1UR27RNsln4j9cS2JudQEq/ocACnUpKyJBz0GeFINV8tPO3Ddg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dz5Ej52m; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dz5Ej52m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778672965; x=1810208965;
  h=date:from:to:cc:subject:message-id;
  bh=u7jv4jN6Lh/mir8HFqotaq2V3/BMrw/PzxsSJsaVNNc=;
  b=Dz5Ej52maaOksRqrr+3B+zwL39BbB3TOzwTjh4BHtKFEns/iZ5R3htkn
   zQWYXHKUKjHjBI6rQbBmYeEbb1ozolgAGFNaTK5VeOvpaWOTBJvuXNPQL
   z6Zuiur665xSSRS1hZW8aU6v483N/QF1/BF6UoLzOPQ4KvY6fJo/LntEd
   JRtCYL6e6qpSMhh0Ah7zgS4AxazYKHzuIvCOtrjngQnyMjDkxrNus5P1E
   Xu4vX/iNfXk/HjtKFzzsEV8qFwn1UJFOTr17cF5WQm+p2/J4cM5720Nwo
   nUmOyuvicFbT2bMs9AbMJx8tPtCDEViZ+w30o545FVKsyjWTHAHpcRk8+
   A==;
X-CSE-ConnectionGUID: 61mOVP0wQsCs7gL8pgsN2A==
X-CSE-MsgGUID: BwTJDZEQRBOwL0V6MfUvtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="90176992"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="90176992"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 04:49:25 -0700
X-CSE-ConnectionGUID: NLQtFxtQStqkjVPz3lc95g==
X-CSE-MsgGUID: YO4mpxTHQaSHtjsav0r4xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="238309793"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 13 May 2026 04:49:22 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wN85X-0000000041D-1TiE;
	Wed, 13 May 2026 11:49:19 +0000
Date: Wed, 13 May 2026 19:48:25 +0800
From: kernel test robot <lkp@intel.com>
To: Minchan Kim <minchan@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-ID: <202605131940.kEzvUaiR-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2c3f468717231305523ddcd94d91c0d5e4a72419
commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
     922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
         |            ^~~~~~~~~~~~~~~~~~


vim +/kill_all_shared_mm +922 mm/oom_kill.c

   912	
   913	/*
   914	 * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
   915	 * @victim: the targeted OOM process group leader
   916	 * @mm:     the virtual memory space being reaped
   917	 *
   918	 * Traverse all threads globally and signal any user processes sharing the identical
   919	 * mm footprints, ensuring no concurrent users pin the memory. Skips the system
   920	 * global init and kernel worker threads.
   921	 */
 > 922	static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
   923	{
   924		struct task_struct *p;
   925		bool failed = false;
   926	
   927		rcu_read_lock();
   928		for_each_process(p) {
   929			if (!process_shares_mm(p, mm))
   930				continue;
   931			if (is_global_init(p)) {
   932				failed = true;
   933				continue;
   934			}
   935			if (unlikely(p->flags & PF_KTHREAD))
   936				continue;
   937	
   938			if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
   939				failed = true;
   940		}
   941		rcu_read_unlock();
   942	
   943		return failed ? -EBUSY : 0;
   944	}
   945	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

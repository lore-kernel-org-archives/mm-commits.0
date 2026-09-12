Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46617478E3E
	for <mm-commits@vger.kernel.org>; Sat, 12 Sep 2026 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216861; cv=none; b=NIxI1Hsh5AHd/QaaqadKjI8dnzpPz8nJFaR46miZCkBu++CKkV4qcHUMXpr29yrfWMwPXZhrNM62pPvzGW8Wdh6hf1i1Yf4cQGvXHq/oQOKul9M0/coZsFa2Y65VQW6UkxYKPjtMJOBY9+CxrztO0/enNpZq4/e6EB/XhDW4cG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216861; c=relaxed/simple;
	bh=7lectQIPGXCgCOBPrkZyTB4t+CqQCOILs57H2YCieVM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Utlk6bF+jlEU0GD7WKIQOSWXMDIfcHL0VGTkPtmW2W7564EJNEs+J8/kiZ/UyrKzr/NFTdQMhlA13V/dXTtONDu6x/YsV0P4VRme1EzBugl18GW4Y4xAQSS6hXbwr45HXcu4/oFNq/DDbi5t7hAWakoeWnpH1GxTzJO9oCXt8WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DpkIGfIU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DpkIGfIU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789216859; x=1820752859;
  h=date:from:to:cc:subject:message-id;
  bh=7lectQIPGXCgCOBPrkZyTB4t+CqQCOILs57H2YCieVM=;
  b=DpkIGfIUxtrNAEzsR09tU6QJzq65JgJjsFaeoNgDtTdlW8Xw/nyWSDOk
   18iz74IzPYF5YS9TQIREyr6zXQbEyBNE4ArT4OiDsgx20PT254/CsOjHk
   jr/sWoQKHXCBkAplIEhbms0GTqFlXriw9A8d/CexP4go0Bz6x1vRtHkwV
   BsW0cB2nhFcLF+RsmdgrXTxSY6OPfkSDJTqsRL+dXamS21dfhLOxhyW3N
   7pZGtRplWRuH4slolxygqxSsP0c4vJZ3cAXvCbse0UaLlKKRq1ILuX4qd
   CqtxTZ4VHWghGB0abYdLg3/YdvGq2EHS4BAmQnls42GCFmy6JEWpyV7TY
   A==;
X-CSE-ConnectionGUID: amVC0TcJSz+8yspKiRqH5A==
X-CSE-MsgGUID: 9CwMAt3YSdGPxeZw5gRYbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="107167700"
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="107167700"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 05:40:58 -0700
X-CSE-ConnectionGUID: R+f6GkJhSQyCkNeJ8fuaOQ==
X-CSE-MsgGUID: fTuW5ZLiQf2bOazhZPgjdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="268485128"
Received: from igk-lkp-server01.igk.intel.com (HELO 2232cf45ba3c) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 12 Sep 2026 05:40:56 -0700
Received: from kbuild by 2232cf45ba3c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5N2M-0000000016B-0vdA;
	Sat, 12 Sep 2026 12:40:54 +0000
Date: Sat, 12 Sep 2026 14:39:55 +0200
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 "Liam R. Howlett (Oracle)" <liam@infradead.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [akpm-mm:mm-new 439/459] fs/proc/task_mmu.c:205:13: warning:
 'reacquire_rcu' defined but not used
Message-ID: <202609121422.hkKWuy7K-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   383fc05d4650b021f3c17e36a145106dcc61a294
commit: 2a61a4b80dc01581dc9f6935eedefbd596e77409 [439/459] proc/task_mmu: remove unnecessary inlines in function definitions
config: openrisc-randconfig-r053-20260912 (https://download.01.org/0day-ci/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/proc/task_mmu.c:205:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]
     205 | static void reacquire_rcu(struct proc_maps_private *priv)
         |             ^~~~~~~~~~~~~
>> fs/proc/task_mmu.c:197:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
     197 | static void drop_rcu(struct proc_maps_private *priv)
         |             ^~~~~~~~
   fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
     133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
         |            ^~~~~~~~~~~


vim +/reacquire_rcu +205 fs/proc/task_mmu.c

   196	
 > 197	static void drop_rcu(struct proc_maps_private *priv)
   198	{
   199		if (priv->lock_ctx.mmap_locked)
   200			return;
   201	
   202		rcu_read_unlock();
   203	}
   204	
 > 205	static void reacquire_rcu(struct proc_maps_private *priv)
   206	{
   207		if (priv->lock_ctx.mmap_locked)
   208			return;
   209	
   210		rcu_read_lock();
   211		/* Reinitialize the iterator. */
   212		vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
   213	}
   214	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

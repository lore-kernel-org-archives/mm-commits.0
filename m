Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4652E32720D
	for <mm-commits@vger.kernel.org>; Fri,  3 Jul 2026 08:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067526; cv=none; b=cLgOcDuMYdbbsK4mWwNeuMHuxPxnlkdFag78vAldTz4CwkuoqwbxwXLorxJqTdN0iDKiUC0baIjJ8P3fruNCDa/dh+8YId7pv9+s/wehCvh6ok4DXS1Ywfkhk2+A5XFUF13IHLPlQaLn3GpkhA1WRzFL7pTGjRMVCWDEcg5r8L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067526; c=relaxed/simple;
	bh=tmEvE928znH8qNFZmFA9+hqKVw8A78urxl5SprV9/2A=;
	h=Date:From:To:Cc:Subject:Message-ID; b=WRwLeHst5OW7rbg5bvv4xf41o1XXln8PV7QNVJfw222DDov46MQsrCpwQmRpjFlJtjU7xX+vrnCT9q/lu1PXCFbG7vrAeP3liIRzOOk9za0ivAEfbYNJRyxBeksj2WSX+n8UnQvjXEYDv+hunDnCi/RxsVyEYShazfzyiYHTUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eFozm25M; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eFozm25M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783067524; x=1814603524;
  h=date:from:to:cc:subject:message-id;
  bh=tmEvE928znH8qNFZmFA9+hqKVw8A78urxl5SprV9/2A=;
  b=eFozm25MVtGkMqKFPqjnS7HsTODq0My8nGptlB7oYFMHbN9E/o57rZcW
   4NUfRu89NiZlYdGkESYufkHFS3YgpKfcrpVcmbxTMfmfICMqFVu6jvlI6
   UVU6vlOaQA7uwNvvnWzMjcVSmAR/NrjeS2Cq8tQpLom37XWg7dkbp7Df8
   gORA/KNT+xSVNi4FNhG5WwVgjO0HZ9L+I7nglh+PS5FtbEhrGk/1f88ue
   uZ7IvPGnCUnAae1haDlaYlOW5phIkOH8zf3HcR3VK0WXsgkALOVD0sIIa
   Po7kKfRS9ySQNzJEQjcg94YwP4Q+oUnoWOV0zd/KRPK2zBMnRqHaTbjYQ
   w==;
X-CSE-ConnectionGUID: ofWZVBJ1Sw6Dlt50KQZL9Q==
X-CSE-MsgGUID: +MYo2f82Sou0ua5Zgsyx/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="83852769"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="83852769"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 01:32:04 -0700
X-CSE-ConnectionGUID: 03LZJP41SLaCC+oO1VZ0zw==
X-CSE-MsgGUID: 9cNI3tVrTpa7JRE8fDZIvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="249090055"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 03 Jul 2026 01:32:01 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfZJW-000000001SH-1ObJ;
	Fri, 03 Jul 2026 08:31:58 +0000
Date: Fri, 03 Jul 2026 10:30:59 +0200
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 242/252] radix-tree.c:459:17: error:
 implicit declaration of function 'kmemleak_transient_leak'
Message-ID: <202607031019.AffpLUyg-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e031e55776cf9193b4720a253e92539ca536d224
commit: 58b5601b28c144be1905eef7964bfa8457f58292 [242/252] radix-tree: fix kmemleak false positives on tree head reassignment
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607031019.AffpLUyg-lkp@intel.com/

All errors (new ones prefixed by >>):

   radix-tree.c: In function 'radix_tree_extend':
>> radix-tree.c:459:17: error: implicit declaration of function 'kmemleak_transient_leak' [-Wimplicit-function-declaration]
     459 |                 kmemleak_transient_leak(node);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

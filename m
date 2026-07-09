Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966FD404BDA
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591238; cv=none; b=p2D5fviHl2B1ZFk+QkpdR0aK8f7pN9dr3Ze0U5mYWS0/3PqVVd2KX7kIAjYRLIePrmIW7B6noQVv2XWPv71ltgrBJFmldqBjO/kW5YaCXyp2v/OvfhKFbkduxsEkyKxhUBtqjcOObqIcHuDFOsKFwCze5DTWP0hjSJLVLk+xAeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591238; c=relaxed/simple;
	bh=0cJoZC+qaLhu9Bg6i+Ath8h0hHRAV8J8wL90JZ+AZZE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=laMMLOp+N9HXuV5qMD2dPS2K/vUb5+Xzxja34Of4nrflEApYKKfaz4ZVeTbHS4xLQcBd17WlYXTTo6WVIqGv2qPFzGGvRo7+7WtVnJO54oRxeqo1FZQh2P5LLASovam+6Dr66j7YjAb4mdwkT1FHfUmMvRbnMisnbpoRbNRzlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXSI5eSx; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXSI5eSx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783591237; x=1815127237;
  h=date:from:to:cc:subject:message-id;
  bh=0cJoZC+qaLhu9Bg6i+Ath8h0hHRAV8J8wL90JZ+AZZE=;
  b=PXSI5eSx9sW4FQno5+KNI/j7xyFDgOQtXRB2iuGLmO8FCU93WVRBwJ3Q
   R0/pYFXoiBC7wKjALOni6jwoap2OLqe2YbssWgLlGRZE8YMiycsfm4oC5
   WLreIJWMQZ+cvyQclfpxkXHpKuXEC9Zl008m5swsKUsDfljmbJFBa4BZf
   Ft4h0g0bafkV8Dz6EfW5fpSNGqsRNTcM8mhGRYKnhrT0lWvmIEeLq+IcX
   tt1hUt6j/1A0XL30yLc2rx8m3YFqDZK71PUYrV0wRBNHCIq8XEx8SbwjX
   wxkFtgzrfNDBWiSWAEKYoRK1EMNGhph9oS8iiCNPRX/5L9/jCC+Ujfg3K
   w==;
X-CSE-ConnectionGUID: uI0ngRgkTjW1TUOfvRqysg==
X-CSE-MsgGUID: /B51OpRqTjq4L19uYwR/mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71787462"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71787462"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:00:36 -0700
X-CSE-ConnectionGUID: OmH+vFaKQ8ehc0En6Au0aQ==
X-CSE-MsgGUID: ZKk3Lb4bQzOcoydwEY77DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258845039"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 09 Jul 2026 03:00:34 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whlYU-00000000HX9-3zxq;
	Thu, 09 Jul 2026 10:00:30 +0000
Date: Thu, 09 Jul 2026 17:59:52 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error:
 implicit declaration of function 'compat_ptr'
Message-ID: <202607091820.qbjlGhKK-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   59e34180e138a293260301c139cf7ee800978533
commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: add ioctl to /proc/allocinfo
config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
>> mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]
     356 |         return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
         |                                                          ^~~~~~~~~~


vim +/compat_ptr +356 mm/alloc_tag.c

   351	
   352	#ifdef CONFIG_COMPAT
   353	static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
   354					   unsigned long arg)
   355	{
 > 356		return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
   357	}
   358	#endif
   359	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

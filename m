Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6233DB65A;
	Fri,  3 Jul 2026 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783088123; cv=none; b=MobcpCjmPCAKcnXuLjG9dpzaMNZ9oip5qAnZ/yOFAWlPLmISngA/lYu+tXl1HM3+wLisqXpPWKwduduanEtPB03CA/q/91gmpnsbol1CZPHxfAqsHhI12489WjpPHJrYjBsw5wa+K2dXPURmH/EvhRJZiQBpLIuMoJQYGIBW+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783088123; c=relaxed/simple;
	bh=mssUN9MRux+VdHWpXmTi+DJe1noOKFImv4q9eLM5sbQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=p58tersVeoMZ3TqO56dhLuw8yBd8YR76C8dVouhvLj2yEbD3Gdl47qcIKePYXQi7gvU5dOt+Xi4oj6810rk8JC+Qs44cnQQGxUALojii/JR2YAYwocXJJVBidlWCNzSHumYlmJYzS3qBPh5RQxWT1kbbiiVPPnn28cvHfVLUNTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+JDrISk; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+JDrISk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783088117; x=1814624117;
  h=date:from:to:cc:subject:message-id;
  bh=mssUN9MRux+VdHWpXmTi+DJe1noOKFImv4q9eLM5sbQ=;
  b=C+JDrISkD5FMGw7QsyEI71SkMZnhRTscesW5XubKD2HvpeK8dcYZe7qG
   TlGDHq8OYRtHYLrAw/u/plSABiK8W6TZrGKDy2dlnz/zsI9db2pP6PYif
   mFxgP+q/Gm4V2p6e2RSNJf3dKmdyqVZgeAt0OiF9Up64y5EoxyHoR6dXT
   owUs+F0tgkt3GE6N83X7NZlj6SUk2XOClk06Uv4YwWb0gcdwkwLi7BdYE
   d1NlJbn+29u5BbxlHxMKPLfq5YeCNvIk30KqI9HrNb06EBbM2x0y3ZmgU
   8Y+T0Tv7iybHMU23GDsPWBxGUHU//bLvNCOvfrNjnAmDFeSEmLW6d6L/2
   w==;
X-CSE-ConnectionGUID: o2xWGcbXRWiU5ynxsQIt7w==
X-CSE-MsgGUID: yw/mdN9vSBa1upNa80mVWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="101263255"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="101263255"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 07:15:15 -0700
X-CSE-ConnectionGUID: NvVg7GuqQrquyAbvLICZGw==
X-CSE-MsgGUID: H10oQFSMQL2oRE56n2HspA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="248675895"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 03 Jul 2026 07:15:12 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfefe-000000001Wz-3EcE;
	Fri, 03 Jul 2026 14:15:10 +0000
Date: Fri, 03 Jul 2026 16:14:58 +0200
From: kernel test robot <lkp@intel.com>
To: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 43/44] htmldocs:
 Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends
 without a blank line; unexpected unindent. [docutils]
Message-ID: <202607031654.P4fsMqo4-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   604ad02caddab12905643d5191b4a301d87033ef
commit: 7f18b4ec38272a00b16cb2995ebb06281e0f26d0 [43/44] delaytop: sort by max delay to highlight top latency processes
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260703/202607031654.P4fsMqo4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607031654.P4fsMqo4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode_index is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:373; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:243
   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:636; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:252
   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled_index is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:645; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:261
   Using alabaster theme
   Documentation/accounting/delay-accounting.rst:236: ERROR: Unexpected indentation. [docutils]
>> Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:237: ERROR: Unexpected section title or transition.
--
   Documentation/accounting/delay-accounting.rst:239: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:243: ERROR: Unexpected indentation. [docutils]
   Documentation/accounting/delay-accounting.rst:244: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:246: ERROR: Unexpected indentation. [docutils]
   Documentation/accounting/delay-accounting.rst:247: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
>> Documentation/accounting/delay-accounting.rst:249: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:246: ERROR: Unknown target name: "pool_workqueue". [docutils]
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:364; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:234
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:373; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:243
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:636; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:252
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:645; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:261


vim +237 Documentation/accounting/delay-accounting.rst

   224	
   225		bash# ./delaytop -t cpu
   226		System Pressure Information: (avg10/avg60/avg300/total)
   227		CPU some:       0.4%/   0.2%/   0.1%/     220(ms)
   228		CPU full:       0.0%/   0.0%/   0.0%/       0(ms)
   229		Memory full:    0.0%/   0.0%/   0.0%/       0(ms)
   230		Memory some:    0.0%/   0.0%/   0.0%/       0(ms)
   231		IO full:        0.0%/   0.0%/   0.0%/      12(ms)
   232		IO some:        0.0%/   0.0%/   0.0%/      13(ms)
   233		IRQ full:       0.0%/   0.0%/   0.0%/       0(ms)
   234		[q]quit
   235		Top 20 processes (sorted by cpu MAX delay, largest first):
   236		     PID      TGID  COMMAND          AVG(ms)  MAX(ms)   MAX_TIMESTAMP
 > 237		------------------------------------------------------------------------
   238		       9         9  kworker/0:0-eve   0.59   16.87  2026-05-27T13:32:39
 > 239		      30        30  kworker/2:0H-kb   2.87   11.36  2026-05-27T13:32:36
   240		      27        27  migration/2       1.05    9.51  2026-05-27T13:32:37
   241		      50        50  kworker/2:1-eve   0.50    9.13  2026-05-27T13:32:37
   242		      15        15  rcu_preempt       0.11    8.98  2026-05-27T13:32:37
   243		       1         1  init              0.17    7.12  2026-05-27T13:32:38
   244		      67        67  scsi_eh_0         1.20    4.23  2026-05-27T13:32:37
   245		      23        23  ksoftirqd/1       1.12    3.77  2026-05-27T13:32:36
   246		       3         3  pool_workqueue_   0.72    3.55  2026-05-27T13:32:38
   247		      62        62  kworker/u20:2-a   0.49    3.03  2026-05-27T13:32:37
   248		       2         2  kthreadd          0.18    2.82  2026-05-27T13:32:37
 > 249		      11        11  kworker/0:1       1.42    2.76  2026-05-27T13:32:36

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

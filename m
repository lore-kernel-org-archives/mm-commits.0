Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DF54317C
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 09:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726826026; cv=none; b=suZVVTbRThZbDpDt/rbUIJJ6GlfNOF1c1YLsvgvWYvckcH2OrQESBW1/FmxGk1QC7P3yuPkZ01PzG3Y+aujwCcrFL2gsf+SOj6ypTUOdNpvaqDZEBCZDjQ0n7e5+GC6I3BFspmRHQ5tlJC1BwZE3ocpbLEFnql35CTBXTw/UZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726826026; c=relaxed/simple;
	bh=eaM/K7Z92wnNVB7pIj/3MQNE6E43wIL+5dw/qQCQnAc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XGpk4hHMflvy+zdkxhGp8CtTGiDCfkjn6WESdJHsmYg7qPiqnVuIQ0QSFcK92Kf7BgGlFoSgrpmvfG53Ib5f6bwVzNCjfZ0EFoPZGTeB6PEDC5kCQqIU900UyDUmIptUermWrX/7wlQoJPm2iGTbYoEka0cFiMglGMfNi9ICCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MXsMR+4u; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MXsMR+4u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726826024; x=1758362024;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=eaM/K7Z92wnNVB7pIj/3MQNE6E43wIL+5dw/qQCQnAc=;
  b=MXsMR+4uaVDv+k54q7flhxzASKk7Itbk/RbtOfEFKGzKzBfQq1PiBw++
   uItrs2ig2tyhSh9v5tS8UZ6wrfJ6HJjalWGq4vczL4FCd7ymDch+kvXrw
   2wT1rQ+fpZo4XZR5Lz9Xe0ZGD+a7PVbY6HTTZssSRq/RK8cwA4K4bNrta
   IzzXtjnJayX6ejZ6CcxthU2xzWiTGAuD9zNljTFf3Ps5VJGLpPmLR5mgC
   zCbfcMzq24w8xYuksX4Ken2PUF7Ms96Dba0T2Pbfct2P9aum/zbRlwyD/
   Ex1ExD6tCQSQhzlkmMxSG9s6vMyT7TAce6TnVXptJBZFv1B1VQDsMqD4D
   w==;
X-CSE-ConnectionGUID: i1BYgaILS9WT/XaipTn4ZQ==
X-CSE-MsgGUID: Tiz5ZaLARriMJZOi3gMaog==
X-IronPort-AV: E=McAfee;i="6700,10204,11200"; a="48356748"
X-IronPort-AV: E=Sophos;i="6.10,244,1719903600"; 
   d="scan'208";a="48356748"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2024 02:53:43 -0700
X-CSE-ConnectionGUID: WxcW3gmqRBKLRCralmWSbQ==
X-CSE-MsgGUID: yqZ7SKISTuObLIG0u7ZYXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,244,1719903600"; 
   d="scan'208";a="101082289"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2024 02:53:39 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  mm-commits@vger.kernel.org,
  vishal.l.verma@intel.com,  jonathan.cameron@huawei.com,
  ira.weiny@intel.com,  david@redhat.com,  dave@stgolabs.net,
  dave.jiang@intel.com,  dan.j.williams@intel.com,  bhe@redhat.com,
  bhelgaas@google.com,  apopple@nvidia.com,
  andriy.shevchenko@linux.intel.com,  alison.schofield@intel.com
Subject: Re: [merged mm-stable]
 resource-kunit-add-test-case-for-region_intersects.patch removed from -mm
 tree
In-Reply-To: <20240920090828.GA341601@thelio-3990X> (Nathan Chancellor's
	message of "Fri, 20 Sep 2024 02:08:28 -0700")
References: <20240917080852.0199FC4CEC6@smtp.kernel.org>
	<20240920090828.GA341601@thelio-3990X>
Date: Fri, 20 Sep 2024 17:50:07 +0800
Message-ID: <878qvmvels.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Hi, Nathan,

Nathan Chancellor <nathan@kernel.org> writes:

> On Tue, Sep 17, 2024 at 01:08:49AM -0700, Andrew Morton wrote:
>> 
>> The quilt patch titled
>>      Subject: resource, kunit: add test case for region_intersects()
>> has been removed from the -mm tree.  Its filename was
>>      resource-kunit-add-test-case-for-region_intersects.patch
>> 
>> This patch was dropped because it was merged into the mm-stable branch
>> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> 
>> ------------------------------------------------------
>> From: Huang Ying <ying.huang@intel.com>
>> Subject: resource, kunit: add test case for region_intersects()
>> Date: Fri, 6 Sep 2024 11:07:13 +0800
>> 
>> Patch series "resource: Fix region_intersects() vs
>> add_memory_driver_managed()", v3.
>> 
>> The patchset fixes a bug of region_intersects() for systems with CXL
>> memory.  The details of the bug can be found in [1/3].  To avoid similar
>> bugs in the future.  A kunit test case for region_intersects() is added in
>> [3/3].  [2/3] is a preparation patch for [3/3].
>> 
>> 
>> This patch (of 3):
>> 
>> region_intersects() is important because it's used for /dev/mem permission
>> checking.  To avoid possible bug of region_intersects() in the future, a
>> kunit test case for region_intersects() is added.
>> 
>> Link: https://lkml.kernel.org/r/20240906030713.204292-1-ying.huang@intel.com
>> Link: https://lkml.kernel.org/r/20240906030713.204292-4-ying.huang@intel.com
>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Alison Schofield <alison.schofield@intel.com>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Baoquan He <bhe@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>> 
>>  kernel/resource.c       |   20 +++--
>>  kernel/resource_kunit.c |  143 ++++++++++++++++++++++++++++++++++++++
>>  lib/Kconfig.debug       |    1 
>>  3 files changed, 158 insertions(+), 6 deletions(-)
>> 
>> --- a/kernel/resource.c~resource-kunit-add-test-case-for-region_intersects
>> +++ a/kernel/resource.c
>> @@ -1817,7 +1817,17 @@ EXPORT_SYMBOL(resource_list_free);
>>  #ifdef CONFIG_GET_FREE_REGION
>>  #define GFR_DESCENDING		(1UL << 0)
>>  #define GFR_REQUEST_REGION	(1UL << 1)
>> -#define GFR_DEFAULT_ALIGN (1UL << PA_SECTION_SHIFT)
>> +#ifdef PA_SECTION_SHIFT
>> +#define GFR_DEFAULT_ALIGN	(1UL << PA_SECTION_SHIFT)
>> +#else
>> +#define GFR_DEFAULT_ALIGN	PAGE_SIZE
>> +#endif
>> +
>> +#ifdef MAX_PHYSMEM_BITS
>> +#define MAX_PHYS_ADDR		((1ULL << MAX_PHYSMEM_BITS) - 1)
>> +#else
>> +#define MAX_PHYS_ADDR		(-1ULL)
>> +#endif
>>  
>>  static resource_size_t gfr_start(struct resource *base, resource_size_t size,
>>  				 resource_size_t align, unsigned long flags)
>> @@ -1825,8 +1835,7 @@ static resource_size_t gfr_start(struct
>>  	if (flags & GFR_DESCENDING) {
>>  		resource_size_t end;
>>  
>> -		end = min_t(resource_size_t, base->end,
>> -			    (1ULL << MAX_PHYSMEM_BITS) - 1);
>> +		end = min_t(resource_size_t, base->end, MAX_PHYS_ADDR);
>>  		return end - size + 1;
>>  	}
>>  
>> @@ -1843,8 +1852,7 @@ static bool gfr_continue(struct resource
>>  	 * @size did not wrap 0.
>>  	 */
>>  	return addr > addr - size &&
>> -	       addr <= min_t(resource_size_t, base->end,
>> -			     (1ULL << MAX_PHYSMEM_BITS) - 1);
>> +		addr <= min_t(resource_size_t, base->end, MAX_PHYS_ADDR);
>>  }
>>  
>>  static resource_size_t gfr_next(resource_size_t addr, resource_size_t size,
>> @@ -2005,7 +2013,7 @@ struct resource *alloc_free_mem_region(s
>>  	return get_free_mem_region(NULL, base, size, align, name,
>>  				   IORES_DESC_NONE, flags);
>>  }
>> -EXPORT_SYMBOL_NS_GPL(alloc_free_mem_region, CXL);
>> +EXPORT_SYMBOL_GPL(alloc_free_mem_region);
>>  #endif /* CONFIG_GET_FREE_REGION */
>>  
>>  static int __init strict_iomem(char *str)
>> --- a/kernel/resource_kunit.c~resource-kunit-add-test-case-for-region_intersects
>> +++ a/kernel/resource_kunit.c
>> @@ -7,6 +7,8 @@
>>  #include <linux/ioport.h>
>>  #include <linux/kernel.h>
>>  #include <linux/string.h>
>> +#include <linux/sizes.h>
>> +#include <linux/mm.h>
>>  
>>  #define R0_START	0x0000
>>  #define R0_END		0xffff
>> @@ -137,9 +139,150 @@ static void resource_test_intersection(s
>>  	} while (++i < ARRAY_SIZE(results_for_intersection));
>>  }
>>  
>> +/*
>> + * The test resource tree for region_intersects() test:
>> + *
>> + * BASE-BASE+1M-1 : Test System RAM 0
>> + *		  # hole 0 (BASE+1M-BASE+2M)
>> + * BASE+2M-BASE+3M-1 : Test CXL Window 0
>> + * BASE+3M-BASE+4M-1 : Test System RAM 1
>> + * BASE+4M-BASE+7M-1 : Test CXL Window 1
>> + *   BASE+4M-BASE+5M-1 : Test System RAM 2
>> + *     BASE+4M+128K-BASE+4M+256K-1: Test Code
>> + *   BASE+5M-BASE+6M-1 : Test System RAM 3
>> + */
>> +#define RES_TEST_RAM0_OFFSET	0
>> +#define RES_TEST_RAM0_SIZE	SZ_1M
>> +#define RES_TEST_HOLE0_OFFSET	(RES_TEST_RAM0_OFFSET + RES_TEST_RAM0_SIZE)
>> +#define RES_TEST_HOLE0_SIZE	SZ_1M
>> +#define RES_TEST_WIN0_OFFSET	(RES_TEST_HOLE0_OFFSET + RES_TEST_HOLE0_SIZE)
>> +#define RES_TEST_WIN0_SIZE	SZ_1M
>> +#define RES_TEST_RAM1_OFFSET	(RES_TEST_WIN0_OFFSET + RES_TEST_WIN0_SIZE)
>> +#define RES_TEST_RAM1_SIZE	SZ_1M
>> +#define RES_TEST_WIN1_OFFSET	(RES_TEST_RAM1_OFFSET + RES_TEST_RAM1_SIZE)
>> +#define RES_TEST_WIN1_SIZE	(SZ_1M * 3)
>> +#define RES_TEST_RAM2_OFFSET	RES_TEST_WIN1_OFFSET
>> +#define RES_TEST_RAM2_SIZE	SZ_1M
>> +#define RES_TEST_CODE_OFFSET	(RES_TEST_RAM2_OFFSET + SZ_128K)
>> +#define RES_TEST_CODE_SIZE	SZ_128K
>> +#define RES_TEST_RAM3_OFFSET	(RES_TEST_RAM2_OFFSET + RES_TEST_RAM2_SIZE)
>> +#define RES_TEST_RAM3_SIZE	SZ_1M
>> +#define RES_TEST_TOTAL_SIZE	((RES_TEST_WIN1_OFFSET + RES_TEST_WIN1_SIZE))
>> +
>> +static void remove_free_resource(void *ctx)
>> +{
>> +	struct resource *res = (struct resource *)ctx;
>> +
>> +	remove_resource(res);
>> +	kfree(res);
>> +}
>> +
>> +static void resource_test_request_region(struct kunit *test, struct resource *parent,
>> +					 resource_size_t start, resource_size_t size,
>> +					 const char *name, unsigned long flags)
>> +{
>> +	struct resource *res;
>> +
>> +	res = __request_region(parent, start, size, name, flags);
>> +	KUNIT_ASSERT_NOT_NULL(test, res);
>> +	kunit_add_action_or_reset(test, remove_free_resource, res);
>> +}
>> +
>> +static void resource_test_insert_resource(struct kunit *test, struct resource *parent,
>> +					  resource_size_t start, resource_size_t size,
>> +					  const char *name, unsigned long flags)
>> +{
>> +	struct resource *res;
>> +
>> +	res = kzalloc(sizeof(*res), GFP_KERNEL);
>> +	KUNIT_ASSERT_NOT_NULL(test, res);
>> +
>> +	res->name = name;
>> +	res->start = start;
>> +	res->end = start + size - 1;
>> +	res->flags = flags;
>> +	if (insert_resource(parent, res)) {
>> +		kfree(res);
>> +		KUNIT_FAIL_AND_ABORT(test, "Fail to insert resource %pR\n", res);
>> +	}
>> +
>> +	kunit_add_action_or_reset(test, remove_free_resource, res);
>> +}
>> +
>> +static void resource_test_region_intersects(struct kunit *test)
>> +{
>> +	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
>> +	struct resource *parent;
>> +	resource_size_t start;
>> +
>> +	/* Find an iomem_resource hole to hold test resources */
>> +	parent = alloc_free_mem_region(&iomem_resource, RES_TEST_TOTAL_SIZE, SZ_1M,
>> +				       "test resources");
>> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, parent);
>> +	start = parent->start;
>> +	kunit_add_action_or_reset(test, remove_free_resource, parent);
>> +
>> +	resource_test_request_region(test, parent, start + RES_TEST_RAM0_OFFSET,
>> +				     RES_TEST_RAM0_SIZE, "Test System RAM 0", flags);
>> +	resource_test_insert_resource(test, parent, start + RES_TEST_WIN0_OFFSET,
>> +				      RES_TEST_WIN0_SIZE, "Test CXL Window 0",
>> +				      IORESOURCE_MEM);
>> +	resource_test_request_region(test, parent, start + RES_TEST_RAM1_OFFSET,
>> +				     RES_TEST_RAM1_SIZE, "Test System RAM 1", flags);
>> +	resource_test_insert_resource(test, parent, start + RES_TEST_WIN1_OFFSET,
>> +				      RES_TEST_WIN1_SIZE, "Test CXL Window 1",
>> +				      IORESOURCE_MEM);
>> +	resource_test_request_region(test, parent, start + RES_TEST_RAM2_OFFSET,
>> +				     RES_TEST_RAM2_SIZE, "Test System RAM 2", flags);
>> +	resource_test_insert_resource(test, parent, start + RES_TEST_CODE_OFFSET,
>> +				      RES_TEST_CODE_SIZE, "Test Code", flags);
>> +	resource_test_request_region(test, parent, start + RES_TEST_RAM3_OFFSET,
>> +				     RES_TEST_RAM3_SIZE, "Test System RAM 3", flags);
>> +	kunit_release_action(test, remove_free_resource, parent);
>> +
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_RAM0_OFFSET, PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_RAM0_OFFSET +
>> +					  RES_TEST_RAM0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_DISJOINT,
>> +			region_intersects(start + RES_TEST_HOLE0_OFFSET, PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_DISJOINT,
>> +			region_intersects(start + RES_TEST_HOLE0_OFFSET +
>> +					  RES_TEST_HOLE0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_MIXED,
>> +			region_intersects(start + RES_TEST_WIN0_OFFSET +
>> +					  RES_TEST_WIN0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_RAM1_OFFSET +
>> +					  RES_TEST_RAM1_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_RAM2_OFFSET +
>> +					  RES_TEST_RAM2_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_CODE_OFFSET, PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
>> +			region_intersects(start + RES_TEST_RAM2_OFFSET,
>> +					  RES_TEST_RAM2_SIZE + PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +	KUNIT_EXPECT_EQ(test, REGION_MIXED,
>> +			region_intersects(start + RES_TEST_RAM3_OFFSET,
>> +					  RES_TEST_RAM3_SIZE + PAGE_SIZE,
>> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
>> +}
>> +
>>  static struct kunit_case resource_test_cases[] = {
>>  	KUNIT_CASE(resource_test_union),
>>  	KUNIT_CASE(resource_test_intersection),
>> +	KUNIT_CASE(resource_test_region_intersects),
>>  	{}
>>  };
>>  
>> --- a/lib/Kconfig.debug~resource-kunit-add-test-case-for-region_intersects
>> +++ a/lib/Kconfig.debug
>> @@ -2616,6 +2616,7 @@ config RESOURCE_KUNIT_TEST
>>  	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
>>  	depends on KUNIT
>>  	default KUNIT_ALL_TESTS
>> +	select GET_FREE_REGION
>>  	help
>>  	  This builds the resource API unit test.
>>  	  Tests the logic of API provided by resource.c and ioport.h.
>> _
>> 
>> Patches currently in -mm which might be from ying.huang@intel.com are
>> 
>> 
>
> This change results in the following Kconfig warning and compiler
> warnings (or errors with CONFIG_WERROR):
>
>   $ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- allmodconfig kernel/resource.o
>   WARNING: unmet direct dependencies detected for GET_FREE_REGION
>     Depends on [n]: SPARSEMEM [=n]
>     Selected by [m]:
>     - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=m]

Thanks for reporting!  After more investigation, it appears that
GET_FREE_REGION depends on SPARSEMEM just for several constant.  That
can be fixed relatively easily.  I will do that.

>   In file included from include/linux/ioport.h:15,
>                    from kernel/resource.c:15:
>   kernel/resource.c: In function 'gfr_start':
>   include/linux/minmax.h:93:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Werror=overflow]
>      93 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
>         |                                     ^
>   include/linux/minmax.h:96:9: note: in expansion of macro '__cmp_once_unique'
>      96 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
>         |         ^~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:213:27: note: in expansion of macro '__cmp_once'
>     213 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
>         |                           ^~~~~~~~~~
>   kernel/resource.c:1874:23: note: in expansion of macro 'min_t'
>    1874 |                 end = min_t(resource_size_t, base->end, PHYSMEM_END);
>         |                       ^~~~~
>   kernel/resource.c: In function 'gfr_continue':
>   include/linux/minmax.h:93:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Werror=overflow]
>      93 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
>         |                                     ^
>   include/linux/minmax.h:96:9: note: in expansion of macro '__cmp_once_unique'
>      96 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
>         |         ^~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:213:27: note: in expansion of macro '__cmp_once'
>     213 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
>         |                           ^~~~~~~~~~
>   kernel/resource.c:1891:24: note: in expansion of macro 'min_t'
>    1891 |                addr <= min_t(resource_size_t, base->end, PHYSMEM_END);
>         |                        ^~~~~
>   cc1: all warnings being treated as errors
>
> Arnd had a patch in another bug report to resolve the Kconfig warning,
> which happens to resolve the compiler warning for allmodconfig, but I
> suspect that a configuration with SPARSEMEM and !ARM_LPAE could still
> trigger the compiler warnings.
>
> https://lore.kernel.org/aaee4ddb-68a8-42ae-bb68-11ef991ada1c@app.fastmail.com/

Yes.  That is a quick fix.  I will prepare a complete fix ASAP.  But the
merge path of the patch is a little complex.  I think that it may be
better to fix it after current patch and fixes being landed.

--
Best Regards,
Huang, Ying

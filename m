Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75E537FF
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823311; cv=none; b=t+QOxHbfWxjOtYb2kWDaa7wD5WpjRym0+6I0t/QIJGtVR/rllf1Wt1O3eBx6qKStpiy04NT0xYU/84xntBG6IAv5GoFH7brN6hU3awcb2M3aZMavtnk3tN/CV7n3BxZmUBRXWBoVKhld9WEaYLzJUEzsqiyDLfBJJJFUcA/OSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823311; c=relaxed/simple;
	bh=anEptJN+9UaXSBENZAWj/HDOVeongXJwIEi24kdcjMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU6Ro2pik1cP9t0OwKZG+Hhay+dKtsGiO1jO5EqxwyaASa9eMrBj8ahbLucEQyDogjqbyrGXZ8mGm/21XvTQtSyNZwHL7CNmMRkdFbNuGp6LP3nrIzLGIE5VdBUzdrTVQLU8W16X2lTuPXZXIDoFT6j7AKh+rdZ8J9kUKzu7ovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=til700xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="til700xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1503CC4CEC3;
	Fri, 20 Sep 2024 09:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726823310;
	bh=anEptJN+9UaXSBENZAWj/HDOVeongXJwIEi24kdcjMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=til700xigKhTZYmlOpGfp06G35zZwWQAdk4i1B2FngFhXzMtKEf6MkoFUVkZw6CrO
	 1LCn8LoPbmIz4UXQQQyy3AjfNsYhcXEnVFZ7Zy1TSQmDqFRfDvjNJJv4AxhZphWT6Y
	 x5F3b95rMAJsX0XLQvmVpbpXzUWNhioO14ZNg0vcRHzqw/lz62rqD3hUXyBW0q6p2f
	 SYOAvJgr+PyiywwIA0riptBsqCcg949TyAsYVmDeEPmRzVnkx/C5rTI9HlcQU4syNl
	 2p6mU7BZ7FR7JIP6pFiBgkVF5v5maH6Oh8bxU/2S3sMBEUYSLn1ffXZKBLsbDFnFKZ
	 lHpsPv8rR7UVw==
Date: Fri, 20 Sep 2024 02:08:28 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
	jonathan.cameron@huawei.com, ira.weiny@intel.com, david@redhat.com,
	dave@stgolabs.net, dave.jiang@intel.com, dan.j.williams@intel.com,
	bhe@redhat.com, bhelgaas@google.com, apopple@nvidia.com,
	andriy.shevchenko@linux.intel.com, alison.schofield@intel.com,
	ying.huang@intel.com
Subject: Re: [merged mm-stable]
 resource-kunit-add-test-case-for-region_intersects.patch removed from -mm
 tree
Message-ID: <20240920090828.GA341601@thelio-3990X>
References: <20240917080852.0199FC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917080852.0199FC4CEC6@smtp.kernel.org>

On Tue, Sep 17, 2024 at 01:08:49AM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: resource, kunit: add test case for region_intersects()
> has been removed from the -mm tree.  Its filename was
>      resource-kunit-add-test-case-for-region_intersects.patch
> 
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Huang Ying <ying.huang@intel.com>
> Subject: resource, kunit: add test case for region_intersects()
> Date: Fri, 6 Sep 2024 11:07:13 +0800
> 
> Patch series "resource: Fix region_intersects() vs
> add_memory_driver_managed()", v3.
> 
> The patchset fixes a bug of region_intersects() for systems with CXL
> memory.  The details of the bug can be found in [1/3].  To avoid similar
> bugs in the future.  A kunit test case for region_intersects() is added in
> [3/3].  [2/3] is a preparation patch for [3/3].
> 
> 
> This patch (of 3):
> 
> region_intersects() is important because it's used for /dev/mem permission
> checking.  To avoid possible bug of region_intersects() in the future, a
> kunit test case for region_intersects() is added.
> 
> Link: https://lkml.kernel.org/r/20240906030713.204292-1-ying.huang@intel.com
> Link: https://lkml.kernel.org/r/20240906030713.204292-4-ying.huang@intel.com
> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Baoquan He <bhe@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/resource.c       |   20 +++--
>  kernel/resource_kunit.c |  143 ++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug       |    1 
>  3 files changed, 158 insertions(+), 6 deletions(-)
> 
> --- a/kernel/resource.c~resource-kunit-add-test-case-for-region_intersects
> +++ a/kernel/resource.c
> @@ -1817,7 +1817,17 @@ EXPORT_SYMBOL(resource_list_free);
>  #ifdef CONFIG_GET_FREE_REGION
>  #define GFR_DESCENDING		(1UL << 0)
>  #define GFR_REQUEST_REGION	(1UL << 1)
> -#define GFR_DEFAULT_ALIGN (1UL << PA_SECTION_SHIFT)
> +#ifdef PA_SECTION_SHIFT
> +#define GFR_DEFAULT_ALIGN	(1UL << PA_SECTION_SHIFT)
> +#else
> +#define GFR_DEFAULT_ALIGN	PAGE_SIZE
> +#endif
> +
> +#ifdef MAX_PHYSMEM_BITS
> +#define MAX_PHYS_ADDR		((1ULL << MAX_PHYSMEM_BITS) - 1)
> +#else
> +#define MAX_PHYS_ADDR		(-1ULL)
> +#endif
>  
>  static resource_size_t gfr_start(struct resource *base, resource_size_t size,
>  				 resource_size_t align, unsigned long flags)
> @@ -1825,8 +1835,7 @@ static resource_size_t gfr_start(struct
>  	if (flags & GFR_DESCENDING) {
>  		resource_size_t end;
>  
> -		end = min_t(resource_size_t, base->end,
> -			    (1ULL << MAX_PHYSMEM_BITS) - 1);
> +		end = min_t(resource_size_t, base->end, MAX_PHYS_ADDR);
>  		return end - size + 1;
>  	}
>  
> @@ -1843,8 +1852,7 @@ static bool gfr_continue(struct resource
>  	 * @size did not wrap 0.
>  	 */
>  	return addr > addr - size &&
> -	       addr <= min_t(resource_size_t, base->end,
> -			     (1ULL << MAX_PHYSMEM_BITS) - 1);
> +		addr <= min_t(resource_size_t, base->end, MAX_PHYS_ADDR);
>  }
>  
>  static resource_size_t gfr_next(resource_size_t addr, resource_size_t size,
> @@ -2005,7 +2013,7 @@ struct resource *alloc_free_mem_region(s
>  	return get_free_mem_region(NULL, base, size, align, name,
>  				   IORES_DESC_NONE, flags);
>  }
> -EXPORT_SYMBOL_NS_GPL(alloc_free_mem_region, CXL);
> +EXPORT_SYMBOL_GPL(alloc_free_mem_region);
>  #endif /* CONFIG_GET_FREE_REGION */
>  
>  static int __init strict_iomem(char *str)
> --- a/kernel/resource_kunit.c~resource-kunit-add-test-case-for-region_intersects
> +++ a/kernel/resource_kunit.c
> @@ -7,6 +7,8 @@
>  #include <linux/ioport.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> +#include <linux/sizes.h>
> +#include <linux/mm.h>
>  
>  #define R0_START	0x0000
>  #define R0_END		0xffff
> @@ -137,9 +139,150 @@ static void resource_test_intersection(s
>  	} while (++i < ARRAY_SIZE(results_for_intersection));
>  }
>  
> +/*
> + * The test resource tree for region_intersects() test:
> + *
> + * BASE-BASE+1M-1 : Test System RAM 0
> + *		  # hole 0 (BASE+1M-BASE+2M)
> + * BASE+2M-BASE+3M-1 : Test CXL Window 0
> + * BASE+3M-BASE+4M-1 : Test System RAM 1
> + * BASE+4M-BASE+7M-1 : Test CXL Window 1
> + *   BASE+4M-BASE+5M-1 : Test System RAM 2
> + *     BASE+4M+128K-BASE+4M+256K-1: Test Code
> + *   BASE+5M-BASE+6M-1 : Test System RAM 3
> + */
> +#define RES_TEST_RAM0_OFFSET	0
> +#define RES_TEST_RAM0_SIZE	SZ_1M
> +#define RES_TEST_HOLE0_OFFSET	(RES_TEST_RAM0_OFFSET + RES_TEST_RAM0_SIZE)
> +#define RES_TEST_HOLE0_SIZE	SZ_1M
> +#define RES_TEST_WIN0_OFFSET	(RES_TEST_HOLE0_OFFSET + RES_TEST_HOLE0_SIZE)
> +#define RES_TEST_WIN0_SIZE	SZ_1M
> +#define RES_TEST_RAM1_OFFSET	(RES_TEST_WIN0_OFFSET + RES_TEST_WIN0_SIZE)
> +#define RES_TEST_RAM1_SIZE	SZ_1M
> +#define RES_TEST_WIN1_OFFSET	(RES_TEST_RAM1_OFFSET + RES_TEST_RAM1_SIZE)
> +#define RES_TEST_WIN1_SIZE	(SZ_1M * 3)
> +#define RES_TEST_RAM2_OFFSET	RES_TEST_WIN1_OFFSET
> +#define RES_TEST_RAM2_SIZE	SZ_1M
> +#define RES_TEST_CODE_OFFSET	(RES_TEST_RAM2_OFFSET + SZ_128K)
> +#define RES_TEST_CODE_SIZE	SZ_128K
> +#define RES_TEST_RAM3_OFFSET	(RES_TEST_RAM2_OFFSET + RES_TEST_RAM2_SIZE)
> +#define RES_TEST_RAM3_SIZE	SZ_1M
> +#define RES_TEST_TOTAL_SIZE	((RES_TEST_WIN1_OFFSET + RES_TEST_WIN1_SIZE))
> +
> +static void remove_free_resource(void *ctx)
> +{
> +	struct resource *res = (struct resource *)ctx;
> +
> +	remove_resource(res);
> +	kfree(res);
> +}
> +
> +static void resource_test_request_region(struct kunit *test, struct resource *parent,
> +					 resource_size_t start, resource_size_t size,
> +					 const char *name, unsigned long flags)
> +{
> +	struct resource *res;
> +
> +	res = __request_region(parent, start, size, name, flags);
> +	KUNIT_ASSERT_NOT_NULL(test, res);
> +	kunit_add_action_or_reset(test, remove_free_resource, res);
> +}
> +
> +static void resource_test_insert_resource(struct kunit *test, struct resource *parent,
> +					  resource_size_t start, resource_size_t size,
> +					  const char *name, unsigned long flags)
> +{
> +	struct resource *res;
> +
> +	res = kzalloc(sizeof(*res), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, res);
> +
> +	res->name = name;
> +	res->start = start;
> +	res->end = start + size - 1;
> +	res->flags = flags;
> +	if (insert_resource(parent, res)) {
> +		kfree(res);
> +		KUNIT_FAIL_AND_ABORT(test, "Fail to insert resource %pR\n", res);
> +	}
> +
> +	kunit_add_action_or_reset(test, remove_free_resource, res);
> +}
> +
> +static void resource_test_region_intersects(struct kunit *test)
> +{
> +	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
> +	struct resource *parent;
> +	resource_size_t start;
> +
> +	/* Find an iomem_resource hole to hold test resources */
> +	parent = alloc_free_mem_region(&iomem_resource, RES_TEST_TOTAL_SIZE, SZ_1M,
> +				       "test resources");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, parent);
> +	start = parent->start;
> +	kunit_add_action_or_reset(test, remove_free_resource, parent);
> +
> +	resource_test_request_region(test, parent, start + RES_TEST_RAM0_OFFSET,
> +				     RES_TEST_RAM0_SIZE, "Test System RAM 0", flags);
> +	resource_test_insert_resource(test, parent, start + RES_TEST_WIN0_OFFSET,
> +				      RES_TEST_WIN0_SIZE, "Test CXL Window 0",
> +				      IORESOURCE_MEM);
> +	resource_test_request_region(test, parent, start + RES_TEST_RAM1_OFFSET,
> +				     RES_TEST_RAM1_SIZE, "Test System RAM 1", flags);
> +	resource_test_insert_resource(test, parent, start + RES_TEST_WIN1_OFFSET,
> +				      RES_TEST_WIN1_SIZE, "Test CXL Window 1",
> +				      IORESOURCE_MEM);
> +	resource_test_request_region(test, parent, start + RES_TEST_RAM2_OFFSET,
> +				     RES_TEST_RAM2_SIZE, "Test System RAM 2", flags);
> +	resource_test_insert_resource(test, parent, start + RES_TEST_CODE_OFFSET,
> +				      RES_TEST_CODE_SIZE, "Test Code", flags);
> +	resource_test_request_region(test, parent, start + RES_TEST_RAM3_OFFSET,
> +				     RES_TEST_RAM3_SIZE, "Test System RAM 3", flags);
> +	kunit_release_action(test, remove_free_resource, parent);
> +
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_RAM0_OFFSET, PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_RAM0_OFFSET +
> +					  RES_TEST_RAM0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_DISJOINT,
> +			region_intersects(start + RES_TEST_HOLE0_OFFSET, PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_DISJOINT,
> +			region_intersects(start + RES_TEST_HOLE0_OFFSET +
> +					  RES_TEST_HOLE0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_MIXED,
> +			region_intersects(start + RES_TEST_WIN0_OFFSET +
> +					  RES_TEST_WIN0_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_RAM1_OFFSET +
> +					  RES_TEST_RAM1_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_RAM2_OFFSET +
> +					  RES_TEST_RAM2_SIZE - PAGE_SIZE, 2 * PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_CODE_OFFSET, PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_INTERSECTS,
> +			region_intersects(start + RES_TEST_RAM2_OFFSET,
> +					  RES_TEST_RAM2_SIZE + PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +	KUNIT_EXPECT_EQ(test, REGION_MIXED,
> +			region_intersects(start + RES_TEST_RAM3_OFFSET,
> +					  RES_TEST_RAM3_SIZE + PAGE_SIZE,
> +					  IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE));
> +}
> +
>  static struct kunit_case resource_test_cases[] = {
>  	KUNIT_CASE(resource_test_union),
>  	KUNIT_CASE(resource_test_intersection),
> +	KUNIT_CASE(resource_test_region_intersects),
>  	{}
>  };
>  
> --- a/lib/Kconfig.debug~resource-kunit-add-test-case-for-region_intersects
> +++ a/lib/Kconfig.debug
> @@ -2616,6 +2616,7 @@ config RESOURCE_KUNIT_TEST
>  	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
>  	depends on KUNIT
>  	default KUNIT_ALL_TESTS
> +	select GET_FREE_REGION
>  	help
>  	  This builds the resource API unit test.
>  	  Tests the logic of API provided by resource.c and ioport.h.
> _
> 
> Patches currently in -mm which might be from ying.huang@intel.com are
> 
> 

This change results in the following Kconfig warning and compiler
warnings (or errors with CONFIG_WERROR):

  $ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- allmodconfig kernel/resource.o
  WARNING: unmet direct dependencies detected for GET_FREE_REGION
    Depends on [n]: SPARSEMEM [=n]
    Selected by [m]:
    - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=m]
  In file included from include/linux/ioport.h:15,
                   from kernel/resource.c:15:
  kernel/resource.c: In function 'gfr_start':
  include/linux/minmax.h:93:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Werror=overflow]
     93 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
        |                                     ^
  include/linux/minmax.h:96:9: note: in expansion of macro '__cmp_once_unique'
     96 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
        |         ^~~~~~~~~~~~~~~~~
  include/linux/minmax.h:213:27: note: in expansion of macro '__cmp_once'
    213 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
        |                           ^~~~~~~~~~
  kernel/resource.c:1874:23: note: in expansion of macro 'min_t'
   1874 |                 end = min_t(resource_size_t, base->end, PHYSMEM_END);
        |                       ^~~~~
  kernel/resource.c: In function 'gfr_continue':
  include/linux/minmax.h:93:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Werror=overflow]
     93 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
        |                                     ^
  include/linux/minmax.h:96:9: note: in expansion of macro '__cmp_once_unique'
     96 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
        |         ^~~~~~~~~~~~~~~~~
  include/linux/minmax.h:213:27: note: in expansion of macro '__cmp_once'
    213 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
        |                           ^~~~~~~~~~
  kernel/resource.c:1891:24: note: in expansion of macro 'min_t'
   1891 |                addr <= min_t(resource_size_t, base->end, PHYSMEM_END);
        |                        ^~~~~
  cc1: all warnings being treated as errors

Arnd had a patch in another bug report to resolve the Kconfig warning,
which happens to resolve the compiler warning for allmodconfig, but I
suspect that a configuration with SPARSEMEM and !ARM_LPAE could still
trigger the compiler warnings.

https://lore.kernel.org/aaee4ddb-68a8-42ae-bb68-11ef991ada1c@app.fastmail.com/

Cheers,
Nathan

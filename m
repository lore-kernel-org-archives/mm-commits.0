Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790201D1E6A
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729112540; cv=none; b=cdkT8mQmxrfaVKY3pcjum1NwV6bGMmCXo2F/+UOnV9HizhocuA8CNFqPX4CaVIG7M0H9uSKXukdfR7yEb5BvUPbmBngW1ShKsIDHefuVLyI/I8jIAuHJ8AYFDM4XJTrsD4SC35jGknU14+E5F44ruTcAIIwYqk/530I0xhuQWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729112540; c=relaxed/simple;
	bh=vMUdM/oSaP6Sn47yQR5n6cJDLrwads8HkrMPK2g0GMk=;
	h=Date:To:From:Subject:Message-Id; b=H/UL67bvorZI57ee7Q5Y5R5P7h15RvUMQBBNUi6kovUddx5pMRZGT/75jCzctKJY4hZm6SCoHiMcuq9XJDsznAhuc8kBWGpRCo64ZVHmoEtjy0uD5QWkwSd2ocbc/foeWIlfHS3kFOTexpk0IKS2m7vME5nWMg+hxtHYRM1bzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1AyXSlAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1AyXSlAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8DBC4CEC5;
	Wed, 16 Oct 2024 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729112540;
	bh=vMUdM/oSaP6Sn47yQR5n6cJDLrwads8HkrMPK2g0GMk=;
	h=Date:To:From:Subject:From;
	b=1AyXSlAg4PLhyALCZMVkpW0/xVYrO6lMhOP44+KqxMpVI+tYd1Oyt2P1yz8a85Rja
	 n+SCEhdDWvk6a8JaHn4veWEovs/XNMx/Ikuu/2YkkBBaLPO/+OdgJxgrevsDkbPVDj
	 nAKHMaxoE/EzXw1WggCbx6tSkns75BZVMemc2LC8=
Date: Wed, 16 Oct 2024 14:02:19 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,linux@roeck-us.net,jonathan.cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,arnd@arndb.de,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-remove-dependency-on-sparsemem-from-get_free_region.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016210219.EE8DBC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: remove dependency on SPARSEMEM from GET_FREE_REGION
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     resource-remove-dependency-on-sparsemem-from-get_free_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-remove-dependency-on-sparsemem-from-get_free_region.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: resource: remove dependency on SPARSEMEM from GET_FREE_REGION
Date: Tue, 15 Oct 2024 13:15:54 +0800

We want to use the functions (get_free_mem_region()) configured via
GET_FREE_REGION in resource kunit tests.  However, GET_FREE_REGION
depends on SPARSEMEM now.  This makes resource kunit tests cannot be
built on some architectures lacking SPARSEMEM, or causes config warning
as follows,

  WARNING: unmet direct dependencies detected for GET_FREE_REGION
  Depends on [n]: SPARSEMEM [=n]
  Selected by [y]:
  - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]

When get_free_mem_region() was introduced the only consumers were those
looking to pass the address range to memremap_pages().  That address
range needed to be mindful of the maximum addressable platform physical
address which at the time only SPARSMEM defined via MAX_PHYSMEM_BITS.

Given that memremap_pages() also depended on SPARSEMEM via ZONE_DEVICE,
it was easier to just depend on that definition than invent a general
MAX_PHYSMEM_BITS concept outside of SPARSEMEM.

Turns out that decision was buggy and did not account for KASAN
consumption of physical address space.  That problem was resolved
recently with commit ea72ce5da228 ("x86/kaslr: Expose and use the end
of the physical memory address space"), and GET_FREE_REGION dropped its
MAX_PHYSMEM_BITS dependency.

Then commit 99185c10d5d9 ("resource, kunit: add test case for
region_intersects()"), went ahead and fixed up the only remaining
dependency on SPARSEMEM which was usage of the PA_SECTION_SHIFT macro
for setting the default alignment.  A PAGE_SIZE fallback is fine in the
SPARSEMEM=n case.

With those build dependencies gone GET_FREE_REGION no longer depends on
SPARSEMEM.  So, the patch removes dependency on SPARSEMEM from
GET_FREE_REGION to fix the build issues.

Link: https://lkml.kernel.org/r/20241016014730.339369-1-ying.huang@intel.com
Link: https://lore.kernel.org/lkml/20240922225041.603186-1-linux@roeck-us.net/
Link: https://lkml.kernel.org/r/20241015051554.294734-1-ying.huang@intel.com
Fixes: 99185c10d5d9 ("resource, kunit: add test case for region_intersects()")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~resource-remove-dependency-on-sparsemem-from-get_free_region
+++ a/mm/Kconfig
@@ -1085,7 +1085,6 @@ config HMM_MIRROR
 	depends on MMU
 
 config GET_FREE_REGION
-	depends on SPARSEMEM
 	bool
 
 config DEVICE_PRIVATE
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-remove-dependency-on-sparsemem-from-get_free_region.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F53173357
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033906; cv=none; b=XyphRzkjZL43JnUwQkwQqeucNeTzf1QSD4LZgFi4F6DTGyySAKESN9sUh53xKm1fcIL1adqO1QuWg3tWIVJXYbvbw2zrx8rGAmqGCNRV5QjJFWHDQrTg6nV+bQrHgFFdkw9/NFK9phseSZlOsE8j7FPDOAWXXy/lSqlxc7ufiLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033906; c=relaxed/simple;
	bh=KshzPKGwYONjPuoZtlxIileKGO2akRNtpRJRnKG5n94=;
	h=Date:To:From:Subject:Message-Id; b=jLaHtMoJLN3twhi1QuPmqdJN2pcBPRKPDAQxRnRNABQYSBwHtonUzxiweUnVEGLuJG92UrcPjB19n9C2mfKGn9v8wlFP0aLhcehR/r9SU/EJ0kDwYsYmlDZRueRSFYs6jHNU1XcobNBKBNAhEhzAa20of6PPtWGnV8ykd3+AKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T4gKZNJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T4gKZNJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65384C4CEC6;
	Tue, 15 Oct 2024 23:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033905;
	bh=KshzPKGwYONjPuoZtlxIileKGO2akRNtpRJRnKG5n94=;
	h=Date:To:From:Subject:From;
	b=T4gKZNJrCUHpGQCWMsM/Ar+vzgVJkGj5XQUzlhzIlg3Mcp8ItXdkNGYeUAJQsWxm4
	 YX319q67gQqWbL8sta5p7ZY1UZcgrqQOX8pUcNgxT5L6DQExFvXEmz7FRcN8ET+H0U
	 4fcAMbh7oxl4I8/OEaPgeOJ0y5FAPKM7rfmPagTQ=
Date: Tue, 15 Oct 2024 16:11:44 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,linux@roeck-us.net,jonathan.cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,arnd@arndb.de,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-remove-dependency-on-sparsemem-from-get_free_region.patch added to mm-unstable branch
Message-Id: <20241015231145.65384C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: remove dependency on SPARSEMEM from GET_FREE_REGION
has been added to the -mm mm-unstable branch.  Its filename is
     resource-remove-dependency-on-sparsemem-from-get_free_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-remove-dependency-on-sparsemem-from-get_free_region.patch

This patch will later appear in the mm-unstable branch at
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

We want to use the functions configured via GET_FREE_REGION in resource
kunit tests.  However, GET_FREE_REGION depends on SPARSEMEM.  This was
done to avoid a small amount of bloat in kernel/resource.c.  This means
resource kunit tests cannot be built on some architectures lacking
SPARSEMEM.  In fact, these functions doesn't depend on SPARSEMEM now.  So,
remove dependency on SPARSEMEM from GET_FREE_REGION.

Link: https://lore.kernel.org/lkml/20240922225041.603186-1-linux@roeck-us.net/
Link: https://lkml.kernel.org/r/20241015051554.294734-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
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


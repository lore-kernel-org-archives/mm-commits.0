Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9954819
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719433994; cv=none; b=Yr7Ofrop0j12Vh6ZRfl8uDHjdvS588yjH5mk9TpNFv1c4pShUYDwwVJNuwQ89NXLbsLcMp/7WbeqbaM+FiIXjFmK4Pnl4fTx2OL6QmktiLfl9iNMxyX1DKVivdKPm/PzU6464f9BPpyK2g+cJX7GCoXJ7I1RV0Dr31b+OgjIEdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719433994; c=relaxed/simple;
	bh=TfdOqnXzNX9JDyEVlvRhZJ2+D/8K7UXR5zGF+tlSMJw=;
	h=Date:To:From:Subject:Message-Id; b=IfT/msbMiI0udcAA9/OP6xbAsEB6y3pUCljpcFBqcKxRglGLYPk41UHQyvFlgUpYblEU2xzCF48ETF6pYhF9+p3FpI9v9wxqUePZPthyvB0xpht7gaB+WouBzZtxlHOcf9xrLR4xezhgLfN2eHa9b//RT4c8zw5HBcHxpxTFEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PduOitJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PduOitJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99DC116B1;
	Wed, 26 Jun 2024 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719433994;
	bh=TfdOqnXzNX9JDyEVlvRhZJ2+D/8K7UXR5zGF+tlSMJw=;
	h=Date:To:From:Subject:From;
	b=PduOitJuEUOtdt9NySfntZVY/D1/Q6G8A59+3s6xlP7Oa4ISy0T09xxqNIdIi8C5C
	 ZJvTUfey9H+XU/mUKL0hAtFqWXD2c3HCWm4IC46gvva+b8flh+n4FuurkjnLLf06tt
	 GcB0x9ZkONwibdNqe/oRckAspURpoGMaks2EoflI=
Date: Wed, 26 Jun 2024 13:33:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-enable_soft_offline-sysctl.patch added to mm-unstable branch
Message-Id: <20240626203314.4C99DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: mm: add enable_soft_offline sysctl
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-enable_soft_offline-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-enable_soft_offline-sysctl.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs: mm: add enable_soft_offline sysctl
Date: Wed, 26 Jun 2024 05:08:18 +0000

Add the documentation for soft offline behaviors / costs, and what the new
enable_soft_offline sysctl is for.

Link: https://lkml.kernel.org/r/20240626050818.2277273-5-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -36,6 +36,7 @@ Currently, these files are in /proc/sys/
 - dirtytime_expire_seconds
 - dirty_writeback_centisecs
 - drop_caches
+- enable_soft_offline
 - extfrag_threshold
 - highmem_is_dirtyable
 - hugetlb_shm_group
@@ -267,6 +268,37 @@ used::
 These are informational only.  They do not mean that anything is wrong
 with your system.  To disable them, echo 4 (bit 2) into drop_caches.
 
+enable_soft_offline
+===================
+Correctable memory errors are very common on servers. Soft-offline is kernel's
+solution for memory pages having (excessive) corrected memory errors.
+
+For different types of page, soft-offline has different behaviors / costs.
+- For a raw error page, soft-offline migrates the in-use page's content to
+  a new raw page.
+- For a page that is part of a transparent hugepage, soft-offline splits the
+  transparent hugepage into raw pages, then migrates only the raw error page.
+  As a result, user is transparently backed by 1 less hugepage, impacting
+  memory access performance.
+- For a page that is part of a HugeTLB hugepage, soft-offline first migrates
+  the entire HugeTLB hugepage, during which a free hugepage will be consumed
+  as migration target.  Then the original hugepage is dissolved into raw
+  pages without compensation, reducing the capacity of the HugeTLB pool by 1.
+
+It is user's call to choose between reliability (staying away from fragile
+physical memory) vs performance / capacity implications in transparent and
+HugeTLB cases.
+
+For all architectures, enable_soft_offline controls whether to soft offline
+memory pages.  When set to 1, kernel attempts to soft offline the pages
+whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
+the request to soft offline the pages.  Its default value is 1.
+
+It is worth mentioning that after setting enable_soft_offline to 0, the
+following requests to soft offline pages will not be performed:
+- Request to soft offline pages from RAS Correctable Errors Collector.
+- On ARM, the request to soft offline pages from GHES driver.
+- On PARISC, the request to soft offline pages from Page Deallocation Table.
 
 extfrag_threshold
 =================
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch


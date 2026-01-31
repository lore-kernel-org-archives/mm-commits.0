Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171838A736
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898308; cv=none; b=p3zid30dQ2P6j4/lbOhskmy2yFnrgDlAkEtm1wnIEyN5efT8JYi42qvUosOKsa6G/QuNbM+r+PGujpVfxQ26BYJtmEUC02uScDZu7p7KaVFzfwpNmYMrZztCwsjCZ8yAdVGyaACdJrj9hs/yyp32i+Ktg7p3UfnsgiobDNbRGm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898308; c=relaxed/simple;
	bh=eTsIsP3M8/X/NOLtImkhdBW4Ix+5VV6poAMMS4LTz3k=;
	h=Date:To:From:Subject:Message-Id; b=LAg2Xo/N7/D/jHlDzdTfE3Yqwo/UlEKv9hrefdoYc2vkDIaz5TxQGsYnjULYwAiyu+lpsD7FNGzLVJ3VULMxYu/E0JMODrOrWp7gfMs+PS6X9lhKmFrF/pdH+B6kG+PAaFbPlfKcFoyPBhInVRwmJkRV41nDIFp0KhGO1XTNNS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3e0UvS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3e0UvS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F7C4CEF1;
	Sat, 31 Jan 2026 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898308;
	bh=eTsIsP3M8/X/NOLtImkhdBW4Ix+5VV6poAMMS4LTz3k=;
	h=Date:To:From:Subject:From;
	b=Y3e0UvS6AcaRnpaJ/71MdVrC5a+jiDi9KH6H/9U/b+4WbLbOE3izqowOkw0T2M9ce
	 lC6kGq27gfjKZdu6H+8/I99S0koCPPh3dCWASz3VIZmrmYZTUHJcSLxq61yjmSjik4
	 +GjVYN5HGfs6pxcIUOuWipbJrxRxRjuBX5JQuRkg=
Date: Sat, 31 Jan 2026 14:25:07 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-flaky-header-check.patch removed from -mm tree
Message-Id: <20260131222508.181F7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove flaky header check
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-flaky-header-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: remove flaky header check
Date: Thu, 22 Jan 2026 17:02:17 +0000

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel is
not compiled") introduced a check to avoid attempting to build the
page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to /lib/modules/...  or
an in-tree kernel build.  It always fails if KDIR points to an out-of-tree
build (i.e.  when the kernel was built with O=...  make) because only
generated headers are present under $KDIR/include/ in that case.

A recent commit switched KDIR to default to the kernel's build directory,
so that check is no longer justified.

Link: https://lkml.kernel.org/r/20260122170224.4056513-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-flaky-header-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



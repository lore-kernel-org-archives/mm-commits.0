Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A818F2E5
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718654335; cv=none; b=dScL42nHEjL0laZ2NkexTsZIxMBV3PIcbBv/7brhKK+49TjGjojASUqfioIaf8qEcAbEZmUV5YrWcxyz/gbMzShwaoGL5Q6HXBh4l0wq59iT7YgerHgwkNBRwSa+LQrQbb6lN1F8vQFeoBiV7jJsWcu0TZ0H28+OWGX699Nz9sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718654335; c=relaxed/simple;
	bh=xzC0Qjo5eVvN20/A6HGQp2k9ltoR9AJfS5tWVK9t1/Q=;
	h=Date:To:From:Subject:Message-Id; b=aEXH94ob4b+o97XANu6i6eQ78tStDElteRwUfT22qNS/BTO9BzV9EtKN0eWqlJXz/8m894R9jFRsmVyyO5nbzON4NgXT4bIcbmH0DZ2s/NBXs84H0WzpTS5CaJzYdqzMoOO2JHMFWJpzRu8BL7jTNXTUNtLApDz8UocqvDASzCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EOwFrAFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EOwFrAFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55288C2BD10;
	Mon, 17 Jun 2024 19:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718654335;
	bh=xzC0Qjo5eVvN20/A6HGQp2k9ltoR9AJfS5tWVK9t1/Q=;
	h=Date:To:From:Subject:From;
	b=EOwFrAFe8hwmHQbqQqAWJD07djrkDdZ7nz5c3XtQGoYd6OYwgrMULyls9ccBvt0hQ
	 EI4bD1eOGTfaDhDfaVdCuRVhWuGLyXKmfNLTNN8xCdz6kPxtVdlcI80RCl2jlvE1p+
	 jWRo+KEr6jmqO+XeD4zTk1BXX6wr3th8hsLSMktM=
Date: Mon, 17 Jun 2024 12:58:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-radix-tree-add-missing-module_description-definition.patch added to mm-nonmm-unstable branch
Message-Id: <20240617195855.55288C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/radix-tree: add missing MODULE_DESCRIPTION definition
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-testing-radix-tree-add-missing-module_description-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-radix-tree-add-missing-module_description-definition.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/radix-tree: add missing MODULE_DESCRIPTION definition
Date: Mon, 17 Jun 2024 12:52:21 -0700

Userspace builds of the radix-tree testing suite fails because of commit
test_maple_tree: add the missing MODULE_DESCRIPTION() macro.  Add the
proper defines to tools/testing/radix-tree/maple.c and
tools/testing/radix-tree/xarray.c so MODULE_DESCRIPTION has a definition. 
This allows the build to succeed.

Link: https://lkml.kernel.org/r/20240617195221.106565-1-sidhartha.kumar@oracle.com
Fixes: 9f8090e8c4d1 ("test_maple_tree: add the missing MODULE_DESCRIPTION() macro")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c  |    1 +
 tools/testing/radix-tree/xarray.c |    1 +
 2 files changed, 2 insertions(+)

--- a/tools/testing/radix-tree/maple.c~tools-testing-radix-tree-add-missing-module_description-definition
+++ a/tools/testing/radix-tree/maple.c
@@ -19,6 +19,7 @@
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
--- a/tools/testing/radix-tree/xarray.c~tools-testing-radix-tree-add-missing-module_description-definition
+++ a/tools/testing/radix-tree/xarray.c
@@ -10,6 +10,7 @@
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-remove-setclearhpage-macros.patch
mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch
tools-testing-radix-tree-add-missing-module_description-definition.patch


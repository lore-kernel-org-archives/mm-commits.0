Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35197BA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628853; cv=none; b=eDhoPFvyicAVk4M+8OYOfD8OiiI98npV0eIm7tiDj5cgaBR3MWhrmfJczG98pQkCw7AKgGoiYsfMDDk7WNNcDxRdJxjClRI6jPm1CRjP+TuaRzlaYEDIIuvwAPogOS1vxxjKNqJwUmXjsTg1xfzQPxyFBMONzUduWOA94ZcB1iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628853; c=relaxed/simple;
	bh=Hs2d48W38N3Z+VKGCNYulmZT0UJzJFcp68APjoail/k=;
	h=Date:To:From:Subject:Message-Id; b=IknX8h+6v7t+uKhrV9DDoynyoVByJO+RauUgZ045K16iBEKEuTWzkiWJk/hKnD0ZzpO6FQDZ8oWOYwvjR7YzXT6q8AJQ+wG7CbLzQQ2gDEI5kLRkleI3/Dz++pIKNsGCAugz9GDs2QoQHBuLxaSkuHxr94S756xfoZ8ky7Gv0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1FqaQUaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1FqaQUaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E35C2BD11;
	Wed,  5 Jun 2024 23:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628853;
	bh=Hs2d48W38N3Z+VKGCNYulmZT0UJzJFcp68APjoail/k=;
	h=Date:To:From:Subject:From;
	b=1FqaQUaEsVMI5g9gzRCYaIUGtYHiJgXk/gONdoUQdFFrdROPJMHhU/pa7T21B51Ip
	 rGOqQLoXdawhqmc/vfOfev5wSvTDsbSNjBGNjca84jMzS7nZ01JcG90syhBpinltuL
	 bruNb8A1Zq2IKfFY/b7RToFgEg+wiiesqnpzNk80=
Date: Wed, 05 Jun 2024 16:07:32 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uuid-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230732.E1E35C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uuid: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uuid-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uuid-add-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: uuid: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 19:19:09 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_uuid.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_uuid-v1-1-67fa498104c0@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_uuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_uuid.c~uuid-add-missing-module_description-macro
+++ a/lib/test_uuid.c
@@ -130,4 +130,5 @@ static void __exit test_uuid_exit(void)
 module_exit(test_uuid_exit);
 
 MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
+MODULE_DESCRIPTION("Test cases for lib/uuid.c module");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch


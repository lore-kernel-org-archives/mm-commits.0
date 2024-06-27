Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CD4A3D
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 21:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719524983; cv=none; b=TRAugXTkPF80zKNsRZZChyQ+Oxr6QUGo3Vklym7YbG6k1eGme8YMj0LD7TWA4SqeNL/8g0eR8UcUfQ1SLDKEytl2Y4Q2W4qNMNnBf6iEU5ArtorO3PxbgeH9hGrBOXu3TTTRgwgOeUckZLM+bWMVcy4DbfwMqtoMzugwfl5ZmM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719524983; c=relaxed/simple;
	bh=dKU73ByM+/zoqErCWIYFVvdZYJTlUpGUDmq223tgkx8=;
	h=Date:To:From:Subject:Message-Id; b=hKWZUK3OaRh9ZSogSrTUSPB7erkafED5wK+gJ8snvq4cPrq9toymHfNZAxljAvFKf6Sd17htgmkYWkCftW1EVWqxIS1vjwPH7lnoRyXVn9wQc54yItAO8udUAsg0oy9ZzHAnwuBW+OUKq3ZyLUu9CBj5CyEV6Xn55n1izdF/Gyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uo1K5qjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uo1K5qjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E91C2BBFC;
	Thu, 27 Jun 2024 21:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719524981;
	bh=dKU73ByM+/zoqErCWIYFVvdZYJTlUpGUDmq223tgkx8=;
	h=Date:To:From:Subject:From;
	b=Uo1K5qjnHYkl/ARZmWoxR9PYj+kEonbRUhfH/AWMfXA0TOjGVM2Vr5f2ZaIpIgLmB
	 vcYYql6ODT7bPTMGXLXyIRFuaMr7C8clF1xsWAS4Rnsi0/galz4/gMG/xajSz46+Tb
	 grQFn4lh+djqo4SU6iZbjlBup7aX+9/sU0Rph038=
Date: Thu, 27 Jun 2024 14:49:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch added to mm-unstable branch
Message-Id: <20240627214941.60E91C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/radix-tree/idr-test: add missing MODULE_DESCRIPTION define
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/radix-tree/idr-test: add missing MODULE_DESCRIPTION define
Date: Wed, 26 Jun 2024 16:21:00 -0700

Userspace builds of the radix-tree testing suite fails because of patch
KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko.  Add the
proper defines to tools/testing/radix-tree/idr-test.c so
MODULE_DESCRIPTION has a definition.  This allows the build to succeed.

Link: https://lkml.kernel.org/r/20240626232100.306130-1-sidhartha.kumar@oracle.com
Fixes: 303474913271("KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/idr-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/radix-tree/idr-test.c~tools-testing-radix-tree-idr-test-add-missing-module_description-define
+++ a/tools/testing/radix-tree/idr-test.c
@@ -424,6 +424,7 @@ void idr_checks(void)
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()    assert(0)
 void ida_dump(struct ida *);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch


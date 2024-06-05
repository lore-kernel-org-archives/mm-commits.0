Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E961161308
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629037; cv=none; b=CQCLV6CS01BmGnNPB2oe1/NR8Q0XwP4kBQj7IVqkq3niMb1OpgvlNPUd3WxUeO35tGV7Uzk/JBPO+wMGrqVSQfjymu9hdV2XqD44KenCSYgVIVXMAqROLx7Z5UBUlrzHP0ssGOr5kbu06EHyuLA9lWJs1erUYuRaxhr7Q5QKwqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629037; c=relaxed/simple;
	bh=kqkrVztL2oBuGwpy1y91gXhbrIf00ihyHGKQ71e71zc=;
	h=Date:To:From:Subject:Message-Id; b=K8p1vpzOPKLSbRgEukxeg0xqcnCaHaiLtlkYD2LKQCA3+4mn3WlCLl4h7vLXNQPn8stn3JqMbuyZyO/1ISH4ph/yWc1tmOybvpcmIyTYVtslXzajupj461dHGoM4mDOa28vd/qxoeapZRLtFJFuICdwm50KRjU1ecsiytvLKc/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LKyB71HK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LKyB71HK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A329FC2BD11;
	Wed,  5 Jun 2024 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717629036;
	bh=kqkrVztL2oBuGwpy1y91gXhbrIf00ihyHGKQ71e71zc=;
	h=Date:To:From:Subject:From;
	b=LKyB71HKZhqwH0ZTxFugKH4g+uF1wuLQKDBOUijVFuOjeTX/QR/evu/dVke0rekNq
	 pt9fnqxat1Uq3NTLqBzPWy4oMIBbhyC6gXdSgsRm7z1F7U+kTOLiYpYNgCd3QKg54D
	 583+cnZ7uqlaOfK+9K9n17ULAxuZCFJanNzHkqrc=
Date: Wed, 05 Jun 2024 16:10:35 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-add-the-missing-module_description-macro.patch added to mm-unstable branch
Message-Id: <20240605231036.A329FC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_maple_tree: add the missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-unstable branch.  Its filename is
     test_maple_tree-add-the-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-add-the-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: test_maple_tree: add the missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 17:13:16 -0700

make allmodconfig && make W=1 C=1 reports: WARNING: modpost: missing
MODULE_DESCRIPTION() in lib/test_maple_tree.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_maple_tree-v1-1-7b1b485aeec3@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_maple_tree.c~test_maple_tree-add-the-missing-module_description-macro
+++ a/lib/test_maple_tree.c
@@ -3946,4 +3946,5 @@ static void __exit maple_tree_harvest(vo
 module_init(maple_tree_seed);
 module_exit(maple_tree_harvest);
 MODULE_AUTHOR("Liam R. Howlett <Liam.Howlett@Oracle.com>");
+MODULE_DESCRIPTION("maple tree API test module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
test_maple_tree-add-the-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch


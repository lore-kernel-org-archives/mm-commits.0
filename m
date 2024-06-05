Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8616191A
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629192; cv=none; b=hcWp3nYGsvvIEpgLMuHMoxa/RPnOQs0Q9+85EsUp/J82zNZIA/8ActyeSrziEGj6X9zwMosULXVaUkUDzbY1W47wnFZQuGoiUjPzSIsXxOAqNEzczePBb9Ya0/wEK9TjfKamaLDZvpJEKJYSYF18msXEdMr6yk5vu+stVrSLvyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629192; c=relaxed/simple;
	bh=NRujuNk+kt/iypbal3co99C5YDIFoAPQBFTMP0lphEQ=;
	h=Date:To:From:Subject:Message-Id; b=QCC8jYWFLUEztqKz3p6HH8irfr5CuMKKge4yXfppL6lTJvS7wa0BzgvTwHeWvo9dIpNyUvqBy55/h0jOWHjNKdtEzWP/mUmcFvr7/jrT2iuUBe4jYU2H3loApEBeHTJx3fKgmruhVDjqeVdGb1SGTAFjGN6MP6RJjmDmEXVCLgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1/Bmic6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1/Bmic6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A59C2BD11;
	Wed,  5 Jun 2024 23:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717629192;
	bh=NRujuNk+kt/iypbal3co99C5YDIFoAPQBFTMP0lphEQ=;
	h=Date:To:From:Subject:From;
	b=1/Bmic6CAVEWm37canEj5ilcBxmYpvpj1xtErTsgWZTNzcM/qwfYUY8JrKuF2rxWY
	 /ZykuJuUpvh0OHVfWOKMX3dSrU/1OB7bT8wTrgr15Qq+0XPtlCZp9Nt1n/0kx0d+wn
	 sYDadEUl5UXD/SV0+mMW8lnipMPVsxz96qcotsHU=
Date: Wed, 05 Jun 2024 16:13:11 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-test-add-the-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605231311.F0A59C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_test: add the missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-test-add-the-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-test-add-the-missing-module_description-macro.patch

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
Subject: lib/list_test: add the missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 16:58:42 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/list-test.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-list-test-v1-1-50b79241cbb0@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/list-test.c~list-test-add-the-missing-module_description-macro
+++ a/lib/list-test.c
@@ -1499,4 +1499,5 @@ static struct kunit_suite klist_test_mod
 
 kunit_test_suites(&list_test_module, &hlist_test_module, &klist_test_module);
 
+MODULE_DESCRIPTION("KUnit test for the Kernel Linked-list structures");
 MODULE_LICENSE("GPL v2");
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
lib-test_hmm-add-missing-module_description-macro.patch
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
lib-test_linear_ranges-add-missing-module_description-macro.patch
list-test-add-the-missing-module_description-macro.patch


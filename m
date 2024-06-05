Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977EBA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628992; cv=none; b=DYioeQrrIBBholowyrXRSU0YzjlKCk6o0nQcxFcPFknWsL0EV8w82/KjHbt27cRRc1yfqU3QBOca0HSqJV0sHabi5lLw1TAsmccXFCE3cXfFAr2RLj6R/eFgZVKyPLyNAWykYymdt+27sFbR6iHUFWklp0IRsMrAFyL091ixmQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628992; c=relaxed/simple;
	bh=nTLmnUkqrRBpC2O9RUqH7K7e7+h6mIwfcMjRUEXuavM=;
	h=Date:To:From:Subject:Message-Id; b=HTTVL7JuSXlP/afmwpK5d31PYffZLlQkYVqe5cFoPrRQm4mRcF0+bbiyEVFzZwV6RQWc6V7I1oYXp6Qb+dTCSe6eIRLHiLWxPh93eYgSowBFZiftkGTqpGZw41JSleIKNb+/Pkj5w7sC/nWe0mWHWobc9977UtHLIrEghYV6hUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zTtqFhSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zTtqFhSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A1C2BD11;
	Wed,  5 Jun 2024 23:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628991;
	bh=nTLmnUkqrRBpC2O9RUqH7K7e7+h6mIwfcMjRUEXuavM=;
	h=Date:To:From:Subject:From;
	b=zTtqFhSAMucCzKmZs/J/YCaswAH6nmz6Jmzjc/kTuxUgsVtRstrxSCW5ppWdD2i96
	 SXs3NyjJptSiXKQ0cTfIdMa9dkzqGaiNLQ6o35ph4csQua4I83VTSZXo9kcG8CRxNK
	 xwn6w9SBLr9QV1aru9wPaenijuRlKUn6n+97jD/M=
Date: Wed, 05 Jun 2024 16:09:51 -0700
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_kmod-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230951.CF6A1C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_kmod: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_kmod-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_kmod-add-missing-module_description-macro.patch

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
Subject: lib/test_kmod: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 17:23:09 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_kmod.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_kmod-v1-1-fdf11bc6095e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_kmod.c~lib-test_kmod-add-missing-module_description-macro
+++ a/lib/test_kmod.c
@@ -1223,4 +1223,5 @@ static void __exit test_kmod_exit(void)
 module_exit(test_kmod_exit);
 
 MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@kernel.org>");
+MODULE_DESCRIPTION("kmod stress test driver");
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


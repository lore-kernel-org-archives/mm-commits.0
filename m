Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A77A1419A0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291641; cv=none; b=kMdHjim8606FRu9X9DI9RfRqfMEDyqlfEfxqreHBjS/6fpHQvdpCbyyR3GW0pM9QIRR24F8CFe7cciuNyU4v4IVhtpsD1fCf2ZUgR4GcAFPJhk+OtQbRhADUe8OSxPzQFXX0WiE0fQACRPfnsNlcCWOnMGPQkyWClRptfDgtuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291641; c=relaxed/simple;
	bh=tNGr6rbqFw4OEaOISAQWpO4owS5RY7MBNoWkgEC9N8U=;
	h=Date:To:From:Subject:Message-Id; b=IsnMccDtaZEQ0W9i+jZwM1oWWCW0hHcbwNrP+tzeYVFyNE07aUheGD/CGzP3kz48HIZwHBLeH18GHzGhkxXyf6vwW3t8ACK2485LyAoeehmxbXmstBy8XvtulJ8C7K0Pe1aTxAdzvCs/MyC3z8b1QSQsr00IE1XV7qf+oQBd+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcDsL+Qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcDsL+Qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42632C32782;
	Tue, 25 Jun 2024 05:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291641;
	bh=tNGr6rbqFw4OEaOISAQWpO4owS5RY7MBNoWkgEC9N8U=;
	h=Date:To:From:Subject:From;
	b=LcDsL+Qh/3hFGhSKLTijGxmibRkLQeM1R4Xo7RtrW+4lfzKXUZgFYFMLbaBG0CGKe
	 P3aoMnYwBTTxAiDJT+lyZt+eejVrHIJmQ708clOFuZjXCmWfKhBvZhCxGaI+MZDxRi
	 gbTj78E/W8td4dQSobAjL0DfwnWYRv/FGRQ2UzpY=
Date: Mon, 24 Jun 2024 22:00:40 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmemleak-test-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625050041.42632C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmemleak-test: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     kmemleak-test-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kmemleak-test: add missing MODULE_DESCRIPTION() macro
Date: Sat, 1 Jun 2024 18:05:00 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kmemleak/kmemleak-test.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-samples-kmemleak-v1-1-47186be7f0a8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kmemleak/kmemleak-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/kmemleak/kmemleak-test.c~kmemleak-test-add-missing-module_description-macro
+++ a/samples/kmemleak/kmemleak-test.c
@@ -96,4 +96,5 @@ static void __exit kmemleak_test_exit(vo
 }
 module_exit(kmemleak_test_exit);
 
+MODULE_DESCRIPTION("Sample module to leak memory for kmemleak testing");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch


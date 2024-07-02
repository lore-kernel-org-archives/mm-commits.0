Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E812B83
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719904558; cv=none; b=AlA1t7UTRne1Y97w4O5ujbnNhAHiT4PKhgMtGTal0eRa3rgcgbZuCNOx7lIEQS0/x5J2J78oPW3LxtoddWwiqUj8tIEZ2/VrYpPPJ72yXuj/LPEvO8DCbg7EGJbFXT4sdwv638BaMxpu7bLXNAPsQkeFVxv58QFEgKxhT6g1NQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719904558; c=relaxed/simple;
	bh=2+JSxIVWn1JN3AObt+D6JVHP5CIbEN1S9w30EH0ONWw=;
	h=Date:To:From:Subject:Message-Id; b=jAivOkmmROlNd6W+Vh1z7dXKvMtZAKBATPupP5/HvEbzRMWHF4HrBiF+9YbHmPPWmNHZsAjKpkUlDcgNAun9CxfjDfeWQhQt3Eb3YhQmBzSNU191Rsy8V5mInWl1b7/KxhE5rjf6zxqzB1n+j6JGFgfX2eLHLFfkuXTLR4AUZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PPLlcekd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PPLlcekd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50F2C116B1;
	Tue,  2 Jul 2024 07:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719904558;
	bh=2+JSxIVWn1JN3AObt+D6JVHP5CIbEN1S9w30EH0ONWw=;
	h=Date:To:From:Subject:From;
	b=PPLlcekdnvTbELcu1r9hOO7UYaHk4NVJvMmYVc18oxPDamnEgFEwFmxWw0ZSeIXiF
	 T0qbfPv265WqcvSkBhGhWyf0oh/nxk8UPzsOvcWwtXgSXn4VG5nTcgfvKZ/Iaf5mHx
	 P9/T2Oyyn/jpqpMru5Z8cNeHRIFqbHCYlVFYiHpo=
Date: Tue, 02 Jul 2024 00:15:57 -0700
To: mm-commits@vger.kernel.org,guoren@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240702071557.E50F2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/zlib: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-add-missing-module_description-macro.patch

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
Subject: lib/zlib: add missing MODULE_DESCRIPTION() macro
Date: Thu, 13 Jun 2024 22:01:09 -0700

With ARCH=csky, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/zlib_deflate/zlib_deflate.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240613-md-csky-lib-zlib_deflate-v1-1-83504d9a27d6@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_deflate/deflate_syms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/zlib_deflate/deflate_syms.c~lib-zlib-add-missing-module_description-macro
+++ a/lib/zlib_deflate/deflate_syms.c
@@ -17,4 +17,5 @@ EXPORT_SYMBOL(zlib_deflate);
 EXPORT_SYMBOL(zlib_deflateInit2);
 EXPORT_SYMBOL(zlib_deflateEnd);
 EXPORT_SYMBOL(zlib_deflateReset);
+MODULE_DESCRIPTION("Data compression using the deflation algorithm");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

fs-ufs-add-module_description.patch
lib-zlib-add-missing-module_description-macro.patch


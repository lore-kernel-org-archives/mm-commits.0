Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173DCBA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628805; cv=none; b=HcpmAlvyXXlMuvhhQ+3HBCehT9i9tr9IJQSdGuqrpfz9R+f3cu1N5khI+iKDAZIZmX8WFtgl4XPMyKMXuKkRgbb0Od4CR9PhDOfqA3VVzxREeqI4ZnKw0MG6ugE/Yf6oeB3TN7C4eGx25xCbyoja0hKwIUES7VZslRwvMfQNdb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628805; c=relaxed/simple;
	bh=ClNU3SZ8/CIR2zdcijhB5sLWiEItHSEVMePBFP1eJmY=;
	h=Date:To:From:Subject:Message-Id; b=bTLybpuwwdtH93zJIS8N7iKptFQRrrhiH2V2Ug8hxMsx0rdF0VFP4VgBHo9Vg9/PZJLSIj4zSg51IaxbdTKd/+kBv96JLo3stwcA/OxrVk/diIeLu44mNqs+2gml8V1naCvL3+sUYSKXwRqlh0z1oIld1n/eosLjnm4LiaaiUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sxjmo6vH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sxjmo6vH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3DBC2BD11;
	Wed,  5 Jun 2024 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628804;
	bh=ClNU3SZ8/CIR2zdcijhB5sLWiEItHSEVMePBFP1eJmY=;
	h=Date:To:From:Subject:From;
	b=Sxjmo6vHntRfdIVUoYnEwqiyZ/j144BbgU/FuYMSRfYWpv1GySqoF0VxEnKAv0V5a
	 8dIt0WbFGkNMIYF62/4HpWul+qjrOZTnmwytxdcVyLK4P5xWHOTkTVcWoKuPTG1tLW
	 /ErcuVRajFOg3O4vAW1+1Dz6rtHIG8Xc0cMRNeHw=
Date: Wed, 05 Jun 2024 16:06:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-add-missing-module_description-macro.patch added to mm-unstable branch
Message-Id: <20240605230644.6D3DBC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-unstable branch.  Its filename is
     test_xarray-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-add-missing-module_description-macro.patch

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
Subject: test_xarray: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 20:08:37 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_xarray.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_xarray-v1-1-42fd6833bdd4@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_xarray.c~test_xarray-add-missing-module_description-macro
+++ a/lib/test_xarray.c
@@ -2173,4 +2173,5 @@ static void xarray_exit(void)
 module_init(xarray_checks);
 module_exit(xarray_exit);
 MODULE_AUTHOR("Matthew Wilcox <willy@infradead.org>");
+MODULE_DESCRIPTION("XArray API test module");
 MODULE_LICENSE("GPL");
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


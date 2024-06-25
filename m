Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376C143C5B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291645; cv=none; b=ljF/d1xsOc0jfUsZNRmKnHCNRKgP0GePMQYDdDMkDT9nU7egsTSnJpYI4+wGTvZUxXCrLTgNAgfByy6DPROdg9imD5AgYNzw/2MzpZjnNjdsHcIZ+GCZOO8S40ZsohUkAugGUf6jPGuXB+N4URhLcqjlbR3jJat2axUFOUyyxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291645; c=relaxed/simple;
	bh=5+9IfcQohNUbhX6hNqLTxSKyeq7KxnUG9KLbTQBwEUo=;
	h=Date:To:From:Subject:Message-Id; b=Z82PqlxVa2ODDV2azTHSprE2NC8tb6NtXX4T7bxLHX+sCGnaOcMhi61SUvyNSk6jGlMyFPg3v2K+kc157XO7kCQQjm4IonOEuRTKbuFTAWXz39xm/0R2UWYvI2PDSX1OBp5ja552+FXArS+GEz6fGdE3e+aF0Zshq4knlgrna00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=unDMUfWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="unDMUfWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06048C32782;
	Tue, 25 Jun 2024 05:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291645;
	bh=5+9IfcQohNUbhX6hNqLTxSKyeq7KxnUG9KLbTQBwEUo=;
	h=Date:To:From:Subject:From;
	b=unDMUfWKVW3ARuE+IV0AoVNuOORNVU88jaqqm+t1fOOktGpJ6wuAawqrybLAod8le
	 80uSw+/b7KGWMI/h/2hWJ5w4G2hYrv08ZI1lL3UmAwEdMO1chGlj2LSPNuCk1RepQr
	 8u1f/Qw8enMzrdh5NjIv1u25HIhCHUT78iIyA7jE=
Date: Mon, 24 Jun 2024 22:00:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] test_xarray-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625050045.06048C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_xarray: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     test_xarray-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


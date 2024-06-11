Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84308482ED
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718125115; cv=none; b=LwsGUWBjTxAzfJk5LAajQ0wkcMnVPHasE/+MAfoEPybLQKk/RgO1E7yzltyPi3OU9BOHi0ntwsteuMosl8Lw0N4wYuR43yn2brpQxXe7U7g7YJ+HRzwKHH54nwn7ow4LhA1OnRal1mpQ6jvIHT7EiYYH3Zx+JQM7alWbP3gZmxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718125115; c=relaxed/simple;
	bh=hVXbYtY/ElXFzDBUUQzL+4uOftXCRYYXxVyB0B6splg=;
	h=Date:To:From:Subject:Message-Id; b=esvMtI8yrj8WqBqOJbw21U8o5ZSZjn2pHjzBbt9XTSGE89i1Pp53TXeSLWRTWm52pyHfRaD6zCktrri53D8y8ZTqyRJ77igHbPIdi4gwdIdPa/sbPQI/sMn+v371rZZF3K5aRzispT31T0mt5PoTN5ivV2rKdj/CkGftWovRnqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QTc//Vz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QTc//Vz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4A8C4AF49;
	Tue, 11 Jun 2024 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718125115;
	bh=hVXbYtY/ElXFzDBUUQzL+4uOftXCRYYXxVyB0B6splg=;
	h=Date:To:From:Subject:From;
	b=QTc//Vz/6Ne5sIOOpDH+hHRdoaXXJ8jOmzM+ZCIQeYu1U6zikVzUGIJrPwxXI5Ve0
	 JqDPLrgoOlMQ5tA/LsUY9ImjWgh/JUTPomquOHvarjIoov/DuQ9fxL17ZH2KGFl1Kh
	 qYzU+FhI24jKxaI+edo9PxV9+Vfb0vPRp+o8cMLQ=
Date: Tue, 11 Jun 2024 09:58:34 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,linux@treblig.org,davidgow@google.com,brendanhiggins@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] list-test-add-the-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240611165835.2A4A8C4AF49@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/list_test: add the missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     list-test-add-the-missing-module_description-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib/list_test: add the missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 16:58:42 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/list-test.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-list-test-v1-1-50b79241cbb0@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
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
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch


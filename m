Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0584618638
	for <mm-commits@vger.kernel.org>; Thu,  6 Jun 2024 02:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717641555; cv=none; b=tT3WoW0dVUX3gB18PeGuOnJox9nYV8R5TkHgrKRXMmS+UvVlIX5UGxSl+9uU1IL2fT9yJRX6n34KgSt9tI7PD6b7C6wcYePYJDb1INDQZCEiqewF9EI6yA3qPZGL+KI88pLBVU8DlGlbIJX4bK0kTVbSOqo5P5DIuDrmFExZ+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717641555; c=relaxed/simple;
	bh=cp9xJXygnsbxIzWFgvFdCFOGzZei/Dc3nkh3yYiIer4=;
	h=Date:To:From:Subject:Message-Id; b=kyic2f9grQk9JkrI5pDSEpNKIKE5qQG05f6rgOyaTa87koEffmrRSud8M+enwS2DmwBh6/vHDE06Ox+uCsXzRQ+fkmDBWfNBhF0rWKfj83G8+nw8VsXmV7hkF1MdogUylCWyz2X5n0/Lig9mnjXSbiJYzfdhf3+haj5j89pfU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b37ja+vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b37ja+vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA3EC3277B;
	Thu,  6 Jun 2024 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717641554;
	bh=cp9xJXygnsbxIzWFgvFdCFOGzZei/Dc3nkh3yYiIer4=;
	h=Date:To:From:Subject:From;
	b=b37ja+vl4PNaM7pw0SlaegyqI8IipbTvtrxYEYTSB6UTVq6vI97+uHWGgVACL02sD
	 nozncn2zJvEfjtTVhqRtuthJZnGSMeBvjzo2bDtblcoUDR9n5ezxj+lk0fwD3SZld3
	 lU7mxLSDptZXIVGULlAQjrfox0xgjXNyEqe9GIsQ=
Date: Wed, 05 Jun 2024 19:39:13 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,gregkh@linuxfoundation.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] dyndbg-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240606023914.7BA3EC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dyndbg: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     dyndbg-add-missing-module_description-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: dyndbg: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 15:01:14 -0700

Make allmodconfig && make W=1 C=1 reports: WARNING: modpost: missing
MODULE_DESCRIPTION() in lib/test_dynamic_debug.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-test_dynamic_debug-v1-1-2194b477f55e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_dynamic_debug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_dynamic_debug.c~dyndbg-add-missing-module_description-macro
+++ a/lib/test_dynamic_debug.c
@@ -162,4 +162,5 @@ module_init(test_dynamic_debug_init);
 module_exit(test_dynamic_debug_exit);
 
 MODULE_AUTHOR("Jim Cromie <jim.cromie@gmail.com>");
+MODULE_DESCRIPTION("Kernel module for testing dynamic_debug");
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
list-test-add-the-missing-module_description-macro.patch


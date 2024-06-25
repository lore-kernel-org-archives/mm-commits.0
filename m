Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5929513D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291587; cv=none; b=fl5PcEBXTm0GTBeYBoVVJFoNbP6mPl6syEFH+I0x6xzZdObcVOU5FKAo+X17IsApwF5VSOchfgyVEdUQw6QcmQdEK+xRKA7tE079d7OvLwbgdOJZD3zPUQUPsxmfRgLoH5eEa7LbmCVd8paii2T2WwUX6dzEW+nFLv+HdzL4cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291587; c=relaxed/simple;
	bh=r7fTEDsZPp90licWft2Ia9iv7o/ZCbYeGMcgKzHADYE=;
	h=Date:To:From:Subject:Message-Id; b=C1qUKIZ8PSNxSHws+yUbd3WuEZQaPC2x9EPjpZGznC00A2TRAVkS8T+4a9IQLZjYYs8dBc6chrj12aNJgyBx0Vf8oj7hahmkbi3Igu1/lJHdrTEqdumOJl34hDzDNapbEU47eU3INb1YwadMo166ooWFoxsBcsyM1Q/2+0Q97sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u43ZWzt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u43ZWzt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF1CC32782;
	Tue, 25 Jun 2024 04:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291587;
	bh=r7fTEDsZPp90licWft2Ia9iv7o/ZCbYeGMcgKzHADYE=;
	h=Date:To:From:Subject:From;
	b=u43ZWzt+576obkvEDSOhe8kkXqZ6+JIAMzBs/y9L+uPXQl/vjlsNR2KzN9Hi4zfd3
	 H37Zz71h/ffsZqsQicv+u0L/6B5rwZFl+jk82nE8KfIkQh2Je34NOuJYOGw2IbBe7k
	 /V/Uvs0URoA2fUdzfVjAkRNfGc3vyKyj95qL5xs8=
Date: Mon, 24 Jun 2024 21:59:46 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-add-module_description.patch removed from -mm tree
Message-Id: <20240625045947.2DF1CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     mm-kfence-add-module_description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/kfence: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:40 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kfence/kfence_test.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-3-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/kfence_test.c~mm-kfence-add-module_description
+++ a/mm/kfence/kfence_test.c
@@ -852,3 +852,4 @@ kunit_test_suites(&kfence_test_suite);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>");
+MODULE_DESCRIPTION("kfence unit test suite");
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


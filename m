Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC449146A6B
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313215; cv=none; b=nEBsYtTDOa9wVp2NwO5Ou7/0ZFghYQJc23HsLr5dQ6UyHzzEGklNQkiHWd6q5ZyJQQL+Jl5pMLjl6B8gyiKN2SgEhzJ8dKNt65gVZlRala8A+esxZ45eQP0ybZXm23WAAcOBSFO02PWB1iQewYsvq2nVuKf6VoEVuFsYgGQLPmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313215; c=relaxed/simple;
	bh=60CEaQcQvPoxMrFp52+mkH476y94Esq7hh5CmTYARJ8=;
	h=Date:To:From:Subject:Message-Id; b=eLUE4q361tYXabRtaT/ue1tYzjTNvtlYKUbDlWLmla3E9vHiFUAZV0kYQEbujq4pwgzOP7EEIODRVsnlEjyrvvkcJOOvhZJs+VwODGhjglb4vhnWE6gG47yy8nva1aXcK3BSceB3eMtu8J5MMWwpTxII8mZ4TIx57oFvUPCKFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cKUSboOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cKUSboOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47517C4CED0;
	Mon, 11 Nov 2024 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313215;
	bh=60CEaQcQvPoxMrFp52+mkH476y94Esq7hh5CmTYARJ8=;
	h=Date:To:From:Subject:From;
	b=cKUSboOYD70Fuf113SRLSLLMsZzuJjuGSo26+czPn+U49X2gmmffTeyWf5/Y383vE
	 N4hAu08VZL3CdU1n30yYV1JOeCHBlrU9cHNLOW6gs5MxJVsaDIwuBsXu4zYX1sxcRu
	 apUTvrQEcFkA8eTG/A66gPmnwjs4qjt5bQetv2E8=
Date: Mon, 11 Nov 2024 00:20:14 -0800
To: mm-commits@vger.kernel.org,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-delete-config_kasan_module_test-fix.patch removed from -mm tree
Message-Id: <20241111082015.47517C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/kasan: fix indentation in translation
has been removed from the -mm tree.  Its filename was
     kasan-delete-config_kasan_module_test-fix.patch

This patch was dropped because it was folded into kasan-delete-config_kasan_module_test.patch

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: Documentation/kasan: fix indentation in translation
Date: Sun, 20 Oct 2024 09:28:13 +0500

Fix the warning in linux-next (htmldocs):

> Documentation/translations/zh_TW/dev-tools/kasan.rst:410:
>	ERROR: Unexpected indentation.

This is based on -mm tree (linux-mm-unstable branch).

Link: https://lkml.kernel.org/r/20241020042813.3223449-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/translations/zh_TW/dev-tools/kasan.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/translations/zh_TW/dev-tools/kasan.rst~kasan-delete-config_kasan_module_test-fix
+++ a/Documentation/translations/zh_TW/dev-tools/kasan.rst
@@ -407,7 +407,7 @@ 有一些KASAN測試可以驗證KASAN是
 
 所有 KASAN 測試均與 KUnit 測試框架集成，並且可以啟用
 透過 ``CONFIG_KASAN_KUNIT_TEST``。可以運行測試並進行部分驗證
- 以幾種不同的方式自動進行；請參閱下面的說明。
+以幾種不同的方式自動進行；請參閱下面的說明。
 
 如果偵測到錯誤，每個 KASAN 測試都會列印多個 KASAN 報告之一。
 然後測試列印其編號和狀態。
_

Patches currently in -mm which might be from snovitoll@gmail.com are

kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch
kasan-use-export_symbol_if_kunit-to-export-symbols.patch
kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch


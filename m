Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7890013D245
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291588; cv=none; b=CfoNBOgbN60kf5ZE+HmHubSeWk3IkLUR2ygxfwgJY7rKsUHVs64xeejaZfHEqn5rz3bAi7EPSU5/h4Dzp+Yv1wCz0zpzT23HeTGeLLlXJtygVm+EEUiIx9r83PEuLHaPJR7cTaIualAEWVSNytM3NzDJp654XZDNAYpDetQkR7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291588; c=relaxed/simple;
	bh=8vZSXUHbNJ/TegM5rp+iKisGUl5DM3yotcmQLqkAWyY=;
	h=Date:To:From:Subject:Message-Id; b=mwGZeGXBRYgBOrKlYhwZW9pGnpU7CW7bRQfQ8SWdW4eukSH027NKJ3U06O+OtT2s7XkIcXNg6lnneL8JKfh/x3dbwKncYToimUQo6GWDzziFOeTEx74U+4/z7JUpJ65ruJqS43olxFeah1uOojOzzkh/uK1JgUUSNX/Zx9a5q2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p07uWfGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p07uWfGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45599C32782;
	Tue, 25 Jun 2024 04:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291588;
	bh=8vZSXUHbNJ/TegM5rp+iKisGUl5DM3yotcmQLqkAWyY=;
	h=Date:To:From:Subject:From;
	b=p07uWfGomoIddmPUdI2o+1VmiDgcErzL5ilKU2XdDwhnmeg50SrA2jK08rpw/A4J1
	 Aqyc/LFzJMaDbbvHZV1oyfJRyDqRFp7Xy02tidt9YZgdH/OGh/OKzqJarJNwP5TQqK
	 AoWBPB1ZK5pTt8ajhIo9+osbDKG/9JXJ5hq/gJgs=
Date: Mon, 24 Jun 2024 21:59:47 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-add-module_description.patch removed from -mm tree
Message-Id: <20240625045948.45599C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-module_description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/zsmalloc: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:41 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/zsmalloc.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-4-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-module_description
+++ a/mm/zsmalloc.c
@@ -2276,3 +2276,4 @@ module_exit(zs_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("zsmalloc memory allocator");
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C6125D6
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417675; cv=none; b=r1TRpoRzqmchwJ6jOfr+/QCcpQR3qNOEejf6EsA/XVnYvF9wiCyhsVgUNR2AlaSyZJC5gjWL77KBdhPkoOaVCz+cu5IxQBZJAMo2mtPRAVSa+tU8YsSFI3XZY1jg7qN/7TxVucZwp5VQWZj8+3c6GEguPMVDodVeSu18o+G2la4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417675; c=relaxed/simple;
	bh=MwousydxH5XkNLox0YUHmLcUXZ9IZEDA7VF2/0s+p4E=;
	h=Date:To:From:Subject:Message-Id; b=EDNlHE2y/ThBBcC4XXOS3ofCIvsH6/qDoheV2uOhPqDtg7xISTH70i5dgcn9t6YMAEBn75H6WFwQYgqIs2cJ7UMJYGBaJXiKeHX8LSlZBHc1so8H/iMQLfxLwE/Vbiv3GS92XvDC6F816BkHpy+6Y+rjVQpfbw0a+yRDAo5ZNhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ou18D4Pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ou18D4Pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C02EC4CEE2;
	Sat, 12 Apr 2025 00:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417672;
	bh=MwousydxH5XkNLox0YUHmLcUXZ9IZEDA7VF2/0s+p4E=;
	h=Date:To:From:Subject:From;
	b=Ou18D4PdEaGRSAJMhE7+gsWkdOuEMjOQs6zzyP0gm7YHbDxSnWrCpKaa+DVViItCm
	 MZHH9AdOEcFZvFyKFEy9P2dgTbkIAeLwk58MmUWiLrAGKBpnq1ecxW1pKVOQ7uztOo
	 8JzbBWmf1Rk9pugz1xiQ4sQXSvidOgRwWNP2h8PA=
Date: Fri, 11 Apr 2025 17:27:51 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,sfr@canb.auug.org.au,ryabinin.a.a@gmail.com,peterz@infradead.org,niharchaithanya@gmail.com,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,arnd@arndb.de,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kasan-add-module-decription-fix.patch removed from -mm tree
Message-Id: <20250412002752.8C02EC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-kasan-add-module-decription-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-add-module-decription-fix.patch

This patch was dropped because it was folded into mm-kasan-add-module-decription.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-add-module-decription-fix
Date: Sun Apr  6 06:46:45 PM PDT 2025

update description text, per Andrey

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Macro Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-add-module-decription-fix
+++ a/mm/kasan/kasan_test_c.c
@@ -2127,5 +2127,5 @@ static struct kunit_suite kasan_kunit_te
 
 kunit_test_suite(kasan_kunit_test_suite);
 
-MODULE_DESCRIPTION("kunit test case for kasan");
+MODULE_DESCRIPTION("KUnit tests for checking KASAN bug-detection capabilities");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-kasan-add-module-decription.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E83275B15
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517609; cv=none; b=Hwojc/pked2U2izl9tPFbcIgN5UEWMpTGRlqP8/M0WPTlr9+qnaDbkbA6b+FdYSSe1de5qIr4wEWt9ESNHKCQ/tNj34Jfg7RbT3fqZxUg3R8pKLZ9g9VNCtX4cWzzcM6kVGeIM95qOwUXDAUCLNLRY3YOAsJcb8HJDWgprdTHMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517609; c=relaxed/simple;
	bh=edvKJi6KhXPz0D5Hr2TElR8jLcKvV9yH/LpjhDTYmkw=;
	h=Date:To:From:Subject:Message-Id; b=UwAynsP7vvNcrdFc2OPQf5287Ptce4jDcEC35vN0+sTb85R5K5cphwimH1vgQjbNvlWz3tWj7LIhXLZcF/4bWiFMdyt6J9TIFLnci/JKQUKz7/+JLxlO07LhFXNGW116o4+ufBCFJR3fZv4z+sPWGM+gOvQ7Tun4uGGRN6cXBoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YfdTpzR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YfdTpzR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E84C113D0;
	Tue, 23 Dec 2025 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517609;
	bh=edvKJi6KhXPz0D5Hr2TElR8jLcKvV9yH/LpjhDTYmkw=;
	h=Date:To:From:Subject:From;
	b=YfdTpzR5tVZgR6PP4SKplT0bisA4Zj2dvthCBFFSVt1/TBjg1GRH5Yq/HJM9joVbb
	 x2jmTCQuKe7/Vn9yFmegQIBb7MQEgqWWd2wLgHChvcNkMUnDQy+pa4KKijvpNTKy6n
	 G1JFLE1Phg4xa7Z4yOHO7adHw4ymm5YKZi9XxjbA=
Date: Tue, 23 Dec 2025 11:20:08 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,ryabinin.a.a@gmail.com,maciej.wieczor-retman@intel.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch removed from -mm tree
Message-Id: <20251223192008.E7E84C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-unpoison-vms-addresses-with-a-common-tag-fix
has been removed from the -mm tree.  Its filename was
     kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch

This patch was dropped because it was folded into kasan-unpoison-vms-addresses-with-a-common-tag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-unpoison-vms-addresses-with-a-common-tag-fix
Date: Thu Dec  4 07:20:57 PM PST 2025

use WARN_ON_ONCE(), per Andrey

Link: https://lkml.kernel.org/r/CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-fix
+++ a/mm/kasan/common.c
@@ -591,7 +591,7 @@ void __kasan_unpoison_vmap_areas(struct
 	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
 	 * KASAN checks down the line.
 	 */
-	if (flags & KASAN_VMALLOC_KEEP_TAG) {
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
 		pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
 		return;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch


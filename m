Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A226E179
	for <mm-commits@vger.kernel.org>; Fri,  5 Dec 2025 03:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764904973; cv=none; b=DJruxP0MTbqow1k+LMUcPSs95LD4dsW6VsosiGBTkBvc6xQZUoMKDMVSZLELJH88vt6mc9bay6WCPO/Xg55Oy68MBlQh0JvgTDYBQRnj4uYto3UgvJWagWl5qqBILmLhjhL/VIdQ+Z1AKze4FY2CaqbFVszYlKV0fEqbchVk/mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764904973; c=relaxed/simple;
	bh=uJ8jPFXUyQKGtcxMx+50vDiWpYK09erwJVQiSo3Dloo=;
	h=Date:To:From:Subject:Message-Id; b=e+Wi0fSOny6ogkfrY33CaXjAR+Urk/Qz6Hg48o2guGBK0UTI2KG5lWT/W5V6sJydzHFvKmuYVB77qPNVNsE4esqPdJ6VvHKbRbvHtvfjGfsAy4X3+JJ0Pd8K2+4EjRJ5zICWZUp2SCDQu2Pt+SqJdhqsvWbbPNxWO77/W74gHiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aL/MWxH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aL/MWxH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB233C4CEFB;
	Fri,  5 Dec 2025 03:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764904972;
	bh=uJ8jPFXUyQKGtcxMx+50vDiWpYK09erwJVQiSo3Dloo=;
	h=Date:To:From:Subject:From;
	b=aL/MWxH33KcF9Ft1c6VlXgOAx72+8xgDSLVARjsukLiIHFiRIa2Z+c1zutndSKLz1
	 A8cjHw5dwvfZm2TRYDkFdGyJaNlycFkBm7XCBXcqBefBP0eQyzlIx19GuhoMAEvPIO
	 0Y0ogpqWv6Wr8sJuxppehVn9Xj6hENs6d1y09XxY=
Date: Thu, 04 Dec 2025 19:22:52 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,ryabinin.a.a@gmail.com,maciej.wieczor-retman@intel.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251205032252.AB233C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-unpoison-vms-addresses-with-a-common-tag-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -598,7 +598,7 @@ void __kasan_unpoison_vmap_areas(struct
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
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch


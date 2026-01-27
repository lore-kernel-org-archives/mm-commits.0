Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B2D1F3D56
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482467; cv=none; b=YfD1qZCHSYl38Fso/p2r92tIdakQwaDK+BF8Wh0XWcqk1Yh2QbNubOyn7VKvGuRuhqoSt63uL0N9F0jIeFggyMEkZRxyWd1ttjxSOHVNopNY0quJlS5n927Dgg6whUqVIPijbVqLUXarPlILzvz7eRL/phV3xz7HRmcqF/OLBUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482467; c=relaxed/simple;
	bh=nMQ7QX7+R7xu8r+55fVyMgdQAH9Sn7ksgK6NRHc84ko=;
	h=Date:To:From:Subject:Message-Id; b=t2JULGPcNboY3Vu0vOTBQRVPBKHLjEF0J84A1phfYjTjLrv766R4yZXpFMEEPJWVUvWemt3/cB0FkhLvEFz9ZN62TAKMxL9MiuXPm6zkHlDJ10OTUm/Oqt3vpZtmTpYeL7vxxC68sKmiZuZiGKWq02KyqRGDp1VpqX/R/90EIUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tn9dTAL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tn9dTAL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E28C19421;
	Tue, 27 Jan 2026 02:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482467;
	bh=nMQ7QX7+R7xu8r+55fVyMgdQAH9Sn7ksgK6NRHc84ko=;
	h=Date:To:From:Subject:From;
	b=tn9dTAL04qTNZdE3UkMdndp9+I2EICb7OrrjLMCRz20oSDQQbfkcjUgbx0k86lRix
	 Fttq4FjBsQNxOVq+9KZwb2cJe+eDruPq+sFKLjLAj9F2dsIU7jp4vjzTe1JSVdZT2U
	 jlA+Jz9p2XaD7B1Q3gDhBFFfjYSbE8oOaGTkyyR0=
Date: Mon, 26 Jan 2026 18:54:26 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,maciej.wieczor-retman@intel.com,joonki.min@samsung-slsi.corp-partner.google.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch removed from -mm tree
Message-Id: <20260127025427.46E28C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch

This patch was dropped because it was folded into mm-kasan-fix-kasan-poisoning-in-vrealloc.patch

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
Date: Mon, 19 Jan 2026 15:45:09 +0100

Move kasan_enabled() check to header function to avoid function call if
kasan disabled via boot cmdline.

Move __kasan_vrealloc() to common.c to fix CONFIG_KASAN_HW_TAGS=y

Link: https://lkml.kernel.org/r/20260119144509.32767-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: <joonki.min@samsung-slsi.corp-partner.google.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   10 +++++++++-
 mm/kasan/common.c     |   21 +++++++++++++++++++++
 mm/kasan/shadow.c     |   24 ------------------------
 3 files changed, 30 insertions(+), 25 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
+++ a/include/linux/kasan.h
@@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_stru
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
-void kasan_vrealloc(const void *start, unsigned long old_size,
+void __kasan_vrealloc(const void *start, unsigned long old_size,
 		unsigned long new_size);
 
+static __always_inline void kasan_vrealloc(const void *start,
+					unsigned long old_size,
+					unsigned long new_size)
+{
+	if (kasan_enabled())
+		__kasan_vrealloc(start, old_size, new_size);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
--- a/mm/kasan/common.c~mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
+++ a/mm/kasan/common.c
@@ -606,4 +606,25 @@ void __kasan_unpoison_vmap_areas(struct
 			__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
 	}
 }
+
+void __kasan_vrealloc(const void *addr, unsigned long old_size,
+		unsigned long new_size)
+{
+	if (new_size < old_size) {
+		kasan_poison_last_granule(addr, new_size);
+
+		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
+		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
+		if (new_size < old_size)
+			__kasan_poison_vmalloc(addr + new_size,
+					old_size - new_size);
+	} else if (new_size > old_size) {
+		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
+		__kasan_unpoison_vmalloc(addr + old_size,
+					new_size - old_size,
+					KASAN_VMALLOC_PROT_NORMAL |
+					KASAN_VMALLOC_VM_ALLOC |
+					KASAN_VMALLOC_KEEP_TAG);
+	}
+}
 #endif
--- a/mm/kasan/shadow.c~mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
+++ a/mm/kasan/shadow.c
@@ -651,30 +651,6 @@ void __kasan_poison_vmalloc(const void *
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
-void kasan_vrealloc(const void *addr, unsigned long old_size,
-		unsigned long new_size)
-{
-	if (!kasan_enabled())
-		return;
-
-	if (new_size < old_size) {
-		kasan_poison_last_granule(addr, new_size);
-
-		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
-		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
-		if (new_size < old_size)
-			__kasan_poison_vmalloc(addr + new_size,
-					old_size - new_size);
-	} else if (new_size > old_size) {
-		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
-		__kasan_unpoison_vmalloc(addr + old_size,
-					new_size - old_size,
-					KASAN_VMALLOC_PROT_NORMAL |
-					KASAN_VMALLOC_VM_ALLOC |
-					KASAN_VMALLOC_KEEP_TAG);
-	}
-}
-
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

mm-kasan-fix-kasan-poisoning-in-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8EB32ED24
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845874; cv=none; b=pB5RhDHmFyMaMVKug+j4qJ4jwJBrT/yEr3OKSKGRqHvJ7f/dRPEpZ2rEZ01BNryIYUezNnJ/CmV2+64KNLpbuyB4fSntxDHVl7qvqEC3gnqX0XRXsssC8L+rPJFXxFvUBpN03/tPRqviPdaj7SMoRxXFGCynRGLCMbRkKcZnIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845874; c=relaxed/simple;
	bh=bXQa6bOjIEX8p8DL0V0OV6DvZmkmPV4TxjkSxmmc4Lk=;
	h=Date:To:From:Subject:Message-Id; b=c1ZCxE/apCaw8/TlkTY4JHng/bbxHEpvlJI/YjECTaa3LPpOaeLDi++sEpdDBwAzFPrHDU2R4qX1L/pb/6NWh9qVeWClHHVq5eT8IwTjEAaR/ootVex5kLKe89keIU5lpfeMfBzF0rueRQ1yYBzeclzQui5GjQofuNcbGgUxCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H71wYFWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H71wYFWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17818C116C6;
	Mon, 19 Jan 2026 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768845874;
	bh=bXQa6bOjIEX8p8DL0V0OV6DvZmkmPV4TxjkSxmmc4Lk=;
	h=Date:To:From:Subject:From;
	b=H71wYFWwMkZKesKrN8adqnyVaC0MGZLTQKMK/cGONxNa/fwHOtXZGzoJbyza3aELU
	 15hv5LgPj+f1LVJnsydZhRDOnEGmMPqX2mdUPh0JW0uYvhT5SkJqU7OFJ+nWg9FE6Y
	 4bXYhg1ZAe/QlRNpqfslYJ7zzaEmdnUTz9z9TRAQ=
Date: Mon, 19 Jan 2026 10:04:33 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,maciej.wieczor-retman@intel.com,joonki.min@samsung-slsi.corp-partner.google.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260119180434.17818C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
Date: Mon, 19 Jan 2026 15:45:09 +0100

Move kasan_enabled() check to header function to avoid function call if
kasan disabled via boot cmdline.

Move __kasan_vrealloc() to common.c to fix CONFIG_KASAN_HW_TAGS=y

Link: https://lkml.kernel.org/r/20260119144509.32767-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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
mm-kasan-fix-kasan-poisoning-in-vrealloc-fix.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch


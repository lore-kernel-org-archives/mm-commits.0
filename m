Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D5757EA;
	Tue,  4 Nov 2025 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762294968; cv=none; b=GQx+eYUCoNts2gUrCxiOogRl0zVUqspwvr9J6CH/+cYQw5l5RA6EqwrlHxpMhBngdMMga2O+xwEK+Jdkx1xRbghsSe8wb8vajmCrndV8tUJaqzjjGtYO2IBqMWdGl/loDAIqwPwJQ1xbIuD1D/WPyYTxIh3YRDTT1lxD1nR2Eug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762294968; c=relaxed/simple;
	bh=mrIRRSyaoVZUhB2h+ZUo6J/2YFCCxLm0OFA6MBAI7d4=;
	h=Date:To:From:Subject:Message-Id; b=OzcvRuG1OE3c8e0IYIaz2BBwpvrwyfyWAgK3vmwAXkkTCdiwq2NA6/tl5AP94z+iNpBcU+ktT2StxRAhLEV/P2Vh8A4DmIPgRygb2zFzirFiIkZGBjEcGyRLcU3PerZYgoJrTX67FPWWjV2hnPHYe619GGWmTYjueLQg0pXOFzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KCN75bUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KCN75bUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F8FC4CEF7;
	Tue,  4 Nov 2025 22:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762294967;
	bh=mrIRRSyaoVZUhB2h+ZUo6J/2YFCCxLm0OFA6MBAI7d4=;
	h=Date:To:From:Subject:From;
	b=KCN75bUSYEKbGjhky/w08gkr3giMaURPMGoJZWhehw2HC9KyOl3blJKKuX1e6Yws4
	 UkO34YtNr2OCp5PNDuxlIeUPhfq8ppJQXTTHvOE6VSgpTNoT+Hi1V0kaHN6gQz/GV+
	 9b8Wjzj7cMKTbUA7iGJQaSBI19LN4AQLAAvfg5jI=
Date: Tue, 04 Nov 2025 14:22:46 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,bhe@redhat.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-pcpu-chunks-with-base-address-tag.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104222247.68F8FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: unpoison pcpu chunks with base address tag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-pcpu-chunks-with-base-address-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-pcpu-chunks-with-base-address-tag.patch

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
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan: unpoison pcpu chunks with base address tag
Date: Tue, 04 Nov 2025 14:49:08 +0000

Patch series "kasan: vmalloc: Fix incorrect tag assignment with multiple
vm_structs".

A KASAN tag mismatch, possibly resulting in a kernel panic, can be
observed on systems with a tag-based KASAN enabled and with multiple NUMA
nodes.  Initially it was only noticed on x86 [1] but later a similar issue
was also reported on arm64 [2].

Specifically the problem is related to how vm_structs interact with
pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
addresses are derived.

When vm_structs are allocated they are tagged if vmalloc support is
enabled along the KASAN mode.  Later when first pcpu chunk is allocated it
gets its 'base_addr' field set to the first allocated vm_struct.  With
that it inherits that vm_struct's tag.

When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
example in pcpu_alloc_noprof()) the base_addr field is used and offsets
are added to it.  If the initial conditions are satisfied then some of the
offsets will point into memory allocated with a different vm_struct.  So
while the lower bits will get accurately derived the tag bits in the top
of the pointer won't match the shadow memory contents.

The solution (proposed at v2 of the x86 KASAN series [3]) is to tag the
vm_structs the same when allocating them for the per cpu allocator (in
pcpu_get_vm_areas()).

Originally these patches were part of the x86 KASAN series [4].


This patch (of 2):

A KASAN tag mismatch, possibly causing a kernel panic, can be observed on
systems with a tag-based KASAN enabled and with multiple NUMA nodes.  It
was reported on arm64 and reproduced on x86.  It can be explained in the
following points:

1. There can be more than one virtual memory chunk.
2. Chunk's base address has a tag.
3. The base address points at the first chunk and thus inherits
   the tag of the first chunk.
4. The subsequent chunks will be accessed with the tag from the
   first chunk.
5. Thus, the subsequent chunks need to have their tag set to
   match that of the first chunk.

Refactor code by moving it into a helper in preparation for the actual
fix.

Link: https://lkml.kernel.org/r/821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me
Link: https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.1738686764.git.maciej.wieczor-retman@intel.com/ [1]
Link: https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/ [2]
Link: https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vowMbi8raw@mail.gmail.com/ [3]
Link: https://lore.kernel.org/all/cover.1761763681.git.m.wieczorretman@pm.me/ [4]
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Tested-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   10 ++++++++++
 mm/kasan/common.c     |   11 +++++++++++
 mm/vmalloc.c          |    4 +---
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~kasan-unpoison-pcpu-chunks-with-base-address-tag
+++ a/include/linux/kasan.h
@@ -614,6 +614,13 @@ static __always_inline void kasan_poison
 		__kasan_poison_vmalloc(start, size);
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
+static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+	if (kasan_enabled())
+		__kasan_unpoison_vmap_areas(vms, nr_vms);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -638,6 +645,9 @@ static inline void *kasan_unpoison_vmall
 static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
 { }
 
+static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/common.c~kasan-unpoison-pcpu-chunks-with-base-address-tag
+++ a/mm/kasan/common.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
 
 #include "kasan.h"
 #include "../slab.h"
@@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *addr
 	}
 	return true;
 }
+
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+	int area;
+
+	for (area = 0 ; area < nr_vms ; area++) {
+		kasan_poison(vms[area]->addr, vms[area]->size,
+			     arch_kasan_get_tag(vms[area]->addr), false);
+	}
+}
--- a/mm/vmalloc.c~kasan-unpoison-pcpu-chunks-with-base-address-tag
+++ a/mm/vmalloc.c
@@ -4870,9 +4870,7 @@ retry:
 	 * With hardware tag-based KASAN, marking is skipped for
 	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
-	for (area = 0; area < nr_vms; area++)
-		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+	kasan_unpoison_vmap_areas(vms, nr_vms);
 
 	kfree(vas);
 	return vms;
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-unpoison-pcpu-chunks-with-base-address-tag.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F332D42A;
	Thu,  4 Dec 2025 22:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764886887; cv=none; b=SxREWfuk3LU5LIl0QOJ9XaC/6TY0gHge3NFqFx8fxtldabBuDoyyHbuwoyu8xhFKSt2B2JvalJ3+kJys1IALvjOduZgmJGYfXpWa2FwJAZNTCfrBHXvZCJcTNZLjJ8p3B3dGxxLer7Nfftb47Omt0w3aA4lnjiwr0Wrq9N8KQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764886887; c=relaxed/simple;
	bh=8AHIhzdeYwR7535Mm/jFH+UEtzzcQcneGz9lRhbF2kE=;
	h=Date:To:From:Subject:Message-Id; b=GmSM9dZ5ye2rf8Wrw5VWcMnKDWnxLTPfO73DaB7xXqVubG+FOgK0Vmb911PnFo1BcPe+VHM73ISCKiNbVX29GdG1e9+3Pg4a2c66lgEgc858W3RpQKk/Wv3jECkWpIdWvL4+nY4XabxFc8iZgcWVMC+nPpLpYhQRGqHS0rOpJyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpcPgvjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpcPgvjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FB8C4CEFB;
	Thu,  4 Dec 2025 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764886885;
	bh=8AHIhzdeYwR7535Mm/jFH+UEtzzcQcneGz9lRhbF2kE=;
	h=Date:To:From:Subject:From;
	b=CpcPgvjIevc3UsjAo6o4oFbQefYsH4bqUlrXkthsj59TIuq2YighbLcdpegJjooCS
	 LPg2QLiVxqSRJ59zu0ePM9ufTj2DRCmt1gbcEFbWh6tnTGw66F7VXj3DRUi7/HI5sd
	 Vpd6HjCtwklvQAT8EKgJBWG/eA/pFgZuTgk3IqSQ=
Date: Thu, 04 Dec 2025 14:21:25 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-vms-addresses-with-a-common-tag.patch added to mm-hotfixes-unstable branch
Message-Id: <20251204222125.D4FB8C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: unpoison vms[area] addresses with a common tag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-vms-addresses-with-a-common-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-vms-addresses-with-a-common-tag.patch

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
Subject: kasan: unpoison vms[area] addresses with a common tag
Date: Thu, 04 Dec 2025 19:00:11 +0000

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

Use the new vmalloc flag that disables random tag assignment in
__kasan_unpoison_vmalloc() - pass the same random tag to all the
vm_structs by tagging the pointers before they go inside
__kasan_unpoison_vmalloc().  Assigning a common tag resolves the pcpu
chunk address mismatch.

Link: https://lkml.kernel.org/r/873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag
+++ a/mm/kasan/common.c
@@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct
 	unsigned long size;
 	void *addr;
 	int area;
+	u8 tag;
 
-	for (area = 0 ; area < nr_vms ; area++) {
+	/*
+	 * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
+	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
+	 * KASAN checks down the line.
+	 */
+	if (flags & KASAN_VMALLOC_KEEP_TAG) {
+		pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
+		return;
+	}
+
+	size = vms[0]->size;
+	addr = vms[0]->addr;
+	vms[0]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+	tag = get_tag(vms[0]->addr);
+
+	for (area = 1 ; area < nr_vms ; area++) {
 		size = vms[area]->size;
-		addr = vms[area]->addr;
-		vms[area]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+		addr = set_tag(vms[area]->addr, tag);
+		vms[area]->addr =
+			__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
 	}
 }
 #endif
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch


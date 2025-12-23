Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2234A79B;
	Tue, 23 Dec 2025 19:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517842; cv=none; b=r2Jb8LJYGc5tjzevUZz4/y/JsKNIOmCjHZoboEAc7M23L3X+RnXGotojqTrFC+f0tw9EmJDfZOfu4eKoar49RJlPjOHCqAt0Hm9KosLfjuQyycjUmTuRKjeqoAiHSV69D78vQfYVYl1C+MULz6EiIwnGLdrQ/MvpRr+AJqeMFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517842; c=relaxed/simple;
	bh=L5aB+4nqNE6sfRdGLjHaDT7G8G4b6d/rwKTCrfVwp/8=;
	h=Date:To:From:Subject:Message-Id; b=qhdCy4A4oHB5jb74V1AKLMYryBs+OqH6EIH0VpfEkumu/UF0w/VtboP/xF5uXOp3OtDCl1wuXUxx31iKtqWBbpZx/qR03+lnsLdAHwmtghcBimEhS61GdPkedBUsM4d7i017vyjK+EAZJ46xTRGCiWvmtM0LON1nD7hhcHsY7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cz0j945y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cz0j945y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB74C113D0;
	Tue, 23 Dec 2025 19:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517842;
	bh=L5aB+4nqNE6sfRdGLjHaDT7G8G4b6d/rwKTCrfVwp/8=;
	h=Date:To:From:Subject:From;
	b=Cz0j945yI86E7yWze2SWMe9ushGc4iOo8s9KrkYWhXQjwENGasNr+HiqF+9zPKXoi
	 AVL/sCKWgyXP8kOXJH/dMJGjSdIZWT4I9qjRxfttQ4w9uCHOq0h3I2BspoUJp8fZVa
	 tJxaWdKu4gmQkNH9oK7EpvBtriGEhMpBgZnN3uqk=
Date: Tue, 23 Dec 2025 11:24:01 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-unpoison-vms-addresses-with-a-common-tag.patch removed from -mm tree
Message-Id: <20251223192402.3CB74C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: unpoison vms[area] addresses with a common tag
has been removed from the -mm tree.  Its filename was
     kasan-unpoison-vms-addresses-with-a-common-tag.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: use WARN_ON_ONCE(), per Andrey]
  Link: https://lkml.kernel.org/r/CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com
[maciej.wieczor-retman@intel.com: remove unneeded pr_warn()]
  Link: https://lkml.kernel.org/r/919897daaaa3c982a27762a2ee038769ad033991.1764945396.git.m.wieczorretman@pm.me
Link: https://lkml.kernel.org/r/873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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

 mm/kasan/common.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag
+++ a/mm/kasan/common.c
@@ -584,11 +584,26 @@ void __kasan_unpoison_vmap_areas(struct
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
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG))
+		return;
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



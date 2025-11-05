Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC51E2AF1D;
	Wed,  5 Nov 2025 01:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762305426; cv=none; b=M+LSVfgevYduYvKD/V3APAsFze5IIhBqAjwzpqg4vJXczLU/6MUYgzVzAAxTx4vPKxeV206U7PRYUYaBeyJi9Qh6+O679fzeCEdr07A0PYi3od03NDTf7IiiAqKv/gRp+U3s7cK9pBiNwDyum52WIgmAqNxmS1wlc+XLESpjNcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762305426; c=relaxed/simple;
	bh=7pUUe0TPmWjbaxIbMmv/d9IcXUJPlWjiZBweoyN3jeU=;
	h=Date:To:From:Subject:Message-Id; b=mXAP2YwGXk9lpno8Ob23KAzSVFAJhz5TDZ/hq8cqsikJ6kVW67v1O95tRZKrLUHLmJBFU4GXLMEHIFPjph/qTYV5PVRT8pPpyknQYA5zHfLqe75lRVShni5lJwan3xUV+2gkXH1567n9KVTlLnpkH/JDRXRf6Rgh1CMFdwfdhbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hAV9E494; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hAV9E494"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A2C116D0;
	Wed,  5 Nov 2025 01:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762305426;
	bh=7pUUe0TPmWjbaxIbMmv/d9IcXUJPlWjiZBweoyN3jeU=;
	h=Date:To:From:Subject:From;
	b=hAV9E494oCea6QQb3OKlxDXbT7CyEvLTZFHLNmjGd+A2q/xAtOETNdsnRUHlmC+sy
	 SAEflOOWsTTcktV90BLsDNkr+xpY4l71rNa5aKmOJ37Li/QRQ0MEnTgJEKKxLO7vqk
	 VYQ4KUltHxTluXL93NVaHOiNDlmkpIxLe6uUAPAs=
Date: Tue, 04 Nov 2025 17:17:05 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,bhe@redhat.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kasan-unpoison-vms-addresses-with-a-common-tag.patch removed from -mm tree
Message-Id: <20251105011706.776A2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: unpoison vms[area] addresses with a common tag
has been removed from the -mm tree.  Its filename was
     kasan-unpoison-vms-addresses-with-a-common-tag.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan: unpoison vms[area] addresses with a common tag
Date: Tue, 04 Nov 2025 14:49:48 +0000

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

Unpoison all vm_structs after allocating them for the percpu allocator. 
Use the same tag to resolve the pcpu chunk address mismatch.

Link: https://lkml.kernel.org/r/cf8fe0ffcdbf54e06d9df26c8473b123c4065f02.1762267022.git.m.wieczorretman@pm.me
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

 mm/kasan/common.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag
+++ a/mm/kasan/common.c
@@ -584,12 +584,20 @@ bool __kasan_check_byte(const void *addr
 	return true;
 }
 
+/*
+ * A tag mismatch happens when calculating per-cpu chunk addresses, because
+ * they all inherit the tag from vms[0]->addr, even when nr_vms is bigger
+ * than 1. This is a problem because all the vms[]->addr come from separate
+ * allocations and have different tags so while the calculated address is
+ * correct the tag isn't.
+ */
 void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
 {
 	int area;
 
 	for (area = 0 ; area < nr_vms ; area++) {
 		kasan_poison(vms[area]->addr, vms[area]->size,
-			     arch_kasan_get_tag(vms[area]->addr), false);
+			     arch_kasan_get_tag(vms[0]->addr), false);
+		arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr));
 	}
 }
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are



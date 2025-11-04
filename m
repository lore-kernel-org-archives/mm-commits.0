Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B663F2D061F;
	Tue,  4 Nov 2025 22:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762294970; cv=none; b=C0+l1V/Sj73tLXTbuS0d8toS6ywMw9xNhQtqqL5IKjwxMJgxm6b762C3bLnVdroo71V8aPATvdTojp1mpDPzwDk2gv1PrRHTDIsmD26SM1Q4C+vPFzIjDKxkjozR4hcxz12DP9oHMdZdY9YLusjvsXPio/WSuMpuyuDj2nxsLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762294970; c=relaxed/simple;
	bh=lV6uGsRukfZJOsRESuAo7ERBfurHRCfEx+YXplwlBqA=;
	h=Date:To:From:Subject:Message-Id; b=NZCgSXNkx0JlXJcX8Bj+KGdt4UYHLEzCnwm+Mdfvbiz7RvReOqV2+idGDOCCYyWdqzXN0ZvPjFkfvO1fhCU4iRUIgezZYlaMRWDaKCbYAwGjTB8/VtAaFJViXoYnLXPYtG9LK1PKpS6hCwBJyDJ+TX8MWMNA7oaUmcCIkBpqznU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jrx8bDtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jrx8bDtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F820C4CEF7;
	Tue,  4 Nov 2025 22:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762294970;
	bh=lV6uGsRukfZJOsRESuAo7ERBfurHRCfEx+YXplwlBqA=;
	h=Date:To:From:Subject:From;
	b=Jrx8bDtEJNdq+sv4Xz+SeEpx6DOHETaa0hwk7K1qJs4XTModcn9GcDZoh0O5tEDXU
	 9srtVilXw4Hvf3IeIxaLf5+69bLH/YAKv8YXnnsA8HTDNImWCm0ItcMamexypKIjfj
	 JYTACRSnX+c0dh1zhpX5eW7+gUCbdhf4qQfpvpE4=
Date: Tue, 04 Nov 2025 14:22:49 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,bhe@redhat.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-vms-addresses-with-a-common-tag.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104222250.6F820C4CEF7@smtp.kernel.org>
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

kasan-unpoison-pcpu-chunks-with-base-address-tag.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch


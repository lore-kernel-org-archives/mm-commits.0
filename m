Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A08A313283
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282378; cv=none; b=O6G/KDcPB2Mroicdv26+yD1TbsB/49T/UUAk+UekbcGHWYhYCk5W4ZhrIh7DITgmi2W4kk0SFVBtjQ1EEmu0u6ey4xAA85Xbd9tEpqXaiqGWqY5ujw17ym41ZB+XC5X3aj5+MBskq6p9rFA1qB/BwrJC6H5OylOeHsjZA97PKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282378; c=relaxed/simple;
	bh=vpXuxuYhHxFWmuQFVn8Y60PO7tHOCij8CbwCgwxfDQo=;
	h=Date:To:From:Subject:Message-Id; b=BEkEnN7VCJ1qr4keSl5doFtO+iog1zBZZIGpbwcPjWJBiJWM8o8QYyofwVwvCiT5IzSgaA7XcW+fENw17JhY0B24+EX3LCzgIFD923hBDjCk2jEANGvpuqN+RoG8Wv0JhMBl1CbUq9vTKJqhaB1NyxQW3jqVELTPLQUIVnfpJ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pl88H6z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pl88H6z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EC3C4CEFB;
	Thu, 27 Nov 2025 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282377;
	bh=vpXuxuYhHxFWmuQFVn8Y60PO7tHOCij8CbwCgwxfDQo=;
	h=Date:To:From:Subject:From;
	b=Pl88H6z+Q+jDHkLKzMEpTtheoYCcKu7MucDMQoly9WCQ6NEgWAC58eNXBHzkRmMS5
	 AAd1f9zgib+N/TNboqu3aR/GeBpdpxU4SjdSBvQzeb+mky522UA6C2XUOGe5SfmhFZ
	 E3jQfrM6tc1UBjJbKcQU2x0GXXCoBrnjZQrmM5Fw=
Date: Thu, 27 Nov 2025 14:26:17 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch removed from -mm tree
Message-Id: <20251127222617.97EC3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: verify deserialization status and fix FDT alignment access
has been removed from the -mm tree.  Its filename was
     kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: verify deserialization status and fix FDT alignment access
Date: Fri, 14 Nov 2025 13:59:54 -0500

During boot, kho_restore_folio() relies on the memory map having been
successfully deserialized.  If deserialization fails or no map is present,
attempting to restore the FDT folio is unsafe.

Update kho_mem_deserialize() to return a boolean indicating success.  Use
this return value in kho_memory_init() to disable KHO if deserialization
fails.  Also, the incoming FDT folio is never used, there is no reason to
restore it.

Additionally, use get_unaligned() to retrieve the memory map pointer from
the FDT.  FDT properties are not guaranteed to be naturally aligned, and
accessing a 64-bit value via a pointer that is only 32-bit aligned can
cause faults.

Link: https://lkml.kernel.org/r/20251114190002.3311679-6-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   32 ++++++++++++++++-----------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-verify-deserialization-status-and-fix-fdt-alignment-access
+++ a/kernel/liveupdate/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/unaligned.h>
 #include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
@@ -451,20 +452,27 @@ static void __init deserialize_bitmap(un
 	}
 }
 
-static void __init kho_mem_deserialize(const void *fdt)
+/* Return true if memory was deserizlied */
+static bool __init kho_mem_deserialize(const void *fdt)
 {
 	struct khoser_mem_chunk *chunk;
-	const phys_addr_t *mem;
+	const void *mem_ptr;
+	u64 mem;
 	int len;
 
-	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
-
-	if (!mem || len != sizeof(*mem)) {
+	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return;
+		return false;
 	}
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
+	mem = get_unaligned((const u64 *)mem_ptr);
+	chunk = mem ? phys_to_virt(mem) : NULL;
+
+	/* No preserved physical pages were passed, no deserialization */
+	if (!chunk)
+		return false;
+
 	while (chunk) {
 		unsigned int i;
 
@@ -473,6 +481,8 @@ static void __init kho_mem_deserialize(c
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
+
+	return true;
 }
 
 /*
@@ -1458,16 +1468,12 @@ static void __init kho_release_scratch(v
 
 void __init kho_memory_init(void)
 {
-	struct folio *folio;
-
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
 
-		kho_mem_deserialize(kho_get_fdt());
-		folio = kho_restore_folio(kho_in.fdt_phys);
-		if (!folio)
-			pr_warn("failed to restore folio for KHO fdt\n");
+		if (!kho_mem_deserialize(kho_get_fdt()))
+			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
 	}
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFFE156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810170; cv=none; b=WhB5o2uwghVYJK6TElEBK0ilQC1oqnHO20/V6S23HGbE3ix9GneDlWX85Tzj51jv1flyvlL8xUq1Q3h7uMLQs+NusIOdD/H5HOAneeVuFJjNP1OCjgl7qpHjBTU914sEwW9EUZhzsUx6Qx59tY43HDQ90Y0+1LmF6lL31drAKcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810170; c=relaxed/simple;
	bh=U+lsAXQMzGmbPWxS6wQEL+H0QM081anyDbAHjkCtd5s=;
	h=Date:To:From:Subject:Message-Id; b=fdC3L8NsQcHa/rnl+WiIqBvN0mWCjDS2wNeTiUkHWSnKqO9FJ6IiWLyM9IrbTTG8kiSfyquuQs0IvAed1thfvr4k7xDLW2izskfqtmJvgON59w363cpYYT7+LU+m5aeQLZ8NM/1k/QslqNFF71DYxOBVjwEQKeQGVyaBfcqLUIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WmsIkkw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WmsIkkw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C8DC4CEEB;
	Sun, 14 Sep 2025 00:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810170;
	bh=U+lsAXQMzGmbPWxS6wQEL+H0QM081anyDbAHjkCtd5s=;
	h=Date:To:From:Subject:From;
	b=WmsIkkw+rT8q8qVGvxsCp1iQ534jawQYbnbpIFAzDT+9hPQjclrf8O/fFqdq8HjWc
	 kFZDbQbzWO8TTDglOE2s5HIetOOkpwyH53ki9+h7CBoStnVdcep8MDod8seisAPg5S
	 Wzyd7S+r6THoP/H7e9n8mwlf7nKe69UFejZS7G7k=
Date: Sat, 13 Sep 2025 17:36:10 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ardb@kernel.org,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] efi-support-booting-with-kexec-handover-kho.patch removed from -mm tree
Message-Id: <20250914003610.84C8DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: efi: support booting with kexec handover (KHO)
has been removed from the -mm tree.  Its filename was
     efi-support-booting-with-kexec-handover-kho.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Evangelos Petrongonas <epetron@amazon.de>
Subject: efi: support booting with kexec handover (KHO)
Date: Thu, 21 Aug 2025 17:59:00 +0000

When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
early during device tree scanning.  After kexec, the new kernel
exclusively uses this region for memory allocations during boot up to the
initialization of the page allocator

However, when booting with EFI, EFI's reserve_regions() uses
memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
rebuilding them from EFI data.  This destroys KHO scratch regions and
their flags, thus causing a kernel panic, as there are no scratch memory
regions.

Instead of wholesale removal, iterate through memory regions and only
remove non-KHO ones.  This preserves KHO scratch regions, which are good
known memory, while still allowing EFI to rebuild its memory map.

Link: https://lkml.kernel.org/r/b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/efi-init.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/firmware/efi/efi-init.c~efi-support-booting-with-kexec-handover-kho
+++ a/drivers/firmware/efi/efi-init.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/fwnode.h>
 #include <linux/init.h>
+#include <linux/kexec_handover.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
 #include <linux/of.h>
@@ -164,12 +165,32 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	/*
-	 * Discard memblocks discovered so far: if there are any at this
-	 * point, they originate from memory nodes in the DT, and UEFI
-	 * uses its own memory map instead.
+	 * Discard memblocks discovered so far except for KHO scratch
+	 * regions. Most memblocks at this point originate from memory nodes
+	 * in the DT and UEFI uses its own memory map instead. However, if
+	 * KHO is enabled, scratch regions, which are good known memory
+	 * must be preserved.
 	 */
 	memblock_dump_all();
-	memblock_remove(0, PHYS_ADDR_MAX);
+
+	if (is_kho_boot()) {
+		struct memblock_region *r;
+
+		/* Remove all non-KHO regions */
+		for_each_mem_region(r) {
+			if (!memblock_is_kho_scratch(r)) {
+				memblock_remove(r->base, r->size);
+				r--;
+			}
+		}
+	} else {
+		/*
+		 * KHO is disabled. Discard memblocks discovered so far:
+		 * if there are any at this point, they originate from memory
+		 * nodes in the DT, and UEFI uses its own memory map instead.
+		 */
+		memblock_remove(0, PHYS_ADDR_MAX);
+	}
 
 	for_each_efi_memory_desc(md) {
 		paddr = md->phys_addr;
_

Patches currently in -mm which might be from epetron@amazon.de are



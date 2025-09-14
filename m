Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82948156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810169; cv=none; b=SGo4E9AUW1BPWbigPdx+80nCSTQQCMqLbAEevY50KLPd3dyVXTlm1BVc+iXXC+4OqYA7+SW5RfXwefBHCkPDVNYsVWhNkK8w0D8QDk5Xov+UcGdsxJVDZUsh91/1rnrP7ls0bjS2+MSI8pIVH4zt68Gg+SKY2bbCT3zUR2cGsMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810169; c=relaxed/simple;
	bh=G3XXh3KXd9H4IQdI0Cq+tDMOSA1oaswLo+64Hu9OAEQ=;
	h=Date:To:From:Subject:Message-Id; b=nZSegDyRZiQ6amYNnu0pCQcuE81SXCko9jIycVafBqoN1QBv4DnRusVfBfpwP78pPpmzwVhIMxrfb527ONsp6oO0B6PAVY7i0Ix0UGVJLdQBCahm3g8DLoU5EbhHDH8AGpJFfq1NjpKois44pFNB0Z/8hzd4x+sKNtRWdF/Ubmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NEU9QPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NEU9QPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596DBC4CEEB;
	Sun, 14 Sep 2025 00:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810169;
	bh=G3XXh3KXd9H4IQdI0Cq+tDMOSA1oaswLo+64Hu9OAEQ=;
	h=Date:To:From:Subject:From;
	b=1NEU9QPsihv8FyVfVA0ImfvfzxkL0Xf+sV9nhrW3P8Xt1Lxs+ixmS5XW3ICvu+akl
	 W4wLhAIyWl/wH9nokDsM/WKBJP72ZFMpei54XHnbFMXyWG3cwixi1pV9ArnebAVF2C
	 toeS6b10yv9pDcjerbxmhlJxSxcKn0RdjqUeCaP8=
Date: Sat, 13 Sep 2025 17:36:08 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ardb@kernel.org,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-introduce-is_kho_boot.patch removed from -mm tree
Message-Id: <20250914003609.596DBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: introduce is_kho_boot()
has been removed from the -mm tree.  Its filename was
     kexec-introduce-is_kho_boot.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Evangelos Petrongonas <epetron@amazon.de>
Subject: kexec: introduce is_kho_boot()
Date: Thu, 21 Aug 2025 17:58:59 +0000

Patch series "efi: Fix EFI boot with kexec handover (KHO)", v3.

This patch series fixes a kernel panic that occurs when booting with both
EFI and KHO (Kexec HandOver) enabled.

The issue arises because EFI's `reserve_regions()` clears all memory
regions with `memblock_remove(0, PHYS_ADDR_MAX)` before rebuilding them
from EFI data.  This destroys KHO scratch regions that were set up early
during device tree scanning, causing a panic as the kernel has no valid
memory regions for early allocations.

The first patch introduces `is_kho_boot()` to allow early boot components
to reliably detect if the kernel was booted via KHO-enabled kexec.  The
existing `kho_is_enabled()` only checks the command line and doesn't
verify if an actual KHO FDT was passed.

The second patch modifies EFI's `reserve_regions()` to selectively remove
only non-KHO memory regions when KHO is active, preserving the critical
scratch regions while still allowing EFI to rebuild its memory map.


This patch (of 3):

During early initialisation, after a kexec, other components, like EFI
need to know if a KHO enabled kexec is performed.  The `kho_is_enabled`
function is not enough as in the early stages, it only reflects whether
the cmdline has KHO enabled, not if an actual KHO FDT exists.

Extend the KHO API with `is_kho_boot()` to provide a way for components to
check if a KHO enabled kexec is performed.

Link: https://lkml.kernel.org/r/cover.1755721529.git.epetron@amazon.de
Link: https://lkml.kernel.org/r/7dc6674a76bf6e68cca0222ccff32427699cc02e.1755721529.git.epetron@amazon.de
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |    6 ++++++
 kernel/kexec_handover.c        |   20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/include/linux/kexec_handover.h~kexec-introduce-is_kho_boot
+++ a/include/linux/kexec_handover.h
@@ -40,6 +40,7 @@ struct kho_serialization;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
+bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
@@ -59,6 +60,11 @@ static inline bool kho_is_enabled(void)
 {
 	return false;
 }
+
+static inline bool is_kho_boot(void)
+{
+	return false;
+}
 
 static inline int kho_preserve_folio(struct folio *folio)
 {
--- a/kernel/kexec_handover.c~kexec-introduce-is_kho_boot
+++ a/kernel/kexec_handover.c
@@ -952,6 +952,26 @@ static const void *kho_get_fdt(void)
 }
 
 /**
+ * is_kho_boot - check if current kernel was booted via KHO-enabled
+ * kexec
+ *
+ * This function checks if the current kernel was loaded through a kexec
+ * operation with KHO enabled, by verifying that a valid KHO FDT
+ * was passed.
+ *
+ * Note: This function returns reliable results only after
+ * kho_populate() has been called during early boot. Before that,
+ * it may return false even if KHO data is present.
+ *
+ * Return: true if booted via KHO-enabled kexec, false otherwise
+ */
+bool is_kho_boot(void)
+{
+	return !!kho_get_fdt();
+}
+EXPORT_SYMBOL_GPL(is_kho_boot);
+
+/**
  * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
  * @name: the name of the sub FDT passed to kho_add_subtree().
  * @phys: if found, the physical address of the sub FDT is stored in @phys.
_

Patches currently in -mm which might be from epetron@amazon.de are



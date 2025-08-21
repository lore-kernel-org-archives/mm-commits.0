Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B8C22172C
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755811821; cv=none; b=eJpKGj7H6fmj8gHOjfMdGiqKTcL8O1iv3cJJnrBmk3RdqafXIaDxOriE4+0EW1TbHXkj2TJcLqwJwFW50Kb0Fq6yzmLubWP0IiL1Q1CqGdKWlj79gjJnSbeig5DldQNYvR02rYgS8m/Hq0NTQiTCauSU96WY8/Zz9IaHYi+Muss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755811821; c=relaxed/simple;
	bh=4VhKyjGjBPPaJlWfpLcs/89fsEz3lm40C/yvH0g1Qf0=;
	h=Date:To:From:Subject:Message-Id; b=EOwlMpsIBTyDZxbvI109h1mUEROGtCc/hkKx3jS2vGTdBJDAhFNLyJBIzwDKLT21DegpU/QlryroHtbJR5DycwGWtt4nSRtiY1a8TzgjwyPmDE9Qx5ub82Ios+xa7DyDmPPrHi2znF2mHT8DymnJP3izuC7v2vUjIiaZvPr+AvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q8ChApvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q8ChApvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6EAC4CEEB;
	Thu, 21 Aug 2025 21:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755811820;
	bh=4VhKyjGjBPPaJlWfpLcs/89fsEz3lm40C/yvH0g1Qf0=;
	h=Date:To:From:Subject:From;
	b=Q8ChApvPBa1xBL6JT3m3l46HhjGELZFsUytXt7YbWNmuPRXck+k0mxfV6PnbzYe/G
	 q2QbcTUzrPdw70fkE/E0zf6owZ9CmHd7UXzlg+l9yCMevP+GjRuaCkq+GFLg9syR4+
	 n1AoDt9DQMUC2ONAiteaLm3QZxuYyAHHnqaLSU+U=
Date: Thu, 21 Aug 2025 14:30:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ardb@kernel.org,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-introduce-is_kho_boot.patch added to mm-hotfixes-unstable branch
Message-Id: <20250821213020.6C6EAC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: introduce is_kho_boot()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-introduce-is_kho_boot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-introduce-is_kho_boot.patch

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

kexec-introduce-is_kho_boot.patch
efi-support-booting-with-kexec-handover-kho.patch


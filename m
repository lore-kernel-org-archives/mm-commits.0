Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192535B12B
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156116; cv=none; b=luLinqtxmCz9kjvrxCqQrd50RAJQulNaFPH42U80GVhSsRl8O/Uz/4+zoKZen5BEgkq+vPq3bnpbFcLjOsPmETWps5VAEof8AO+5/Z2pjK+QrPdr63YYUFCvjk41feWGfLmpoGPHxRMt1ajXew1iOEBMm+SVvaqe1Y4b86kSHfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156116; c=relaxed/simple;
	bh=SqJB08PfmipHfIRde7r+8L/1t2pWJQwt0NrUGYBWTgU=;
	h=Date:To:From:Subject:Message-Id; b=losxeEd/JPUaNuk3+RgBPy5sIHxUhbgZKSumJzrSVCmv0hZiRy4g5T62w5BI4OtZgD4+skeMrGImiJK3n8/rLUo4A4oCvO3CncthccV1w8gMnbvU9Z74hhZ52BTxv07GCphGRCNooh700jU7VaN9VddUHpjH2QhpO/lwcKaezdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIGWuKj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIGWuKj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C50DC4CEF1;
	Fri, 14 Nov 2025 21:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156116;
	bh=SqJB08PfmipHfIRde7r+8L/1t2pWJQwt0NrUGYBWTgU=;
	h=Date:To:From:Subject:From;
	b=aIGWuKj9kAQMvtY7REABXq8FYYc5IC4+OfGpHogOd2kW7STkp3hP2ScczR+VV4GOp
	 uw55DuyRa67AfwEDJLVowpclMuWAaTSqJENeg0oUcJYT6MMEbaSR6BjrOfbEpCAboe
	 mvOIsKAcd3qKuQLZuEIMy7UN8PlBIWis2V/QzQf0=
Date: Fri, 14 Nov 2025 13:35:14 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-preserve-fdt-folio-only-once-during-initialization.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213516.1C50DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: preserve FDT folio only once during initialization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-preserve-fdt-folio-only-once-during-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-preserve-fdt-folio-only-once-during-initialization.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: preserve FDT folio only once during initialization
Date: Fri, 14 Nov 2025 13:59:53 -0500

Currently, the FDT folio is preserved inside __kho_finalize().  If the
user performs multiple finalize/abort cycles, kho_preserve_folio() is
called repeatedly for the same FDT folio.

Since the FDT folio is allocated once during kho_init(), it should be
marked for preservation at the same time.  Move the preservation call to
kho_init() to align the preservation state with the object's lifecycle and
simplify the finalize path.

Also, pre-zero the FDT tree so we do not expose random bits to the user
and to the next kernel by using the new kho_alloc_preserve() api.

Link: https://lkml.kernel.org/r/20251114190002.3311679-5-pasha.tatashin@soleen.com
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

 kernel/liveupdate/kexec_handover.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-preserve-fdt-folio-only-once-during-initialization
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1251,10 +1251,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
-	if (err)
-		goto abort;
-
 	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
@@ -1384,19 +1380,17 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static __init int kho_init(void)
 {
-	int err = 0;
 	const void *fdt = kho_get_fdt();
-	struct page *fdt_page;
+	int err = 0;
 
 	if (!kho_enable)
 		return 0;
 
-	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page) {
-		err = -ENOMEM;
+	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(kho_out.fdt)) {
+		err = PTR_ERR(kho_out.fdt);
 		goto err_free_scratch;
 	}
-	kho_out.fdt = page_to_virt(fdt_page);
 
 	err = kho_debugfs_init();
 	if (err)
@@ -1424,9 +1418,9 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(fdt_page);
-	kho_out.fdt = NULL;
+	kho_unpreserve_free(kho_out.fdt);
 err_free_scratch:
+	kho_out.fdt = NULL;
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
 		void *end = start + kho_scratch[i].size;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch


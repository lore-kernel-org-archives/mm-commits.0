Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F0627A904
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156130; cv=none; b=VXNwRjoscJGGk+XL38tGeeLjnY7BeeJPO4Qkk2iOomlxe5E1xzyjAzQMVUaZyeW13/iUarc4G7rQXbkO9Q4j7ILODmqsbfFKJUqBSfmXbrRacUXK1dC3H7wG5v+Gwq/f0x1vJVOEwBDcyYfJn2ZywMd9V469zD5KxxfqzVOhBcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156130; c=relaxed/simple;
	bh=RwN6HXf6FGhsa2PWXEjR6RBhIVFG6Xx1iyV1p81Vax8=;
	h=Date:To:From:Subject:Message-Id; b=nP+v4V9OUkMS68wB2ZXgV1SRt+I8KAPCJ9I7gsKYiqwFtF1hPntXTZ169UKRKDjUfhS7ydWF2ESMd/qdOB3cdVCIh40h3GnsUp6Y9xyBWkGoGhOSrCqr8kDb2J4uf6Ew2PFejdLUKjPErnpPiN77pApnj5NZ0aQRpo3QiRQjcX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KX1qtFNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KX1qtFNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66B7C16AAE;
	Fri, 14 Nov 2025 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156130;
	bh=RwN6HXf6FGhsa2PWXEjR6RBhIVFG6Xx1iyV1p81Vax8=;
	h=Date:To:From:Subject:From;
	b=KX1qtFNxw/m3u8SfvpOBMVpcA/gWFUn8DnUND4sZ78mdg+mrFnW/oVVF1hlTaMLZ9
	 bDCSNioz6oBAAThuVMwb5eNpgDAK+LKq3wTdOoLWjO17kuiFj8ygUFJfwj/uYkrWbX
	 pxuy7c1gDkmTx30VtBy/9C/EkrAwwQMdU6qvhW54=
Date: Fri, 14 Nov 2025 13:35:28 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-remove-abort-functionality-and-support-state-refresh.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213529.E66B7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: remove abort functionality and support state refresh
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-remove-abort-functionality-and-support-state-refresh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-remove-abort-functionality-and-support-state-refresh.patch

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
Subject: kho: remove abort functionality and support state refresh
Date: Fri, 14 Nov 2025 13:59:58 -0500

Previously, KHO required a dedicated kho_abort() function to clean up
state before kho_finalize() could be called again.  This was necessary to
handle complex unwind paths when using notifiers.

With the shift to direct memory preservation, the explicit abort step is
no longer strictly necessary.

Remove kho_abort() and refactor kho_finalize() to handle re-entry.  If
kho_finalize() is called while KHO is already finalized, it will now
automatically clean up the previous memory map and state before generating
a new one.  This allows the KHO state to be updated/refreshed simply by
triggering finalize again.

Update debugfs to return -EINVAL if userspace attempts to write 0 to the
finalize attribute, as explicit abort is no longer supported.

Link: https://lkml.kernel.org/r/20251114190002.3311679-10-pasha.tatashin@soleen.com
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 kernel/liveupdate/kexec_handover.c          |   21 +++---------------
 kernel/liveupdate/kexec_handover_debugfs.c  |    2 -
 kernel/liveupdate/kexec_handover_internal.h |    1 
 3 files changed, 5 insertions(+), 19 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1232,21 +1232,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-int kho_abort(void)
-{
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	if (!kho_out.finalized)
-		return -ENOENT;
-
-	kho_update_memory_map(NULL);
-	kho_out.finalized = false;
-
-	return 0;
-}
-
 static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
@@ -1297,8 +1282,10 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized)
-		return -EEXIST;
+	if (kho_out.finalized) {
+		kho_update_memory_map(NULL);
+		kho_out.finalized = false;
+	}
 
 	ret = __kho_finalize();
 	if (ret)
--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -87,7 +87,7 @@ static int kho_out_finalize_set(void *da
 	if (val)
 		return kho_finalize();
 	else
-		return kho_abort();
+		return -EINVAL;
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -24,7 +24,6 @@ extern unsigned int kho_scratch_cnt;
 
 bool kho_finalized(void);
 int kho_finalize(void);
-int kho_abort(void);
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FA3557E8
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156110; cv=none; b=RB3qcSaoZ+J27idWZNKE3DhmzA1monyKVRS2S/knSSJQgEBu9fP3/+zAm8LdRw+8ZAWjKb87EzJ3xB6ADsJoQKQ6auUHjBWT1x450nfIoj1QWw7/ioOfYIQhgpRkDpdiIJVOqR8YXqz5Cilv4cD6PQNKrjop4TXRHihOJ95DX0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156110; c=relaxed/simple;
	bh=a3xOO/y8vHnFVrdc93HARte/12ePJGM0vXUosOMVpLc=;
	h=Date:To:From:Subject:Message-Id; b=H84fRlPlzdImVS7671jBobBU9z3DVHPLC3MwaMgvVotp0xpdGOxeWM04nLx72Uni1nXoqWbnENA6yhf7LHcyizprbV18aan1VZcz7r04IohPNNZCWAJnj7hFH8zjSkwC3TppPmU+BSp6KO5Ygj4iuBozwS3muH3FDEpnQWbsGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwBLQf5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwBLQf5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D52BC4CEF5;
	Fri, 14 Nov 2025 21:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156110;
	bh=a3xOO/y8vHnFVrdc93HARte/12ePJGM0vXUosOMVpLc=;
	h=Date:To:From:Subject:From;
	b=YwBLQf5mRHJFPd78gyan+Shk+XVmezyk8xZASFYThnwdapaSEHA19ghXh4DrXEnbt
	 K8Vkb8tqr2KwX68p//KvjgelU4s/V05U4cNklkKc0hrcMReY4yrcaVRDbAZxCWe/rO
	 zQ7VwOBwTGog8EqYlhBd8K0daGg5dpTYgvPx/6so=
Date: Fri, 14 Nov 2025 13:35:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-convert-__kho_abort-to-return-void.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213510.0D52BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: convert __kho_abort() to return void
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-convert-__kho_abort-to-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-convert-__kho_abort-to-return-void.patch

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
Subject: kho: convert __kho_abort() to return void
Date: Fri, 14 Nov 2025 13:59:51 -0500

The internal helper __kho_abort() always returns 0 and has no failure
paths.  Its return value is ignored by __kho_finalize and checked
needlessly by kho_abort.

Change the return type to void to reflect that this function cannot fail,
and simplify kho_abort by removing dead error handling code.

Link: https://lkml.kernel.org/r/20251114190002.3311679-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-convert-__kho_abort-to-return-void
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1117,20 +1117,16 @@ err_free_pages_array:
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static int __kho_abort(void)
+static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
-
-	return 0;
 }
 
 int kho_abort(void)
 {
-	int ret = 0;
-
 	if (!kho_enable)
 		return -EOPNOTSUPP;
 
@@ -1138,10 +1134,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	ret = __kho_abort();
-	if (ret)
-		return ret;
-
+	__kho_abort();
 	kho_out.finalized = false;
 
 	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
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


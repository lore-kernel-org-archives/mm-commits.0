Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CDD3FBA7
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764281969; cv=none; b=NQzuuNbpTIUXTHhWL0N2jbY+3X+2la4wooI1MespOECZ5z8iLN+YiE0RPUTuEneJjgnU88q65xn68lrTa6RfnV0/Uy/ns7hNbbbRZHzd6uKRnB4jzQoALbeGv0Vr2/RJzvCIehMLnf/7IhOc5iSpFMx2p8pBJEJmiVdyd+gRkU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764281969; c=relaxed/simple;
	bh=q3LB3XkgLQ1/z5UPif10A3t+Rr1sH3IoY1dFRgh8Ixs=;
	h=Date:To:From:Subject:Message-Id; b=Mg+OhtOJEncnopi3vpImTG0u0Lecxzx3Dz5JxSw9nE3cjCpf4MJTTe8G1ZTqbdB4p86Pv0XhTYNoHmjmEZpCFqLjSZKXjjT9AJ85XRxxMZyfV0sAKHwehKzTuUWdisBCmQBmv28LS7Otj44U/GkIazwBNnjfm+7ePpQSoZhLUUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1KzTTar3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1KzTTar3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093A8C4CEF8;
	Thu, 27 Nov 2025 22:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764281968;
	bh=q3LB3XkgLQ1/z5UPif10A3t+Rr1sH3IoY1dFRgh8Ixs=;
	h=Date:To:From:Subject:From;
	b=1KzTTar3xx3cpHpUHF0zT5isQZtf2XNwpJGnpVjYLQQV/tQk7vFIpdIjjBDxAQbly
	 gULhUoKypi1I3PyIQFBlPQ68AfDukXs48pFC281D4oC3tZ+Js6rLlfQBTM0kd9xEK0
	 Bjjr53CDjDsBA8ztd7tHgVTS7StNMJV5oXmKpDQY=
Date: Thu, 27 Nov 2025 14:19:27 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-kho-move-to-kernel-liveupdate-fix.patch removed from -mm tree
Message-Id: <20251127221928.093A8C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-move-to-kernel-liveupdate-fix.patch

This patch was dropped because it was folded into liveupdate-kho-move-to-kernel-liveupdate.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
Date: Sat, 8 Nov 2025 13:01:30 -0500

disable the menu when DEFERRED_STRUCT_PAGE_INIT

Link: https://lkml.kernel.org/r/CA+CK2bAvh9Oa2SLfsbJ8zztpEjrgr_hr-uGgF1coy8yoibT39A@mail.gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/Kconfig~liveupdate-kho-move-to-kernel-liveupdate-fix
+++ a/kernel/liveupdate/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-introduce-high-level-memory-allocation-api-fix.patch
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
liveupdate-luo_core-live-update-orchestrato.patch
liveupdate-luo_core-integrate-with-kho.patch
kexec-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_core-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-simple-kexec-based-selftest-for-luo.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch


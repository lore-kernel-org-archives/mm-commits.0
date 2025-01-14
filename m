Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294C722F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835821; cv=none; b=blroLRixitJoXQXmXxhzfuEZuGxIH/x0ifiALYK3SMLBKq9XPhwse/WTr5D34mKe71gZF8IHvlmvu+y6+kGUr3tO4FcGWr8erPjle2Le+28OjNYwnvBJgU3O2c8vgFsBe3AfbAFsXrr6waKKVR83OlSG8Qff/nG7YErYjyvXZ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835821; c=relaxed/simple;
	bh=Z7KrjipgseyJ7/0YL6IyD7z2Wnr1Vf+SVE+hqprV9jw=;
	h=Date:To:From:Subject:Message-Id; b=JhNq3U3vr3vc/B1iKotE86lQPgTlFzd9jwfmprMfLVzNarqZl9Lbxbsnrx7+L3GEhNXJ/8sxI8NuH+FedTpMS8HpmuyQcqH6K6r3OoUWk2fzWEqSCA0ZfHbZhtyjSESmHH4yILjzioog+2KhB8v3pb8QkDvYMgHrtT1b3aE6n2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TV3wy6ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TV3wy6ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DC9C4CEDD;
	Tue, 14 Jan 2025 06:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835820;
	bh=Z7KrjipgseyJ7/0YL6IyD7z2Wnr1Vf+SVE+hqprV9jw=;
	h=Date:To:From:Subject:From;
	b=TV3wy6eiKc5Y1FxjgoDZ/oFI+616FLe+T/uOTPxKi4BrIPsZWP2spVYh/1tOS1NA6
	 WOIRLE/eg6eD3JRXBEjlF/ILn9j2eT1zUObi871ZYml9J46i2ltraAGHmGbtfK1SQW
	 V3OUXhUs7Q7bTFsd/6w7cCIyQz4yApJ1Y6FNaxYw=
Date: Mon, 13 Jan 2025 22:23:40 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-move-brk-internals-to-mm-vmac-fix.patch removed from -mm tree
Message-Id: <20250114062340.98DC9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add missing personality header import
has been removed from the -mm tree.  Its filename was
     mm-vma-move-brk-internals-to-mm-vmac-fix.patch

This patch was dropped because it was folded into mm-vma-move-brk-internals-to-mm-vmac.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: add missing personality header import
Date: Wed, 4 Dec 2024 12:00:35 +0000

Some architectures have different header dependency chains, we incorrectly
failed to important linux/personality.h which broke MIPS. Fix this.

Link: https://lkml.kernel.org/r/2a717265-985f-45eb-9257-8b2857088ed4@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vma_internal.h~mm-vma-move-brk-internals-to-mm-vmac-fix
+++ a/mm/vma_internal.h
@@ -35,6 +35,7 @@
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/perf_event.h>
+#include <linux/personality.h>
 #include <linux/pfn.h>
 #include <linux/rcupdate.h>
 #include <linux/rmap.h>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch
mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state.patch
mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch
mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC26627979A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226814; cv=none; b=c+1qO2mtiOmElNznRAjd3lmsi/J4Uyql0ZWOodmPkDs6KcXeaba49N2mbVqhw+bH5fcc63Ims4KnuLmoxDZVYQDx6XyuvQPoIPJXoPT4p/kJTAt95ODeY2wy9W7w9lr+xFlVeNVPF9ckjg8+vh/W8uAkaJPRUYcdo2UewknLUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226814; c=relaxed/simple;
	bh=T92hNIxOADdWooMS/bEXe9yIwUtAEUM+2x6kiUb654s=;
	h=Date:To:From:Subject:Message-Id; b=b1o0Hch3asaG9D6PIO3Ta24+S62Fc+XXceddNAw1PxFJk8oKAddB/du5yqrFe1a17pFO8iX6R59YZYBzc75w0gIvkBmZ5H5ET5y2VBtr/sNtGTC4WmmDFeNKQMgOnqKkJ/Rwi0d7XNFtItFBi+Y1rCYVUvJr9ccFU+wmDjUo7sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QhsB7Ggh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QhsB7Ggh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B34C113D0;
	Tue,  4 Nov 2025 03:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762226814;
	bh=T92hNIxOADdWooMS/bEXe9yIwUtAEUM+2x6kiUb654s=;
	h=Date:To:From:Subject:From;
	b=QhsB7GghkgVrgrs/JhI+Panx3IoeYKiJ6Cf0gO4/hOGLoPln8oLXs99VTv/S27QIx
	 TQdJJ2MKBYEDpWPBACmOpsE55xuLyKk8ULyhlF5EO+VJsdOHqMNiuO//s/QqYHoS6M
	 XjJwMwArDgYYxko7eg/o6sfKIpw/rLX5lI5vk3RU=
Date: Mon, 03 Nov 2025 19:26:53 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,yanjun.zhu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20251104032654.27B34C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: kho: use %pe format specifier for error pointer printing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch

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
From: Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: liveupdate: kho: use %pe format specifier for error pointer printing
Date: Sat, 1 Nov 2025 10:23:25 -0400

Make pr_xxx() call to use the %pe format specifier instead of %d.  The %pe
specifier prints a symbolic error string (e.g., -ENOMEM, -EINVAL) when
given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error message
by showing a descriptive error name rather than a numeric error code.

Note, that some err are still printed by value, as those errors might come
from libfdt and not regular errnos.

Link: https://lkml.kernel.org/r/20251101142325.1326536-10-pasha.tatashin@soleen.com
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c         |    4 ++--
 kernel/liveupdate/kexec_handover_debugfs.c |   10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1449,8 +1449,8 @@ void __init kho_populate(phys_addr_t fdt
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
 		if (WARN_ON(err)) {
-			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %d",
-				&area->addr, &size, err);
+			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
+				&area->addr, &size, ERR_PTR(err));
 			goto out;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
--- a/kernel/liveupdate/kexec_handover_debugfs.c~liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -150,8 +150,8 @@ __init void kho_in_debugfs_init(struct k
 		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
 					    phys_to_virt(*fdt_phys));
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
-				err);
+			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
+				ERR_PTR(err));
 			continue;
 		}
 	}
@@ -168,8 +168,10 @@ err_out:
 	 * reviving state from KHO and setting up KHO for the next
 	 * kexec.
 	 */
-	if (err)
-		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
+	if (err) {
+		pr_err("failed exposing handover FDT in debugfs: %pe\n",
+		       ERR_PTR(err));
+	}
 }
 
 __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
_

Patches currently in -mm which might be from yanjun.zhu@linux.dev are

liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch


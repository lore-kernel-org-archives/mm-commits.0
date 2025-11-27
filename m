Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF831579B
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282369; cv=none; b=In3EPI0jSRzPb/xF6Yhfsf3EVlfmt3VmdHbM17we/n5o8EIFsE3263eznvyRxWjGqH6GWYW9ruuBedj869Dit/3ln5KPX0h4uK8OMzo5rRmxhq58xNibaNpF6tbJ6aVyDrTeYbVf9Wtyhp9j3xRxIiwiO6N1W5Coo2MExf74rcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282369; c=relaxed/simple;
	bh=uRru0r1x61TnUauc7YF0pVBSb+FmsdBkug7W1dYf8vk=;
	h=Date:To:From:Subject:Message-Id; b=MX9MhEaFbGDvJm2xxwfgg6GMua2RQI17YNxuyBduHLR5fXQCI7nQ9uhbL+sLoNG8E5EZQQDWl8HGeHt8muUAo3YLZGZFBedGgCbSXRcc1cegyr+1fAXEgRGBWZD5X6dHlR/uKZLzcRSRA3xPmX4anaw1/LyM4JvYT8AkIEf/fAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p3EaI7o1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p3EaI7o1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DAAC113D0;
	Thu, 27 Nov 2025 22:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282369;
	bh=uRru0r1x61TnUauc7YF0pVBSb+FmsdBkug7W1dYf8vk=;
	h=Date:To:From:Subject:From;
	b=p3EaI7o1ekwKG9N0hvwaUpms4mQMfYthkyJvsPepOAOMchI1fOiz+LhR3BR6Do+vZ
	 QqT2ZMZ134KxrxdMWE1a4YLHrBnQBH5DLDJqaOy7385OLB3w/t5Oi9sdjQ7UnhOxo1
	 OpSR2vSyG003A784DtAfbkHNmXS6Rwdk6aMx4XtU=
Date: Thu, 27 Nov 2025 14:26:09 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,yanjun.zhu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch removed from -mm tree
Message-Id: <20251127222609.96DAAC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: kho: use %pe format specifier for error pointer printing
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
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



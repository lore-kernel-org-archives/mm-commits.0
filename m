Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F0F8615A
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976130; cv=none; b=KMHvGsWR7HFCMEIceaztxGBQJ8YngECgK/dSGm1EhovQjQXJl3rtq6Mvp8w4up66Q7Iv6ItGAqQ4pPpKgoSJydFIO0Xv0vz/xxNHLCsSUQKs6d+Q04dEEwFU6uKs+bDYRK0og6EZI3U0lzour8ZJkcm6GsePVd+RV7dFqss8bPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976130; c=relaxed/simple;
	bh=LHjmBkRVYmB85MJ/c7ZEOKLrgpNVWHfJv9Qkzo5XI2k=;
	h=Date:To:From:Subject:Message-Id; b=adVNkRBeqkyHibkaiyErL4mQb97DaH4WxLmEFTuj/Zcl4vqEESAVkpqh+okUXL7RcH0w+CWpHtiQlKPEpCkDH/JtDzz7sel/AtQWJkilAAh5MdRAOB4U5WrKkoarSB54WDLfE8TOF291uSHbYgFuHj7baLhn8mCBpcZiefmkAjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yEgut/qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yEgut/qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED7C4CEE7;
	Thu,  9 Oct 2025 02:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759976129;
	bh=LHjmBkRVYmB85MJ/c7ZEOKLrgpNVWHfJv9Qkzo5XI2k=;
	h=Date:To:From:Subject:From;
	b=yEgut/qWRORod4edV7+aAgpH6XeuMm+PrHE5OfdtqnaD7yIA1RSgrLp4X00ueh6HV
	 sXSxJdIhpk+8fmZPy0ne6WQPZwHHItkrnaY2qQ6GlIQy+/o146LbQIQ5P/FHFuW2EF
	 zuANK2YlrjyIRkfAlsooBPce2dxdd33ocSkDBb+Q=
Date: Wed, 08 Oct 2025 19:15:29 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-move-kho-debugfs-directory-to-liveupdate.patch added to mm-nonmm-unstable branch
Message-Id: <20251009021529.8DED7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: move kho debugfs directory to liveupdate
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-move-kho-debugfs-directory-to-liveupdate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-move-kho-debugfs-directory-to-liveupdate.patch

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
Subject: kho: move kho debugfs directory to liveupdate
Date: Tue, 7 Oct 2025 03:31:00 +0000

Now, that LUO and KHO both live under kernel/liveupdate, it makes sense to
also move the kho debugfs files to liveupdate/

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so future LUO selftests could
use it as well.

Link: https://lkml.kernel.org/r/20251007033100.836886-8-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
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

 kernel/liveupdate/kexec_handover_debug.c    |   10 +++++-----
 kernel/liveupdate/kexec_handover_internal.h |    2 ++
 tools/testing/selftests/kho/init.c          |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/liveupdate/kexec_handover_debug.c~kho-move-kho-debugfs-directory-to-liveupdate
+++ a/kernel/liveupdate/kexec_handover_debug.c
@@ -15,7 +15,7 @@
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -115,7 +115,7 @@ __init void kho_in_debugfs_init(struct k
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("kho_in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -175,7 +175,7 @@ __init int kho_out_debugfs_init(struct k
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("kho_out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -209,8 +209,8 @@ err_rmdir:
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-move-kho-debugfs-directory-to-liveupdate
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -15,6 +15,8 @@ struct kho_debugfs {
 	struct list_head fdt_list;
 };
 
+extern struct dentry *liveupdate_debugfs_root;
+
 #else
 struct kho_debugfs {};
 #endif
--- a/tools/testing/selftests/kho/init.c~kho-move-kho-debugfs-directory-to-liveupdate
+++ a/tools/testing/selftests/kho/init.c
@@ -11,7 +11,7 @@
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-#define KHO_FINALIZE "/debugfs/kho/out/finalize"
+#define KHO_FINALIZE "/debugfs/liveupdate/kho_out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranes.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
kho-move-kho-debugfs-directory-to-liveupdate.patch


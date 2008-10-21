From: akpm@linux-foundation.org
Subject: + export-tiny-shmem_file_setup-for-drm-gem.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:51:49 -0700
Message-ID: <200810212051.m9LKpnki017252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYJUUwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, airlied@redhat.com, mpm@selenic.com


The patch titled
     Export tiny shmem_file_setup for DRM-GEM
has been added to the -mm tree.  Its filename is
     export-tiny-shmem_file_setup-for-drm-gem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Export tiny shmem_file_setup for DRM-GEM
From: Hugh Dickins <hugh@veritas.com>

We're trying to keep the !CONFIG_SHMEM tiny-shmem.c (using ramfs without
swap) in synch with CONFIG_SHMEM shmem.c (and mpm is preparing patches to
combine them).  I was glad to see EXPORT_SYMBOL_GPL(shmem_file_setup) go
into shmem.c, but why not support DRM-GEM when !CONFIG_SHMEM too?  But
caution says still depend on MMU, since !CONFIG_MMU is..  different.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/Kconfig |    2 +-
 mm/tiny-shmem.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/Kconfig~export-tiny-shmem_file_setup-for-drm-gem drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~export-tiny-shmem_file_setup-for-drm-gem
+++ a/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
 #
 menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
-	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && SHMEM
+	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
diff -puN mm/tiny-shmem.c~export-tiny-shmem_file_setup-for-drm-gem mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~export-tiny-shmem_file_setup-for-drm-gem
+++ a/mm/tiny-shmem.c
@@ -95,6 +95,7 @@ put_dentry:
 put_memory:
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL_GPL(shmem_file_setup);
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
export-tiny-shmem_file_setup-for-drm-gem.patch
prio_tree-debugging-patch.patch


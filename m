From: akpm@linux-foundation.org
Subject: - mm-mmap-remove-sparse-warning-null-as-0.patch removed from -mm tree
Date: Sat, 22 Dec 2007 15:26:26 -0800
Message-ID: <200712222326.lBMNQQXR024670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbXLVX0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 18:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     mm/mmap: remove sparse-warning (NULL as 0)
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-sparse-warning-null-as-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/mmap: remove sparse-warning (NULL as 0)
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   mm/mmap.c
mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
mm/mmap.c:1944:29: warning: Using plain integer as NULL pointer

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-mmap-remove-sparse-warning-null-as-0 mm/mmap.c
--- a/mm/mmap.c~mm-mmap-remove-sparse-warning-null-as-0
+++ a/mm/mmap.c
@@ -1625,7 +1625,7 @@ static inline int expand_downwards(struc
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
-	error = security_file_mmap(0, 0, 0, 0, address, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
 	if (error)
 		return error;
 
@@ -1946,7 +1946,7 @@ unsigned long do_brk(unsigned long addr,
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	error = security_file_mmap(0, 0, 0, 0, addr, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
 	if (error)
 		return error;
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
git-selinux.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
ipc-convert-handmade-min-to-min.patch

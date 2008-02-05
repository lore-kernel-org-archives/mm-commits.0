From: akpm@linux-foundation.org
Subject: - uml-implement-o_append.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:12 -0800
Message-ID: <200802052237.m15Mbr6p012903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760429AbYBEWlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: implement O_APPEND
has been removed from the -mm tree.  Its filename was
     uml-implement-o_append.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: implement O_APPEND
From: Jeff Dike <jdike@addtoit.com>

The .a flags in openflags never had an implementation.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/os-Linux/file.c~uml-implement-o_append arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-implement-o_append
+++ a/arch/um/os-Linux/file.c
@@ -191,6 +191,8 @@ int os_open_file(const char *file, struc
 		f |= O_TRUNC;
 	if (flags.e)
 		f |= O_EXCL;
+	if (flags.a)
+		f |= O_APPEND;
 
 	fd = open64(file, f, mode);
 	if (fd < 0)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch

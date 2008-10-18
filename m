From: akpm@linux-foundation.org
Subject: - alpha-introduce-field-taso-into-struct-linux_binprm.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:24 -0700
Message-ID: <200810182314.m9INEOgc028393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYJRXOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, ink@jurassic.park.msu.ru, rth@twiddle.net, viro@zeniv.linux.org.uk, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     alpha: introduce field 'taso' into struct linux_binprm
has been removed from the -mm tree.  Its filename was
     alpha-introduce-field-taso-into-struct-linux_binprm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: introduce field 'taso' into struct linux_binprm
From: "Kirill A. Shutemov" <kirill@shutemov.name>

This change is Alpha-specific.  It adds field 'taso' into struct
linux_binprm to remember if the application is TASO.  Previously, field
sh_bang was wsed for this purpose.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/a.out.h |    2 +-
 fs/exec.c                      |    2 +-
 include/linux/binfmts.h        |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/a.out.h~alpha-introduce-field-taso-into-struct-linux_binprm arch/alpha/include/asm/a.out.h
--- a/arch/alpha/include/asm/a.out.h~alpha-introduce-field-taso-into-struct-linux_binprm
+++ a/arch/alpha/include/asm/a.out.h
@@ -95,7 +95,7 @@ struct exec
    Worse, we have to notice the start address before swapping to use
    /sbin/loader, which of course is _not_ a TASO application.  */
 #define SET_AOUT_PERSONALITY(BFPM, EX) \
-	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
+	set_personality (((BFPM->taso || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
 #endif /* __KERNEL__ */
diff -puN fs/exec.c~alpha-introduce-field-taso-into-struct-linux_binprm fs/exec.c
--- a/fs/exec.c~alpha-introduce-field-taso-into-struct-linux_binprm
+++ a/fs/exec.c
@@ -1189,7 +1189,7 @@ int search_binary_handler(struct linux_b
 			return retval;
 
 		/* Remember if the application is TASO.  */
-		bprm->sh_bang = eh->ah.entry < 0x100000000UL;
+		bprm->taso = eh->ah.entry < 0x100000000UL;
 
 		bprm->file = file;
 		bprm->loader = loader;
diff -puN include/linux/binfmts.h~alpha-introduce-field-taso-into-struct-linux_binprm include/linux/binfmts.h
--- a/include/linux/binfmts.h~alpha-introduce-field-taso-into-struct-linux_binprm
+++ a/include/linux/binfmts.h
@@ -36,6 +36,9 @@ struct linux_binprm{
 	unsigned long p; /* current top of mem */
 	unsigned int sh_bang:1,
 		     misc_bang:1;
+#ifdef __alpha__
+	unsigned int taso:1;
+#endif
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch


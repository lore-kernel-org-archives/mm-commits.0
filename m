From: akpm@linux-foundation.org
Subject: + alpha-introduce-field-taso-into-struct-linux_binprm.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:39:32 -0700
Message-ID: <200809082239.m88MdWcT013914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbYIHWjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, ink@jurassic.park.msu.ru, rth@twiddle.net, viro@zeniv.linux.org.uk, xemul@openvz.org


The patch titled
     alpha: introduce field 'taso' into struct linux_binprm
has been added to the -mm tree.  Its filename is
     alpha-introduce-field-taso-into-struct-linux_binprm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1195,7 +1195,7 @@ int search_binary_handler(struct linux_b
 			return retval;
 
 		/* Remember if the application is TASO.  */
-		bprm->sh_bang = eh->ah.entry < 0x100000000UL;
+		bprm->taso = eh->ah.entry < 0x100000000UL;
 
 		bprm->file = file;
 		bprm->loader = loader;
diff -puN include/linux/binfmts.h~alpha-introduce-field-taso-into-struct-linux_binprm include/linux/binfmts.h
--- a/include/linux/binfmts.h~alpha-introduce-field-taso-into-struct-linux_binprm
+++ a/include/linux/binfmts.h
@@ -41,6 +41,9 @@ struct linux_binprm{
 		cap_effective:1;/* true if has elevated effective capabilities,
 				 * false if not; except for init which inherits
 				 * its parent's caps anyway */
+#ifdef __alpha__
+	unsigned int taso:1;
+#endif
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
_

Patches currently in -mm which might be from kirill@shutemov.name are

alpha-introduce-field-taso-into-struct-linux_binprm.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch


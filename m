From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:05:11 -0700
Message-ID: <200704070105.l3715BZ6024377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbXDGBFX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     ROUND_UP macro cleanup in arch/alpha/kernel/osf_sys.c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROUND_UP macro cleanup in arch/alpha/kernel/osf_sys.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc
+++ a/arch/alpha/kernel/osf_sys.c
@@ -93,7 +93,6 @@ osf_set_program_attributes(unsigned long
  * offset differences aren't the same as "d_reclen").
  */
 #define NAME_OFFSET	offsetof (struct osf_dirent, d_name)
-#define ROUND_UP(x)	(((x)+3) & ~3)
 
 struct osf_dirent {
 	unsigned int d_ino;
@@ -115,7 +114,7 @@ osf_filldir(void *__buf, const char *nam
 {
 	struct osf_dirent __user *dirent;
 	struct osf_dirent_callback *buf = (struct osf_dirent_callback *) __buf;
-	unsigned int reclen = ROUND_UP(NAME_OFFSET + namlen + 1);
+	unsigned int reclen = ALIGN(NAME_OFFSET + namlen + 1, sizeof(u32));
 	unsigned int d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail */
@@ -174,7 +173,6 @@ osf_getdirentries(unsigned int fd, struc
 	return error;
 }
 
-#undef ROUND_UP
 #undef NAME_OFFSET
 
 asmlinkage unsigned long
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch

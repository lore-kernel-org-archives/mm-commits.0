From: akpm@linux-foundation.org
Subject: + module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch added to -mm tree
Date: Mon, 05 May 2008 14:09:31 -0700
Message-ID: <200805052109.m45L9V2G005188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbYEEVKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 17:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, rusty@rustcorp.com.au


The patch titled
     module loading ELF handling: use SELFMAG instead of numeric constant
has been added to the -mm tree.  Its filename is
     module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

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
Subject: module loading ELF handling: use SELFMAG instead of numeric constant
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/module.c~module-loading-elf-handling-use-selfmag-instead-of-numeric-constant kernel/module.c
--- a/kernel/module.c~module-loading-elf-handling-use-selfmag-instead-of-numeric-constant
+++ a/kernel/module.c
@@ -1777,7 +1777,7 @@ static struct module *load_module(void _
 
 	/* Sanity checks against insmoding binaries or wrong arch,
            weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
 	    || hdr->e_type != ET_REL
 	    || !elf_check_arch(hdr)
 	    || hdr->e_shentsize != sizeof(*sechdrs)) {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
cifs-find_unc-cleanup.patch
cifs-cifs_find_tcp_session-cleanup.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch
mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch


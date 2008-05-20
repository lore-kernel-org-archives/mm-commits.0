From: akpm@linux-foundation.org
Subject: - module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:39 -0700
Message-ID: <200805202114.m4KLEd2A011484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932495AbYETVPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module loading ELF handling: use SELFMAG instead of numeric constant
has been removed from the -mm tree.  Its filename was
     module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

ecryptfs-fix-missed-mutex_unlock.patch
linux-next.patch


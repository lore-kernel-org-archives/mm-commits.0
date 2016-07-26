From: akpm@linux-foundation.org
Subject: + binfmt_em86-fix-incompatible-pointer-type.patch added to -mm
 tree
Date: Tue, 26 Jul 2016 13:45:43 -0700
Message-ID: <5797cbf7.dOj2cvw/WBNK5PJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbcGZUpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 16:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_em86.c: fix incompatible pointer type
has been added to the -mm tree.  Its filename is
     binfmt_em86-fix-incompatible-pointer-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_em86-fix-incompatible-pointer-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_em86-fix-incompatible-pointer-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: fs/binfmt_em86.c: fix incompatible pointer type

Since the -Wincompatible-pointer-types is reported as error, alpha
doesn't build anymore. Let's fix it in a minimal way.

fs/binfmt_em86.c:73:35: error: passing argument 2 of `copy_strings_kernel' from incompatible pointer type [-Werror=incompatible-pointer-types]
   retval = copy_strings_kernel(1, &i_arg, bprm);
                                   ^            ^
fs/binfmt_em86.c:77:34: error: passing argument 2 of `copy_strings_kernel' from incompatible pointer type [-Werror=incompatible-pointer-types]
  retval = copy_strings_kernel(1, &i_name, bprm);
                                  ^
Link: http://lkml.kernel.org/r/1469525978-23359-1-git-send-email-wagi@monom.org
Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_em86.c~binfmt_em86-fix-incompatible-pointer-type fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~binfmt_em86-fix-incompatible-pointer-type
+++ a/fs/binfmt_em86.c
@@ -24,7 +24,8 @@
 
 static int load_em86(struct linux_binprm *bprm)
 {
-	char *interp, *i_name, *i_arg;
+	const char *i_name, *i_arg;
+	char *interp;
 	struct file * file;
 	int retval;
 	struct elfhdr	elf_ex;
_

Patches currently in -mm which might be from daniel.wagner@bmw-carit.de are

binfmt_em86-fix-incompatible-pointer-type.patch


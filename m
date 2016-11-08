From: akpm@linux-foundation.org
Subject: + proc-make-struct-pid_entry-len-unsigned.patch added to -mm tree
Date: Mon, 07 Nov 2016 16:48:16 -0800
Message-ID: <582120d0.5/iuWOGut05zGLc+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbcKHAsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2016 19:48:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make struct pid_entry::len unsigned
has been added to the -mm tree.  Its filename is
     proc-make-struct-pid_entry-len-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-make-struct-pid_entry-len-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-make-struct-pid_entry-len-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: make struct pid_entry::len unsigned

"unsigned int" is better on x86_64 because it most of the time it
autoexpands to 64-bit value while "int" requires MOVSX instruction.

Link: http://lkml.kernel.org/r/20161029160810.GF1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-make-struct-pid_entry-len-unsigned fs/proc/base.c
--- a/fs/proc/base.c~proc-make-struct-pid_entry-len-unsigned
+++ a/fs/proc/base.c
@@ -106,7 +106,7 @@
 
 struct pid_entry {
 	const char *name;
-	int len;
+	unsigned int len;
 	umode_t mode;
 	const struct inode_operations *iop;
 	const struct file_operations *fop;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

scripts-bloat-o-meter-fix-sigpipe.patch
kbuild-simpler-generation-of-assembly-constants.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch


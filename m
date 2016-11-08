From: akpm@linux-foundation.org
Subject: + proc-make-struct-struct-map_files_info-len-unsigned-int.patch
 added to -mm tree
Date: Mon, 07 Nov 2016 16:48:18 -0800
Message-ID: <582120d2.iOEMdig6kITVBfRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbcKHAsT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2016 19:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make struct struct map_files_info::len unsigned int
has been added to the -mm tree.  Its filename is
     proc-make-struct-struct-map_files_info-len-unsigned-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-make-struct-struct-map_files_info-len-unsigned-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-make-struct-struct-map_files_info-len-unsigned-int.patch

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
Subject: proc: make struct struct map_files_info::len unsigned int

Linux doesn't support 4GB+ filenames in /proc, so unsigned long is too much.

MOV r64, r/m64 is smaller than MOV r32, r/m32.

Link: http://lkml.kernel.org/r/20161029161123.GG1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-make-struct-struct-map_files_info-len-unsigned-int fs/proc/base.c
--- a/fs/proc/base.c~proc-make-struct-struct-map_files_info-len-unsigned-int
+++ a/fs/proc/base.c
@@ -1967,7 +1967,7 @@ out:
 
 struct map_files_info {
 	fmode_t		mode;
-	unsigned long	len;
+	unsigned int	len;
 	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
 };
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

scripts-bloat-o-meter-fix-sigpipe.patch
kbuild-simpler-generation-of-assembly-constants.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch


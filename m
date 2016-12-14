From: akpm@linux-foundation.org
Subject: [merged]
 proc-make-struct-struct-map_files_info-len-unsigned-int.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:26:48 -0800
Message-ID: <58519cf8.72Euny0sFOKoPUCn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbcLNT0t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make struct struct map_files_info::len unsigned int
has been removed from the -mm tree.  Its filename was
     proc-make-struct-struct-map_files_info-len-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch


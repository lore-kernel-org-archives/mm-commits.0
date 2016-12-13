From: akpm@linux-foundation.org
Subject: [patch 092/123] proc: make struct struct map_files_info::len
 unsigned int
Date: Mon, 12 Dec 2016 16:45:11 -0800
Message-ID: <584f4497.ghRKF2sDrAuY+r5D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

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

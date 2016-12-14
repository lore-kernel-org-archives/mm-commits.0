From: akpm@linux-foundation.org
Subject: [merged] proc-make-struct-pid_entry-len-unsigned.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:26:46 -0800
Message-ID: <58519cf6.7jisjhC4pGof1kXy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756475AbcLNT0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make struct pid_entry::len unsigned
has been removed from the -mm tree.  Its filename was
     proc-make-struct-pid_entry-len-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch


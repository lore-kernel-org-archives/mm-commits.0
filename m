From: akpm@linux-foundation.org
Subject: [patch 091/123] proc: make struct pid_entry::len unsigned
Date: Mon, 12 Dec 2016 16:45:08 -0800
Message-ID: <584f4494.tbL5kDI60q+ChRZ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

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

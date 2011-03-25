From: akpm@linux-foundation.org
Subject: [merged] proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:37 -0700
Message-ID: <201103250725.p2P7PVqc026031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933909Ab1CYHZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: document why writing to /proc/pid/mem is a security hazard
has been removed from the -mm tree.  Its filename was
     proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: document why writing to /proc/pid/mem is a security hazard
From: Stephen Wilson <wilsons@start.ca>

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard fs/proc/base.c
--- a/fs/proc/base.c~proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard
+++ a/fs/proc/base.c
@@ -832,7 +832,11 @@ out_no_task:
 #define mem_write NULL
 
 #ifndef mem_write
-/* This is a security hazard */
+/*
+ * As implemented, mem_write would be a security hazard if enabled.  For
+ * example, the target task could exec a setuid-root binary between the
+ * permission check and the write into memory.
+ */
 static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from wilsons@start.ca are

origin.patch


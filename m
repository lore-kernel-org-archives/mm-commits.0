From: akpm@linux-foundation.org
Subject: + proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch added to -mm tree
Date: Fri, 04 Mar 2011 18:30:03 -0800
Message-ID: <201103050230.p252UFT0018512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab1CECaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 21:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, viro@zeniv.linux.org.uk


The patch titled
     proc: document why writing to /proc/pid/mem is a security hazard
has been added to the -mm tree.  Its filename is
     proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch


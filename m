From: akpm@linux-foundation.org
Subject: - crypto-switch-to-proc_create.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:38 -0800
Message-ID: <200803062222.m26MMcfe020824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbYCFWYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     crypto: switch to proc_create()
has been removed from the -mm tree.  Its filename was
     crypto-switch-to-proc_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: switch to proc_create()
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/proc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN crypto/proc.c~crypto-switch-to-proc_create crypto/proc.c
--- a/crypto/proc.c~crypto-switch-to-proc_create
+++ a/crypto/proc.c
@@ -99,11 +99,7 @@ static const struct file_operations proc
 
 void __init crypto_init_proc(void)
 {
-	struct proc_dir_entry *proc;
-	
-	proc = create_proc_entry("crypto", 0, NULL);
-	if (proc)
-		proc->proc_fops = &proc_crypto_ops;
+	proc_create("crypto", 0, NULL, &proc_crypto_ops);
 }
 
 void __exit crypto_exit_proc(void)
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch


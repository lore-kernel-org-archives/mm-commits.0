From: akpm@linux-foundation.org
Subject: + crypto-switch-to-proc_create.patch added to -mm tree
Date: Wed, 27 Feb 2008 22:29:21 -0800
Message-ID: <200802280629.m1S6TLpB019469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYB1GbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 01:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, herbert@gondor.apana.org.au


The patch titled
     crypto: switch to proc_create()
has been added to the -mm tree.  Its filename is
     crypto-switch-to-proc_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

proc-print-more-information-when-removing-non-empty-directories.patch
single_open-seq_release-leak-diagnostics.patch
proc-switch-to-proc_create.patch
keys-switch-to-proc_create.patch
crypto-switch-to-proc_create.patch

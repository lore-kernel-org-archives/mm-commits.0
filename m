From: akpm@linux-foundation.org
Subject: + make-crypto-api-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:42 -0700
Message-ID: <200705181737.l4IHbgB8019857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:51875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbXERRnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, herbert@gondor.apana.org.au, xemul@openvz.org


The patch titled
     Make crypto API use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-crypto-api-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make crypto API use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid - just use the same code from another place in the kernel.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/proc.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff -puN crypto/proc.c~make-crypto-api-use-seq_list_xxx-helpers crypto/proc.c
--- a/crypto/proc.c~make-crypto-api-use-seq_list_xxx-helpers
+++ a/crypto/proc.c
@@ -23,24 +23,13 @@
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *v;
-	loff_t n = *pos;
-
 	down_read(&crypto_alg_sem);
-	list_for_each(v, &crypto_alg_list)
-		if (!n--)
-			return list_entry(v, struct crypto_alg, cra_list);
-	return NULL;
+	return seq_list_start(&crypto_alg_list, *pos);
 }
 
 static void *c_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct list_head *v = p;
-	
-	(*pos)++;
-	v = v->next;
-	return (v == &crypto_alg_list) ?
-		NULL : list_entry(v, struct crypto_alg, cra_list);
+	return seq_list_next(p, &crypto_alg_list, pos);
 }
 
 static void c_stop(struct seq_file *m, void *p)
@@ -50,7 +39,7 @@ static void c_stop(struct seq_file *m, v
 
 static int c_show(struct seq_file *m, void *p)
 {
-	struct crypto_alg *alg = (struct crypto_alg *)p;
+	struct crypto_alg *alg = list_entry(p, struct crypto_alg, cra_list);
 	
 	seq_printf(m, "name         : %s\n", alg->cra_name);
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
_

Patches currently in -mm which might be from xemul@sw.ru are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch

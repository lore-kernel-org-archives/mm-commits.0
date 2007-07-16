From: akpm@linux-foundation.org
Subject: - make-crypto-api-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:39 -0700
Message-ID: <200707162053.l6GKrdoT001664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759474AbXGPVeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, herbert@gondor.apana.org.au, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make crypto API use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-crypto-api-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make crypto API use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid - just use the same code from another place in the kernel.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/proc.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

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

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch

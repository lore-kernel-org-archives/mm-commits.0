From: akpm@linux-foundation.org
Subject: + crypto-fix.patch added to -mm tree
Date: Tue, 08 May 2007 16:29:05 -0700
Message-ID: <200705082329.l48NT55Z004718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969283AbXEHXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     Subject: Re: 2.6.21-mm1+hotfix -- Slab corruption -- Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
has been added to the -mm tree.  Its filename is
     crypto-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: Re: 2.6.21-mm1+hotfix -- Slab corruption -- Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
From: Herbert Xu <herbert@gondor.apana.org.au>

On Mon, May 07, 2007 at 11:57:28AM -0700, Miles Lane wrote:
> [  118.442018] ieee80211_crypt: registered algorithm 'WEP'
> [  118.514572] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [  118.514664] Slab corruption: size-256 start=c6aabe98, len=256
> [  118.514672] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [  118.514676] Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
> [  118.514692] 000: 10 55 ac c6 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [  118.514715] Prev obj: start=c6aabd80, len=256
> [  118.514721] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [  118.514725] Last user: [<c01afd85>](crypto_alloc_instance+0x1d/0xc0)
> [  118.514734] 000: e0 71 39 c0 80 6e 39 c0 88 bd aa c6 88 bd aa c6
> [  118.514753] 010: 04 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00

Oops.  Does this patch fix the problem for you?

Thanks,
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
index 6958ea8..e5fb7cc 100644

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/cryptomgr.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN crypto/cryptomgr.c~crypto-fix crypto/cryptomgr.c
--- a/crypto/cryptomgr.c~crypto-fix
+++ a/crypto/cryptomgr.c
@@ -24,8 +24,6 @@
 #include "internal.h"
 
 struct cryptomgr_param {
-	struct task_struct *thread;
-
 	struct rtattr *tb[CRYPTOA_MAX];
 
 	struct {
@@ -81,6 +79,7 @@ err:
 
 static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 {
+	struct task_struct *thread;
 	struct cryptomgr_param *param;
 	const char *name = larval->alg.cra_name;
 	const char *p;
@@ -130,8 +129,8 @@ static int cryptomgr_schedule_probe(stru
 
 	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
-	if (IS_ERR(param->thread))
+	thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
+	if (IS_ERR(thread))
 		goto err_free_param;
 
 	return NOTIFY_STOP;
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-wireless.patch
crypto-fix.patch
use-menuconfig-objects-crypto.patch

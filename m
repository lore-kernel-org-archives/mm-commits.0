From: akpm@linux-foundation.org
Subject: [merged] crypto-sanitize-argument-for-format-string.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:47 -0700
Message-ID: <51db11c3.fb4lxMV9vu4gVyZm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GHTXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, keescook@chromium.org

Subject: [merged] crypto-sanitize-argument-for-format-string.patch removed from -mm tree
To: keescook@chromium.org,davem@davemloft.net,herbert@gondor.apana.org.au,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:47 -0700


The patch titled
     Subject: crypto: sanitize argument for format string
has been removed from the -mm tree.  Its filename was
     crypto-sanitize-argument-for-format-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: crypto: sanitize argument for format string

The template lookup interface does not provide a way to use format
strings, so make sure that the interface cannot be abused accidentally.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/algapi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN crypto/algapi.c~crypto-sanitize-argument-for-format-string crypto/algapi.c
--- a/crypto/algapi.c~crypto-sanitize-argument-for-format-string
+++ a/crypto/algapi.c
@@ -495,7 +495,8 @@ static struct crypto_template *__crypto_
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
isdn-clean-up-debug-format-string-usage.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch


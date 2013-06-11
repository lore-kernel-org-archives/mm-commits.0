From: akpm@linux-foundation.org
Subject: + crypto-sanitize-argument-for-format-string.patch added to -mm
 tree
Date: Tue, 11 Jun 2013 13:11:51 -0700
Message-ID: <51b78487.odw8zUwdnRsA2pCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3FKULw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, keescook@chromium.org

Subject: + crypto-sanitize-argument-for-format-string.patch added to -mm tree
To: keescook@chromium.org,davem@davemloft.net,herbert@gondor.apana.org.au,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:11:51 -0700


The patch titled
     Subject: crypto: sanitize argument for format string
has been added to the -mm tree.  Its filename is
     crypto-sanitize-argument-for-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
block-do-not-pass-disk-names-as-format-strings.patch
crypto-sanitize-argument-for-format-string.patch
drivers-avoid-format-string-in-dev_set_name.patch
drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch
drivers-avoid-parsing-names-as-kthread_run-format-strings.patch
isdn-clean-up-debug-format-string-usage.patch


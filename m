From: akpm@linux-foundation.org
Subject: +
 arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
 added to -mm tree
Date: Mon, 23 Jun 2014 16:29:46 -0700
Message-ID: <53a8b86a.E2rrJQ9X6oFOR8qD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFWX3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kstrto*
has been added to the -mm tree.  Its filename is
     arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kstrto*

Replace obsolete strict_strto call with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c24xx/mach-jive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-s3c24xx/mach-jive.c~arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto arch/arm/mach-s3c24xx/mach-jive.c
--- a/arch/arm/mach-s3c24xx/mach-jive.c~arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto
+++ a/arch/arm/mach-s3c24xx/mach-jive.c
@@ -243,7 +243,7 @@ static int __init jive_mtdset(char *opti
 	if (options == NULL || options[0] == '\0')
 		return 0;
 
-	if (strict_strtoul(options, 10, &set)) {
+	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
 		return 0;
 	}
_

Patches currently in -mm which might be from dwalter@google.com are

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch


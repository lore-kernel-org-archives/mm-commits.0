From: akpm@linux-foundation.org
Subject: + arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
 added to -mm tree
Date: Mon, 23 Jun 2014 16:29:45 -0700
Message-ID: <53a8b869./yq57j6ExDTbWKv/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFWX3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, eric.y.miao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-pxa: replace strict_strto call with kstrto
has been added to the -mm tree.  Its filename is
     arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch

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
Subject: arch/arm/mach-pxa: replace strict_strto call with kstrto

Replace obsolete call to strict_strto with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/balloon3.c |    2 +-
 arch/arm/mach-pxa/viper.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-pxa/balloon3.c~arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto arch/arm/mach-pxa/balloon3.c
--- a/arch/arm/mach-pxa/balloon3.c~arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto
+++ a/arch/arm/mach-pxa/balloon3.c
@@ -90,7 +90,7 @@ int __init parse_balloon3_features(char
 	if (!arg)
 		return 0;
 
-	return strict_strtoul(arg, 0, &balloon3_features_present);
+	return kstrtoul(arg, 0, &balloon3_features_present);
 }
 early_param("balloon3_features", parse_balloon3_features);
 
diff -puN arch/arm/mach-pxa/viper.c~arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto arch/arm/mach-pxa/viper.c
--- a/arch/arm/mach-pxa/viper.c~arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto
+++ a/arch/arm/mach-pxa/viper.c
@@ -769,7 +769,7 @@ static unsigned long viper_tpm;
 
 static int __init viper_tpm_setup(char *str)
 {
-	return strict_strtoul(str, 10, &viper_tpm) >= 0;
+	return kstrtoul(str, 10, &viper_tpm) >= 0;
 }
 
 __setup("tpm=", viper_tpm_setup);
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


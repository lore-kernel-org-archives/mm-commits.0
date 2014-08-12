From: akpm@linux-foundation.org
Subject: [merged]
 arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:42:04 -0700
Message-ID: <53ea6e0c.7ZJ3uBaqJkfODruh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:61165 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:05 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1069891igd.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, eric.y.miao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-pxa: replace strict_strto call with kstrto
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch


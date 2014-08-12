From: akpm@linux-foundation.org
Subject: [merged]
 arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:06 -0700
Message-ID: <53ea6e0e.9Y8aLKDyMmmtPda6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59252 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:07 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1307952qap.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kstrto*
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch


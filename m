From: akpm@linux-foundation.org
Subject: + arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
 added to -mm tree
Date: Mon, 23 Jun 2014 16:29:47 -0700
Message-ID: <53a8b86b.qWPdOrXnKdzM8CEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFWX3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, mcuos.com@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto
has been added to the -mm tree.  Its filename is
     arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch

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
Subject: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto

Replace obsolete strict_strto with kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-w90x900/cpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-w90x900/cpu.c~arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto arch/arm/mach-w90x900/cpu.c
--- a/arch/arm/mach-w90x900/cpu.c~arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto
+++ a/arch/arm/mach-w90x900/cpu.c
@@ -178,7 +178,8 @@ static int __init nuc900_set_cpufreq(cha
 	if (!*str)
 		return 0;
 
-	strict_strtoul(str, 0, &cpufreq);
+	if (kstrtoul(str, 0, &cpufreq))
+		return 0;
 
 	nuc900_clock_source(NULL, "ext");
 
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


From: akpm@linux-foundation.org
Subject: [merged]
 arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:08 -0700
Message-ID: <53ea6e10.ndQc0OZ/wgfSOiE6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64298 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:09 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1310013qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, mcuos.com@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch


From: akpm@osdl.org
Subject: + acpi-temp_fix_for_proximity_domain.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:13:23 -0800
Message-ID: <200702030113.l131DNWD022916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933403AbXBCBOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:14:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey.y.starikovskiy@linux.intel.com, bob.picco@hp.com, lenb@kernel.org


The patch titled
     acpi: temp fix for proximity domain
has been added to the -mm tree.  Its filename is
     acpi-temp_fix_for_proximity_domain.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: temp fix for proximity domain
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

Proximity domain just became u32 what makes HP to break... Mask the
extended range for now.

Cc: Bob Picco <bob.picco@hp.com>
CC: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~acpi-temp_fix_for_proximity_domain arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~acpi-temp_fix_for_proximity_domain
+++ a/arch/ia64/kernel/acpi.c
@@ -422,8 +422,8 @@ static int get_memory_proximity_domain(s
 	int pxm;
 
 	pxm = ma->proximity_domain;
-	if (ia64_platform_is("sn2"))
-		pxm += ma->reserved << 8;
+	if (!ia64_platform_is("sn2"))
+		pxm &= 0xff;
 
 	return pxm;
 }
_

Patches currently in -mm which might be from alexey.y.starikovskiy@linux.intel.com are

git-acpi.patch
acpi-fix-tbfadt.patch
acpi-temp_fix_for_proximity_domain.patch
swsusp-change-code-order-in-diskc-fix.patch

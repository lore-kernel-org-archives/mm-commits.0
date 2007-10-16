From: akpm@linux-foundation.org
Subject: - x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 20:56:22 -0700
Message-ID: <200710160356.l9G3uM9J007537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758652AbXJPD4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 23:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: convert-cpuinfo_x86-array-to-a-per_cpu-array fix
has been removed from the -mm tree.  Its filename was
     x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix.patch

This patch was dropped because it was folded into x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch

------------------------------------------------------
Subject: x86: convert-cpuinfo_x86-array-to-a-per_cpu-array fix
From: Mike Travis <travis@sgi.com>

This fix corrects the problem that early_identify_cpu() sets cpu_index to
'0' (needed when called by setup_arch) after smp_store_cpu_info() had set
it to the correct value.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/smpboot_64.c~x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix
+++ a/arch/x86/kernel/smpboot_64.c
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 
_

Patches currently in -mm which might be from travis@sgi.com are

x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix.patch

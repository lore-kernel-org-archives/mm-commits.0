From: akpm@linux-foundation.org
Subject: + ia64-improper-printk-format-in-acpi-cpufreq.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:23:54 -0700
Message-ID: <200807162023.m6GKNsnF011251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYGPUX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, tony.luck@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     ia64: improper printk format in acpi-cpufreq
has been added to the -mm tree.  Its filename is
     ia64-improper-printk-format-in-acpi-cpufreq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: improper printk format in acpi-cpufreq
From: "Denis V. Lunev" <den@openvz.org>

When dprintk is enabled the following warnings are generated:
arch/ia64/kernel/cpufreq/acpi-cpufreq.c: In function 'processor_set_pstate':
arch/ia64/kernel/cpufreq/acpi-cpufreq.c:54: warning: format '%x' expects type 'unsigned int', but argument 3 has type 's64'
arch/ia64/kernel/cpufreq/acpi-cpufreq.c: In function 'processor_get_pstate':
arch/ia64/kernel/cpufreq/acpi-cpufreq.c:76: warning: format '%x' expects type 'unsigned int', but argument 2 has type 's64'

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/cpufreq/acpi-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/cpufreq/acpi-cpufreq.c~ia64-improper-printk-format-in-acpi-cpufreq arch/ia64/kernel/cpufreq/acpi-cpufreq.c
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c~ia64-improper-printk-format-in-acpi-cpufreq
+++ a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -51,7 +51,7 @@ processor_set_pstate (
 	retval = ia64_pal_set_pstate((u64)value);
 
 	if (retval) {
-		dprintk("Failed to set freq to 0x%x, with error 0x%x\n",
+		dprintk("Failed to set freq to 0x%x, with error 0x%lx\n",
 		        value, retval);
 		return -ENODEV;
 	}
@@ -74,7 +74,7 @@ processor_get_pstate (
 
 	if (retval)
 		dprintk("Failed to get current freq with "
-		        "error 0x%x, idx 0x%x\n", retval, *value);
+		        "error 0x%lx, idx 0x%x\n", retval, *value);
 
 	return (int)retval;
 }
_

Patches currently in -mm which might be from den@openvz.org are

linux-next.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
ia64-improper-printk-format-in-acpi-cpufreq.patch


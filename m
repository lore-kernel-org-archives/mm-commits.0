From: akpm@linux-foundation.org
Subject: + proc-maps-protection-fix-3.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:22:52 -0700
Message-ID: <200703212222.l2LMMqe0005365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbXCUWXI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees@outflux.net


The patch titled
     proc-maps-protection-fix 3
has been added to the -mm tree.  Its filename is
     proc-maps-protection-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc-maps-protection-fix 3
From: Kees Cook <kees@outflux.net>

Signed-off-by: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/sysctl.c~proc-maps-protection-fix-3 kernel/sysctl.c
--- a/kernel/sysctl.c~proc-maps-protection-fix-3
+++ a/kernel/sysctl.c
@@ -604,6 +604,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "maps_protect",
@@ -612,6 +613,7 @@ static ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &proc_dointvec,
 	},
+#endif
 
 	{ .ctl_name = 0 }
 };
_

Patches currently in -mm which might be from kees@outflux.net are

proc-maps-protection.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
proc-maps-protection-fix-3.patch
proc-maps-protection-vs-utrace.patch

From: akpm@linux-foundation.org
Subject: - proc-maps-protection-fix-3.patch removed from -mm tree
Date: Tue, 24 Apr 2007 03:14:58 -0700
Message-ID: <200704241014.l3OAEwoZ006085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbXDXKPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 06:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@outflux.net, mm-commits@vger.kernel.org


The patch titled
     proc-maps-protection-fix 3
has been removed from the -mm tree.  Its filename was
     proc-maps-protection-fix-3.patch

This patch was dropped because it was folded into proc-maps-protection.patch

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
proc-maps-protection-fix-3.patch

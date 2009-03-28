From: akpm@linux-foundation.org
Subject: + sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch added to -mm tree
Date: Sat, 28 Mar 2009 12:26:19 -0700
Message-ID: <200903281926.n2SJQJvi029984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbZC1Tbd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Mar 2009 15:31:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, adobriyan@gmail.com, hidehiro.kawai.ez@hitachi.com, kernelbt@arbruijn.dds.nl, stable@kernel.org


The patch titled
     sysctl: fix suid_dumpable and lease-break-time sysctls
has been added to the -mm tree.  Its filename is
     sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: fix suid_dumpable and lease-break-time sysctls
From: Matthew Wilcox <matthew@wil.cx>

Arne de Bruijn points out that commit
76fdbb25f963de5dc1e308325f0578a2f92b1c2d ("coredump masking: bound
suid_dumpable sysctl") mistakenly limits lease-break-time instead of
suid_dumpable.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Reported-by: Arne de Bruijn <kernelbt@arbruijn.dds.nl>
Cc: Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/sysctl.c~sysctl-fix-suid_dumpable-and-lease-break-time-sysctls kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-suid_dumpable-and-lease-break-time-sysctls
+++ a/kernel/sysctl.c
@@ -95,12 +95,9 @@ static int sixty = 60;
 static int neg_one = -1;
 #endif
 
-#if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
-static int two = 2;
-#endif
-
 static int zero;
 static int one = 1;
+static int two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
@@ -1373,10 +1370,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &lease_break_time,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
-		.extra2		= &two,
+		.proc_handler	= &proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_AIO
@@ -1417,7 +1411,10 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
linux-next.patch
pcie-portdrv-eliminate-double-kfree-in-remove-path.patch
scsi-ncr53c8xx-div-reaches-1.patch
rtc-parisc-add-a-missing-include-for-linux-rtch.patch
rtc-parisc-remove-redundant-locking.patch
rtc-parisc-remove-struct-parisc_rtc.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
rtc-parisc-use-platform_driver_probe.patch
rtc-parisc-declare-rtc_parisc_dev-as-static.patch
rtc-parisc-remove-unnecessary-ret-variable.patch
rtc-parisc-remove-a-couple-unnecessary-variables.patch
rtc-parisc-rename-p-pointer-to-rtc.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
make-sure-nobodys-leaking-resources.patch


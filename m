Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D5F299920
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221993; cv=none; b=dRg05CEG1BSSoaw/pN8BurG3dqurtvo0Gi8Ay6GnXAYtx4waZPUjv7XW8EXOMRtIrchfdZvZTL7Wd1o3h/c6XMP0IymBwx6fyQxWuH8Rt3Me3CY8//dyi6gIRB9w+358w4qqDMeIu4LdBsZ0CcZbL411zv3aHt2eOFb16dzUvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221993; c=relaxed/simple;
	bh=Cmojlp/Oe62uAjpdKM8A9H9A8YEKtq3XRRKHghJf+Vk=;
	h=Date:To:From:Subject:Message-Id; b=BV/Ym18z2qhIU0b0o3FTcN2b/uds5JElef3HSGtcIEfCfzxaeUzdzMmFP2PowTXXQg3m919WPgGVQ7ndhqEKz2K/15sJd3VzpSk4NHY/bzjUY+B9fz++034/crnfuyxchJbtELwxKMBE6xbgm8h2Vz/r3uolB6600MhVyzz+sXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=grWqsdIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="grWqsdIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0911E1F000E9;
	Tue,  1 Sep 2026 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788221991;
	bh=gd7rO1Cfuc3m4tCsUcM2eTijP5zkogBy93DFBEv7isI=;
	h=Date:To:From:Subject;
	b=grWqsdImovI4YaFW+Xp+Ynv2Jf2ZqKCMSEtpg30ZFsO11VNvV/O/t2UttUyFpCZ1m
	 XAkw5DyVPi/Sr5/hAIgAwMrTE88KXaTWCDrXOAgI1C1Fyuu51xH6zbj/YVIoM2c92k
	 2wERMbYeS6g3t/DvOEu8m3lDqBiX0zYibpN4jVN8=
Date: Mon, 31 Aug 2026 17:19:50 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,pmladek@suse.com,include@grrlz.net,hca@linux.ibm.com,gor@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,meted@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-implement-arch_do_panic.patch added to mm-nonmm-unstable branch
Message-Id: <20260901001951.0911E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc: implement arch_do_panic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sparc-implement-arch_do_panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-implement-arch_do_panic.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mete Durlu <meted@linux.ibm.com>
Subject: sparc: implement arch_do_panic
Date: Mon, 31 Aug 2026 11:57:17 +0200

Implement sparc specific arch_do_panic() instead of using sparc specific
ifdef sections in vpanic() code.  Reorder arch specific panic handling,
sparc's Stop-A messages are now printed after "end Kernel panic" marker.

Link: https://lore.kernel.org/20260831-arch_do_panic-v6-3-a1e170a9e7fd@linux.ibm.com
Signed-off-by: Mete Durlu <meted@linux.ibm.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/setup.c |    9 +++++++++
 kernel/panic.c            |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/sparc/kernel/setup.c~sparc-implement-arch_do_panic
+++ a/arch/sparc/kernel/setup.c
@@ -2,6 +2,8 @@
 
 #include <asm/setup.h>
 #include <linux/sysctl.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
 
 static const struct ctl_table sparc_sysctl_table[] = {
 	{
@@ -36,6 +38,13 @@ static const struct ctl_table sparc_sysc
 #endif
 };
 
+void arch_do_panic(void)
+{
+	/* Make sure the user can actually press Stop-A (L1-A) */
+	stop_a_enabled = 1;
+	pr_emerg("Press Stop-A (L1-A) from sun keyboard or send break\n"
+		 "twice on console to return to the boot prom\n");
+}
 
 static int __init init_sparc_sysctls(void)
 {
--- a/kernel/panic.c~sparc-implement-arch_do_panic
+++ a/kernel/panic.c
@@ -744,15 +744,6 @@ void vpanic(const char *fmt, va_list arg
 			reboot_mode = panic_reboot_mode;
 		emergency_restart();
 	}
-#ifdef __sparc__
-	{
-		extern int stop_a_enabled;
-		/* Make sure the user can actually press Stop-A (L1-A) */
-		stop_a_enabled = 1;
-		pr_emerg("Press Stop-A (L1-A) from sun keyboard or send break\n"
-			 "twice on console to return to the boot prom\n");
-	}
-#endif
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
 	arch_do_panic();
_

Patches currently in -mm which might be from meted@linux.ibm.com are

panic-introduce-arch_do_panic.patch
s390-implement-arch_do_panic.patch
sparc-implement-arch_do_panic.patch


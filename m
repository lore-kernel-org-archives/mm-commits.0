Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B935201B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338674; cv=none; b=T/ou8+1FrRl2gD/d78deQlCS1J5UaY5ATktcAdX4Kb1ylVrG/TSNZvwbYLrBvC4lp6vXzLeW5dnize6YlUDZnUTm9Lt7kigLxuzVyFIqIlHOowZ65FtyI2Ownj+EXx7kWA+DGO9vBaPmxArWdqsO/tkTNxYayYa+jBip46AY3cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338674; c=relaxed/simple;
	bh=H30OD3eObuC7njnk2Pw/CJ/tkVd+IJb/bj1T0OS109o=;
	h=Date:To:From:Subject:Message-Id; b=B8P/tmrJQsdN4o6JSR7/Lt2xbppn/+wRXVL5+khfCvm4pefub8QrLHDRM59s39i9KACcRx1AyQhvva9TrJmUY6VmG10k/xoX1Cv422me5QIf6iRenSBuTJAQAtXU5msmYgOtYGGBpN/gyXh3VL32wH2XZqzgdehhbAcSJoI/Gis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S/saOvZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S/saOvZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097891F0089B;
	Wed,  7 Oct 2026 02:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338673;
	bh=P0nusMEDLAtaQnOm9UhyWzzuWB3sN6FNhKxhhEKu8/I=;
	h=Date:To:From:Subject;
	b=S/saOvZopija5TjD8fUtN0EuPvwARj6wYlLCBteunJyxQ9Ej/wjU0PkWYAL/WtZHz
	 sJzhNKCerNpGPHbZmYJ4kwbnGc049fjH7qVcJzThTieD2/kgiL8/oB5/TvSjcMA7fX
	 Gtlh+UjAPvf4V6pLViQhrhO5z4RqjvdruAjTxzC4=
Date: Tue, 06 Oct 2026 19:04:32 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,pmladek@suse.com,include@grrlz.net,hca@linux.ibm.com,gor@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,meted@linux.ibm.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sparc-implement-arch_do_panic.patch removed from -mm tree
Message-Id: <20261007020433.097891F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc: implement arch_do_panic
has been removed from the -mm tree.  Its filename was
     sparc-implement-arch_do_panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mete Durlu <meted@linux.ibm.com>
Subject: sparc: implement arch_do_panic
Date: Mon, 31 Aug 2026 11:57:17 +0200

Implement sparc specific arch_do_panic() instead of using sparc specific
ifdef sections in vpanic() code.  Reorder arch specific panic handling,
sparc's Stop-A messages are now printed after "end Kernel panic" marker.

Link: https://lore.kernel.org/20260831-arch_do_panic-v6-3-a1e170a9e7fd@linux.ibm.com
Signed-off-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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



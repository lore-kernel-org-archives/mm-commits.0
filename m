Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CECA9476
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739403; cv=none; b=lFp6BWAlzq5MreTQ40SYDwgN73NxsSqNKJghiNoWkpG5FHKCtssSzyJNWbNiXNefoHxCZ0dbmJBiYl4J6nI1dn6IKljUXdrewmds2o8AZ8lS8zyc7ZI3RU3zxUyB44PFH1XqTeeoVyjgI2Ar81FzJN+Oq1K61nK0HNghdd3/kH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739403; c=relaxed/simple;
	bh=BHEuBa7duRygf7e/DvzijtnCqFfcBhhhIZ+QYCwkgCU=;
	h=Date:To:From:Subject:Message-Id; b=iQfXykCE/JbB3YOb/d3QuzvIr9osPCJkpKN0BisgfV1YnYwps9vnSYHHPaQcQkbH/TFQAl/3sbq92BQDTG35lLg+9oMz52lRoMvICTuHOh5328lmXeAu1f9gmAjkYgGOeflTWmqOYKUzbrx/qs8MEw2ML6jRsuMXqnBumA7Zm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQhz1zyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQhz1zyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34E8C433F1;
	Sat, 24 Feb 2024 01:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739403;
	bh=BHEuBa7duRygf7e/DvzijtnCqFfcBhhhIZ+QYCwkgCU=;
	h=Date:To:From:Subject:From;
	b=AQhz1zyIBPxnUyPsQFiuvtab2joqX6qxqeY6HtaEVgtX89T8th2hIo7xi/hDqKM7h
	 WmAhiSfY7UdeBdnOgb/+8bTCdBCWON6K4RDqff42wO2MPooCNsOfX6e+D06qoFxpgY
	 OPy5EscPSeXdlNCc4pwN5VgbQXHHZvllCItGP4hQ=
Date: Fri, 23 Feb 2024 17:50:02 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015002.E34E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mips, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:51 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on mips with some adjustments.

Here use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-12-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/setup.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/mips/kernel/setup.c~mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/mips/kernel/setup.c
@@ -442,8 +442,6 @@ static void __init mips_reserve_vmcore(v
 #endif
 }
 
-#ifdef CONFIG_KEXEC
-
 /* 64M alignment for crash kernel regions */
 #define CRASH_ALIGN	SZ_64M
 #define CRASH_ADDR_MAX	SZ_512M
@@ -454,6 +452,9 @@ static void __init mips_parse_crashkerne
 	unsigned long long crash_size, crash_base;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	total_mem = memblock_phys_mem_size();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base,
@@ -489,6 +490,9 @@ static void __init request_crashkernel(s
 {
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	if (crashk_res.start == crashk_res.end)
 		return;
 
@@ -498,15 +502,6 @@ static void __init request_crashkernel(s
 			(unsigned long)(resource_size(&crashk_res) >> 20),
 			(unsigned long)(crashk_res.start  >> 20));
 }
-#else /* !defined(CONFIG_KEXEC)		*/
-static void __init mips_parse_crashkernel(void)
-{
-}
-
-static void __init request_crashkernel(struct resource *res)
-{
-}
-#endif /* !defined(CONFIG_KEXEC)  */
 
 static void __init check_kernel_sections_mem(void)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are



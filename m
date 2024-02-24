Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8739A6FB0
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739392; cv=none; b=gUNMZu/3TKwVfaI2TF124csECkN8c03QEt0jD7DLlA5kztJ/NuB+BZGEniRAuuuMLBQj5bG6zw/ouNh/tX9FkXOYgedCizQtc/TnQi9dy50+RzwkYa1NjT85RPKAusaR6OjmyY6aDJ2FTCwMbJY5xRG+mlVJPvNvowEQxBT8+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739392; c=relaxed/simple;
	bh=0Y01yN9128T6lXfG3bD92CMawrItlsAHyM3wEy9Nwhc=;
	h=Date:To:From:Subject:Message-Id; b=BJkP1oCmKTACygWdBiMdjdoSXPQd++M/032f4PchYFtwiPm0yrgFSUmE2RzJapSO9JJWcoFOx1oiRq53rOQ5az++vJXqdRAZMxykh5tEOmZ9mrMqfwJ4kLIVJDRJah6j6cJtV0OHjHuY+k3czDOIio46orYYyVvNB8jV44U6Zyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZ5T/+HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZ5T/+HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE9C43399;
	Sat, 24 Feb 2024 01:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739392;
	bh=0Y01yN9128T6lXfG3bD92CMawrItlsAHyM3wEy9Nwhc=;
	h=Date:To:From:Subject:From;
	b=xZ5T/+HRMxRtsYxL6Fc9A8dDTJdMO5I6MUXiqlPHEDC5kluP1hEDj7mIuXGq+34Zt
	 MVSt1D6+4n23nG3NXagrZ9n2Ys0d1ltC1GdziPeYFUKcRI0c/yCjmN4SRW721qi+iA
	 HnCY2xizu2W6gbN6SQHDJdnv4PC8P6MtRfam5H8A=
Date: Fri, 23 Feb 2024 17:49:51 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] crash-clean-up-kdump-related-config-items.patch removed from -mm tree
Message-Id: <20240224014952.5BBE9C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: clean up kdump related config items
has been removed from the -mm tree.  Its filename was
     crash-clean-up-kdump-related-config-items.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash: clean up kdump related config items
Date: Wed, 24 Jan 2024 13:12:45 +0800

By splitting CRASH_RESERVE and VMCORE_INFO out from CRASH_CORE, cleaning
up the dependency of FA_DMUMP on CRASH_DUMP, and moving crash codes from
kexec_core.c to crash_core.c, now we can rearrange CRASH_DUMP to
depend on KEXEC_CORE, and make CRASH_DUMP select CRASH_RESERVE and
VMCORE_INFO.

KEXEC_CORE won't select CRASH_RESERVE and VMCORE_INFO any more because
KEXEC_CORE enables codes which allocate control pages, copy
kexec/kdump segments, and prepare for switching. These codes are shared
by both kexec reboot and crash dumping.

Doing this makes codes and the corresponding config items more
logical (the right item depends on or is selected by the left item).

PROC_KCORE -----------> VMCORE_INFO

           |----------> VMCORE_INFO
FA_DUMP----|
           |----------> CRASH_RESERVE

                                                ---->VMCORE_INFO
                                               /
                                               |---->CRASH_RESERVE
KEXEC      --|                                /|
             |--> KEXEC_CORE--> CRASH_DUMP-->/-|---->PROC_VMCORE
KEXEC_FILE --|                               \ |
                                               \---->CRASH_HOTPLUG

KEXEC      --|
             |--> KEXEC_CORE--> kexec reboot
KEXEC_FILE --|

Link: https://lkml.kernel.org/r/20240124051254.67105-6-bhe@redhat.com
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

 kernel/Kconfig.kexec |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/Kconfig.kexec~crash-clean-up-kdump-related-config-items
+++ a/kernel/Kconfig.kexec
@@ -9,8 +9,6 @@ config VMCORE_INFO
 	bool
 
 config KEXEC_CORE
-	select VMCORE_INFO
-	select CRASH_RESERVE
 	bool
 
 config KEXEC_ELF
@@ -99,8 +97,11 @@ config KEXEC_JUMP
 
 config CRASH_DUMP
 	bool "kernel crash dumps"
+	default y
 	depends on ARCH_SUPPORTS_CRASH_DUMP
-	select KEXEC_CORE
+	depends on KEXEC_CORE
+	select VMCORE_INFO
+	select CRASH_RESERVE
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
_

Patches currently in -mm which might be from bhe@redhat.com are



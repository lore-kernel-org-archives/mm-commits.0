Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EA213AA58
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970651; cv=none; b=AevjIcWj6wl5aZUZTW+b3fjAy01vQlorUga9Yk9che4pkfMcA/x+0k0RuVF4DVO0pdMydjtRdUK9NRsBBbZCmK1RJ4O6YUp+kipKOLnmwUN+etMu6IPJUP6QKvnHfu+lqLav2zdrSVpmgwck2AVR9lkklKBGLatddxk2GnATon8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970651; c=relaxed/simple;
	bh=8D1M8kHvMDPEZQ2RFz46vPcAVK4p/MgZUM9Hrnf0Xnk=;
	h=Date:To:From:Subject:Message-Id; b=dHnpPiye0rlSk9O6FXf0gi2ZvMyPQVQNvsGHrJ4JQn4VjCqQlbb/4UqLUL1jvIXGsvbbsVBhwuEqdWQnH2FRq34c8SMlgSj35ptxnZ457Z49xZN6L0NDG1i6foqYYbpw6hE8r1bDCtaGBAFDNbd3dMEbPC/tIbZ0V3wz9YMDFsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aCBYDKlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aCBYDKlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45D6C433C7;
	Tue, 23 Jan 2024 00:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970651;
	bh=8D1M8kHvMDPEZQ2RFz46vPcAVK4p/MgZUM9Hrnf0Xnk=;
	h=Date:To:From:Subject:From;
	b=aCBYDKlclglNYjxN2EWgZV3BLyXBLa47CxrJOrlx2l7RReBHHUePOG1wdzDfBWQoj
	 hB1Wtvcc/rQ5A+MMqr6SBgNVVkmhGGbvPEaAueGKHYk4bWunJAq+6p03zFMTUzMcTB
	 39PwNjUoAhdfcI205elEVid4H6Y3ahSMa276Gjuw=
Date: Mon, 22 Jan 2024 16:44:08 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-clean-up-kdump-related-config-items.patch added to mm-unstable branch
Message-Id: <20240123004410.A45D6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: clean up kdump related config items
has been added to the -mm mm-unstable branch.  Its filename is
     crash-clean-up-kdump-related-config-items.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-clean-up-kdump-related-config-items.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash: clean up kdump related config items
Date: Fri, 19 Jan 2024 22:52:32 +0800

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

Link: https://lkml.kernel.org/r/20240119145241.769622-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
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

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch


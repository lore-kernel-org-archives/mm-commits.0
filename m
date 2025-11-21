Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1033F8DE
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744994; cv=none; b=UnBPW3EAwi9g9Ob7PqEYCQa2OctEbHB+UEc5mahJL9UsZo+h3dlDRJaDFM19slpX9yyI0MfoV5MIV7v9ZtjPLKsz48Vfx4FB1bSw5op04rdtnTSKut6kbLCLOnFO+8NEpQQU/C8bBsY22Smtq08H2nKcAUrQ+iMeWbn+1LEymLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744994; c=relaxed/simple;
	bh=c+hkpzzksARlKZ59AfZJ9KbTMoqA7RXr5TAMuYE0+BU=;
	h=Date:To:From:Subject:Message-Id; b=IrMQYKscPSMFOW5YDDWgJq5iaBp/COJOlmxVWqA7m925Laqy6ZAEJlN/KQo7Z//Oyov5qDykBU/T/ziNRF5DCUfm93bJWprdTFurfKPT3xVQT0DOXJrV9E3b8U9JndxdtoEiicdEEcQRYOj/ZbC2tXH7JOVfM76531kMctYWBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbtzPJwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbtzPJwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B6FC4CEF1;
	Fri, 21 Nov 2025 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763744994;
	bh=c+hkpzzksARlKZ59AfZJ9KbTMoqA7RXr5TAMuYE0+BU=;
	h=Date:To:From:Subject:From;
	b=kbtzPJwaPgRE8wzXJiOKC1O3MIOUm4FIvuXJhEB4cI/KOtwghJJlxnJ0x+RXiPXKE
	 bhbEAy//rw/E9qEs078U6UiOkyTwu4FCz0HC7+Dmula+H5fu1LA7vJaQUl//Rg5Wia
	 bQrSmTCf5viR8yPicZ40pTAtnppeoW/tk2Vq10Iw=
Date: Fri, 21 Nov 2025 09:09:53 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-abi-mark-old-kexec-sysfs-deprecated.patch added to mm-nonmm-unstable branch
Message-Id: <20251121170954.04B6FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/ABI: mark old kexec sysfs deprecated
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-abi-mark-old-kexec-sysfs-deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-abi-mark-old-kexec-sysfs-deprecated.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: Documentation/ABI: mark old kexec sysfs deprecated
Date: Tue, 18 Nov 2025 17:15:06 +0530

The previous commit ("kexec: move sysfs entries to /sys/kernel/kexec")
moved all existing kexec sysfs entries to a new location. The ABI
document is updated to include a note about the deprecation of the old
kexec sysfs entries.

The following kexec sysfs entries are deprecated:
- /sys/kernel/kexec_loaded
- /sys/kernel/kexec_crash_loaded
- /sys/kernel/kexec_crash_size
- /sys/kernel/crash_elfcorehdr_size
- /sys/kernel/kexec_crash_cma_ranges

Link: https://lkml.kernel.org/r/20251118114507.1769455-3-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Aditya Gupta <adityag@linux.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh J Salgaonkar <mahesh@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shivang Upadhyay <shivangu@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump |   71 ++++++++++
 Documentation/ABI/testing/sysfs-kernel-kexec-kdump  |   53 -------
 2 files changed, 71 insertions(+), 53 deletions(-)

diff --git a/Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump a/Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump
new file mode 100644
--- /dev/null
+++ a/Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump
@@ -0,0 +1,71 @@
+NOTE: all the ABIs listed in this file are deprecated and will be removed after 2028.
+
+Here are the alternative ABIs:
++------------------------------------+-----------------------------------------+
+| Deprecated                         | Alternative                             |
++------------------------------------+-----------------------------------------+
+| /sys/kernel/kexec_loaded           | /sys/kernel/kexec/loaded                |
++------------------------------------+-----------------------------------------+
+| /sys/kernel/kexec_crash_loaded     | /sys/kernel/kexec/crash_loaded          |
++------------------------------------+-----------------------------------------+
+| /sys/kernel/kexec_crash_size       | /sys/kernel/kexec/crash_size            |
++------------------------------------+-----------------------------------------+
+| /sys/kernel/crash_elfcorehdr_size  | /sys/kernel/kexec/crash_elfcorehdr_size |
++------------------------------------+-----------------------------------------+
+| /sys/kernel/kexec_crash_cma_ranges | /sys/kernel/kexec/crash_cma_ranges      |
++------------------------------------+-----------------------------------------+
+
+
+What:		/sys/kernel/kexec_loaded
+Date:		Jun 2006
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Indicates whether a new kernel image has been loaded
+		into memory using the kexec system call. It shows 1 if
+		a kexec image is present and ready to boot, or 0 if none
+		is loaded.
+User:		kexec tools, kdump service
+
+What:		/sys/kernel/kexec_crash_loaded
+Date:		Jun 2006
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Indicates whether a crash (kdump) kernel is currently
+		loaded into memory. It shows 1 if a crash kernel has been
+		successfully loaded for panic handling, or 0 if no crash
+		kernel is present.
+User:		Kexec tools, Kdump service
+
+What:		/sys/kernel/kexec_crash_size
+Date:		Dec 2009
+Contact:	kexec@lists.infradead.org
+Description:	read/write
+		Shows the amount of memory reserved for loading the crash
+		(kdump) kernel. It reports the size, in bytes, of the
+		crash kernel area defined by the crashkernel= parameter.
+		This interface also allows reducing the crashkernel
+		reservation by writing a smaller value, and the reclaimed
+		space is added back to the system RAM.
+User:		Kdump service
+
+What:		/sys/kernel/crash_elfcorehdr_size
+Date:		Aug 2023
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Indicates the preferred size of the memory buffer for the
+		ELF core header used by the crash (kdump) kernel. It defines
+		how much space is needed to hold metadata about the crashed
+		system, including CPU and memory information. This information
+		is used by the user space utility kexec to support updating the
+		in-kernel kdump image during hotplug operations.
+User:		Kexec tools
+
+What:		/sys/kernel/kexec_crash_cma_ranges
+Date:		Nov 2025
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Provides information about the memory ranges reserved from
+		the Contiguous Memory Allocator (CMA) area that are allocated
+		to the crash (kdump) kernel. It lists the start and end physical
+		addresses of CMA regions assigned for crashkernel use.
+User:		kdump service
diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
deleted file mode 100644
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+++ /dev/null
@@ -1,53 +0,0 @@
-What:		/sys/kernel/kexec_loaded
-Date:		Jun 2006
-Contact:	kexec@lists.infradead.org
-Description:	read only
-		Indicates whether a new kernel image has been loaded
-		into memory using the kexec system call. It shows 1 if
-		a kexec image is present and ready to boot, or 0 if none
-		is loaded.
-User:		kexec tools, kdump service
-
-What:		/sys/kernel/kexec_crash_loaded
-Date:		Jun 2006
-Contact:	kexec@lists.infradead.org
-Description:	read only
-		Indicates whether a crash (kdump) kernel is currently
-		loaded into memory. It shows 1 if a crash kernel has been
-		successfully loaded for panic handling, or 0 if no crash
-		kernel is present.
-User:		Kexec tools, Kdump service
-
-What:		/sys/kernel/kexec_crash_size
-Date:		Dec 2009
-Contact:	kexec@lists.infradead.org
-Description:	read/write
-		Shows the amount of memory reserved for loading the crash
-		(kdump) kernel. It reports the size, in bytes, of the
-		crash kernel area defined by the crashkernel= parameter.
-		This interface also allows reducing the crashkernel
-		reservation by writing a smaller value, and the reclaimed
-		space is added back to the system RAM.
-User:		Kdump service
-
-What:		/sys/kernel/crash_elfcorehdr_size
-Date:		Aug 2023
-Contact:	kexec@lists.infradead.org
-Description:	read only
-		Indicates the preferred size of the memory buffer for the
-		ELF core header used by the crash (kdump) kernel. It defines
-		how much space is needed to hold metadata about the crashed
-		system, including CPU and memory information. This information
-		is used by the user space utility kexec to support updating the
-		in-kernel kdump image during hotplug operations.
-User:		Kexec tools
-
-What:		/sys/kernel/kexec_crash_cma_ranges
-Date:		Nov 2025
-Contact:	kexec@lists.infradead.org
-Description:	read only
-		Provides information about the memory ranges reserved from
-		the Contiguous Memory Allocator (CMA) area that are allocated
-		to the crash (kdump) kernel. It lists the start and end physical
-		addresses of CMA regions assigned for crashkernel use.
-User:		kdump service
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-move-sysfs-entries-to-sys-kernel-kexec.patch
documentation-abi-mark-old-kexec-sysfs-deprecated.patch
documentation-abi-new-kexec-and-kdump-sysfs-interface.patch


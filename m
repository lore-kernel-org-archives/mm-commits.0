Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137233446AF
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744997; cv=none; b=h+AphNramjxC6BoVLqD5pAp0BgfRYUNbpTAjKS9ZgEFTak+u+KYud+FKI06pm9yXGz+BJX4njq5WM7SyLaRocNh7iRQ8JEENbbUNPku11FD1XfZcOMZyQC30j+tGB1pTV6kLsg1flX5vS3fTNX+4nVEgWJkuSmVoDrq0HR+Tt40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744997; c=relaxed/simple;
	bh=yu1HvhxzQ1+/Tz5fYgL1GRk3s8hrsEVQCGK4rfX49ls=;
	h=Date:To:From:Subject:Message-Id; b=YAcN+apD9jr4y1HTXVyEdZ8x0JGqia5X/3f/DXFOY/HAZBOR3D5GEmsuO3546c4IyoEB6XtM8hPHwvy2qV8bV7ygQbSI+E0X7ruGIGWKyzZzupr8fuv2r6z5CWxBvcNa9mEGNGPq9CyVHE0qbkBfjiPnpjNQPfvUUu0Vykyvcyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rXsyGY5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rXsyGY5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF72C4CEF1;
	Fri, 21 Nov 2025 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763744996;
	bh=yu1HvhxzQ1+/Tz5fYgL1GRk3s8hrsEVQCGK4rfX49ls=;
	h=Date:To:From:Subject:From;
	b=rXsyGY5ovjAgVjVFgyoPZisNblllLtE1XxcSPg5PMwaOrruxxV2AdOpHpkaWuMFc5
	 jvw5f8k0FvaPv/shYdz3qoUKWshCjeQJep96vyB+UZNow1E/dCtRoV/7sZpo11M473
	 06J7+uL1O/u1CVTUQjPikE2iiJ9x/TdwRdpLZGCY=
Date: Fri, 21 Nov 2025 09:09:55 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-abi-new-kexec-and-kdump-sysfs-interface.patch added to mm-nonmm-unstable branch
Message-Id: <20251121170956.8DF72C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/ABI: new kexec and kdump sysfs interface
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-abi-new-kexec-and-kdump-sysfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-abi-new-kexec-and-kdump-sysfs-interface.patch

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
Subject: Documentation/ABI: new kexec and kdump sysfs interface
Date: Tue, 18 Nov 2025 17:15:07 +0530

Add an ABI document for following kexec and kdump sysfs interface:

- /sys/kernel/kexec/loaded
- /sys/kernel/kexec/crash_loaded
- /sys/kernel/kexec/crash_size
- /sys/kernel/kexec/crash_elfcorehdr_size
- /sys/kernel/kexec/crash_cma_ranges

Link: https://lkml.kernel.org/r/20251118114507.1769455-4-sourabhjain@linux.ibm.com
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

 Documentation/ABI/testing/sysfs-kernel-kexec-kdump |   61 +++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
new file mode 100644
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -0,0 +1,61 @@
+What:		/sys/kernel/kexec/*
+Date:		Nov 2025
+Contact:	kexec@lists.infradead.org
+Description:
+		The /sys/kernel/kexec/* directory contains sysfs files
+		that provide information about the configuration status
+		of kexec and kdump.
+
+What:		/sys/kernel/kexec/loaded
+Date:		Nov 2025
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Indicates whether a new kernel image has been loaded
+		into memory using the kexec system call. It shows 1 if
+		a kexec image is present and ready to boot, or 0 if none
+		is loaded.
+User:		kexec tools, kdump service
+
+What:		/sys/kernel/kexec/crash_loaded
+Date:		Nov 2025
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Indicates whether a crash (kdump) kernel is currently
+		loaded into memory. It shows 1 if a crash kernel has been
+		successfully loaded for panic handling, or 0 if no crash
+		kernel is present.
+User:		Kexec tools, Kdump service
+
+What:		/sys/kernel/kexec/crash_size
+Date:		Nov 2025
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
+What:		/sys/kernel/kexec/crash_elfcorehdr_size
+Date:		Nov 2025
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
+What:		/sys/kernel/kexec/crash_cma_ranges
+Date:		Nov 2025
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Provides information about the memory ranges reserved from
+		the Contiguous Memory Allocator (CMA) area that are allocated
+		to the crash (kdump) kernel. It lists the start and end physical
+		addresses of CMA regions assigned for crashkernel use.
+User:		kdump service
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-move-sysfs-entries-to-sys-kernel-kexec.patch
documentation-abi-mark-old-kexec-sysfs-deprecated.patch
documentation-abi-new-kexec-and-kdump-sysfs-interface.patch


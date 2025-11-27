Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCAE32145E
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282434; cv=none; b=Vtu1eIpi2vrQNo5f5vhEKTeI/TW/uN7hn1EnWfFjBPdgXjsf6L2eByslMGVBMMxgL1gIdGBIRSE2Nwkpd7e4yxDMSridmwgiYHiVhjAsV73O3H3uFVe+X7SrWAcP/QmMPmpnTppKadUw0IYJ6zGEg/iBFbn/jrui+1u1O//S2NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282434; c=relaxed/simple;
	bh=7/H7li0RpoSWY0Ysal/KhnAqCBiOADljQL754eKg/BI=;
	h=Date:To:From:Subject:Message-Id; b=F2qC0PNZtjHGXsi9b7XgPqQs7TOX0JVK5ZLSuKITwgdeml8CF6wItz3fqZulH/2vW9Oz6iG+Z3vBanSr4UF+J4ERB9BefjwToYypA+PZfe6VWawwynPyZv6WbNZrVQpFMXlEJWF3ZFrdNIlAh557mKCfwQN8QbpKU0rWvTFWwvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=shyG5Bhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="shyG5Bhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B9DC4CEF8;
	Thu, 27 Nov 2025 22:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282434;
	bh=7/H7li0RpoSWY0Ysal/KhnAqCBiOADljQL754eKg/BI=;
	h=Date:To:From:Subject:From;
	b=shyG5Bhsuz7stuSt2xYn4debrH5uWah5K27+prBs5LSGCJzNzTEaDyJ5NtQQv7Ivl
	 owSbzOZAzvGsMyQOJUSqsqIjYRpnEl+m+VedHhu14FUJnbq+rhFohKBZmiPOn1kEwo
	 fbL9rTNvgYFT2JucEkWKk+IKkyLU91F87JxXKcq4=
Date: Thu, 27 Nov 2025 14:27:13 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-abi-new-kexec-and-kdump-sysfs-interface.patch removed from -mm tree
Message-Id: <20251127222714.45B9DC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/ABI: new kexec and kdump sysfs interface
has been removed from the -mm tree.  Its filename was
     documentation-abi-new-kexec-and-kdump-sysfs-interface.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



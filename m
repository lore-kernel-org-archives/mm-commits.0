Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34482D5A01
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401376; cv=none; b=Z6BKy9wMKVLT+9EsyZ3utuj4oBEfM8uuOMROAU+ZWggDQIjXUJQbHPdVsQKX+ZjLsJzcMWejmXEOcamZF2tGe8/3F90voZt9xaHYFafWUABIpySGxDNNSocFrj+HWaQos7U6pKgK8BjsZ0IW+yxorr1v3874tDg2glJs47GiGOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401376; c=relaxed/simple;
	bh=frNqQmJCfH9XWVBDsL8Lmm/lMIo5MwB+ikmgxEPVK9U=;
	h=Date:To:From:Subject:Message-Id; b=DViOKyZTbXGDWsnNbacKT73vOLT7zsGWaZCmlFa8l5BboAEZE2ZFgIfa9sTQlwtRkW6tSssgKplLanjc5hJZ8tQ8ceLuBQfQm1vkKnR/k4OaDqKznNKQy8n7dDsSL1Qtx+E69jQtf1mEDae0/vo2o/mwZSRoXOC1Qqu3DUJ7yQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l1qTbWHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l1qTbWHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBB9C113D0;
	Mon, 17 Nov 2025 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763401376;
	bh=frNqQmJCfH9XWVBDsL8Lmm/lMIo5MwB+ikmgxEPVK9U=;
	h=Date:To:From:Subject:From;
	b=l1qTbWHy6jG/damLJJXCBellSLTLVN3PJKwMJB10C9NKEKNfBj5jWs12mtrphdEs6
	 krkCjdib/VvCNxOmladaOysROVHQHub7gBqOR88pEFfKgjLPBbrX0AY6RuHFYMvHH7
	 Yf3iqXHdMewhosJH/tXqVwrLPyhRJoHClngt9lvI=
Date: Mon, 17 Nov 2025 09:42:54 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-abi-add-kexec-and-kdump-sysfs-interface.patch added to mm-nonmm-unstable branch
Message-Id: <20251117174256.0EBB9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/ABI: add kexec and kdump sysfs interface
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-abi-add-kexec-and-kdump-sysfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-abi-add-kexec-and-kdump-sysfs-interface.patch

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
Subject: Documentation/ABI: add kexec and kdump sysfs interface
Date: Mon, 17 Nov 2025 09:21:53 +0530

Add an ABI document for following kexec and kdump sysfs interface:
- /sys/kernel/kexec_loaded
- /sys/kernel/kexec_crash_loaded
- /sys/kernel/kexec_crash_size
- /sys/kernel/crash_elfcorehdr_size

Link: https://lkml.kernel.org/r/20251117035153.1199665-1-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Aditya Gupta <adityag@linux.ibm.com>
Cc: Baoquan he <bhe@redhat.com>
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

 Documentation/ABI/testing/sysfs-kernel-kexec-kdump |   43 +++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
new file mode 100644
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -0,0 +1,43 @@
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
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

documentation-abi-add-kexec-and-kdump-sysfs-interface.patch


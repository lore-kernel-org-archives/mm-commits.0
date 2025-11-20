Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B334BA22
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676296; cv=none; b=sSTFnYxOmW49FlEVu0iJ2rYltKboUR4TUC4A0JKcJMPxfVxn9qV3ucJYfcyKPpmI8b57SI7xDPKFxx7Yeld6bZcLnC/iz1eMCNFNkNzJZNpoLD3jO0JL6vHwvO4z9OQ3ChWFhRnWcjYdWk8qydztrtbUSi1MasfYzsAsXZmMZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676296; c=relaxed/simple;
	bh=TbzjzQH9CIDTBkr61HUh7xDNUnOA/rjQSgyMedG6F60=;
	h=Date:To:From:Subject:Message-Id; b=GOW35I5BEAjrzQz6aXV0GlCf3G5M7UPgP0a42SZtFrR3HhztjB+XkK88AX4BoTjGQ2s+IaxC8PFutTioEBEuqWU1c2K30eXEDsDygQi96cOPePc6hrQLIzXpsjoCSG1Qt3ASDv66CBHozbf4t6AMfCgSK52Y14XoxSv+KcbFaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+jx4/32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+jx4/32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A178C113D0;
	Thu, 20 Nov 2025 22:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676296;
	bh=TbzjzQH9CIDTBkr61HUh7xDNUnOA/rjQSgyMedG6F60=;
	h=Date:To:From:Subject:From;
	b=u+jx4/32BUHF4sQ3uMx8frQmD119waPgzyd5S0XrJyrInMumNzG/ZbQzowel2nPH4
	 nUDT+fMhkzkgxgnMG2U4HvwZ/DN+nUHhrhGSoPQjNOWbrWeMXuCCgD88Xyu82Q+ApC
	 YjZnjbLbnXRNgmGG54EBkSukMZia50lDCb8XRCwE=
Date: Thu, 20 Nov 2025 14:04:55 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-abi-add-kexec-and-kdump-sysfs-interface.patch removed from -mm tree
Message-Id: <20251120220456.3A178C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/ABI: add kexec and kdump sysfs interface
has been removed from the -mm tree.  Its filename was
     documentation-abi-add-kexec-and-kdump-sysfs-interface.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



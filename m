Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D88726656F
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490217; cv=none; b=HVcw7GQ5GUUO2rZKi7UJ35eIEIgNdcOzA8lWeQcFqTxvAd9Ic9aDOwnokxBVHrESWHv9s34cbwkknNuQ2ljS6jvokSsvgJVShRk+9Nu3IqQsHdbceA5IJuXepJtsajzJg3PeOSfkvA0CGOMPiwXAJi5iB72Yk1Lp7IH/SfFMSAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490217; c=relaxed/simple;
	bh=lkN77yPvEcVeg/dbns0nakXhl1Ym+mpnFjEc0aamoHM=;
	h=Date:To:From:Subject:Message-Id; b=dTq/8SzqcSwCEG/QYHrXWddYqrDDhU3rIOzLvjNVL7AnyGB5yY1zXtN37xMGuko6hRtl/Z3ixOlQcKt06kCn1riUv1iJykegJdrfyzaseMu/MMbCSWgl6TUDqfZODDXfC5xS7rgHH7N0muoGtcJZzUKxFwr2EikwgofNT41aVQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q0BfJMZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q0BfJMZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921BBC19424;
	Tue, 18 Nov 2025 18:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763490216;
	bh=lkN77yPvEcVeg/dbns0nakXhl1Ym+mpnFjEc0aamoHM=;
	h=Date:To:From:Subject:From;
	b=Q0BfJMZ5erQDzqKZ3g4jE7iwwX+SstAppXatEh6gyp0WW7yuSmT2rJit6GKvTPORf
	 rmccnl0k2TJ3YVHJNpqlKxjfvthweouO8rChsUc/otXs/7mXqYZgNY5AW01ZDaMbkW
	 mjxckFZWPOS+nHITQNCVPgVcBv0CmJ8z1EJ4VKqI=
Date: Tue, 18 Nov 2025 10:23:35 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-export-crashkernel-cma-reservation-to-userspace.patch added to mm-nonmm-unstable branch
Message-Id: <20251118182336.921BBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: export crashkernel CMA reservation to userspace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-export-crashkernel-cma-reservation-to-userspace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-export-crashkernel-cma-reservation-to-userspace.patch

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
Subject: crash: export crashkernel CMA reservation to userspace
Date: Tue, 18 Nov 2025 12:40:23 +0530

Add a sysfs entry /sys/kernel/kexec_crash_cma_ranges to expose all CMA
crashkernel ranges.

This allows userspace tools configuring kdump to determine how much memory
is reserved for crashkernel.  If CMA is used, tools can warn users when
attempting to capture user pages with CMA reservation.

The new sysfs hold the CMA ranges in below format:

cat /sys/kernel/kexec_crash_cma_ranges
100000000-10c7fffff

The reason for not including Crash CMA Ranges in /proc/iomem is to avoid
conflicts.  It has been observed that contiguous memory ranges are
sometimes shown as two separate System RAM entries in /proc/iomem.  If a
CMA range overlaps two System RAM ranges, adding crashk_res to /proc/iomem
can create a conflict.  Reference [1] describes one such instance on the
PowerPC architecture.

Link: https://lkml.kernel.org/r/20251118071023.1673329-1-sourabhjain@linux.ibm.com
Link: https://lore.kernel.org/all/20251016142831.144515-1-sourabhjain@linux.ibm.com/ [1]
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

 Documentation/ABI/testing/sysfs-kernel-kexec-kdump |   10 +++++
 kernel/ksysfs.c                                    |   21 +++++++++++
 2 files changed, 31 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump~crash-export-crashkernel-cma-reservation-to-userspace
+++ a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -41,3 +41,13 @@ Description:	read only
 		is used by the user space utility kexec to support updating the
 		in-kernel kdump image during hotplug operations.
 User:		Kexec tools
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
--- a/kernel/ksysfs.c~crash-export-crashkernel-cma-reservation-to-userspace
+++ a/kernel/ksysfs.c
@@ -135,6 +135,24 @@ static ssize_t kexec_crash_loaded_show(s
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
+#ifdef CONFIG_CRASH_RESERVE
+static ssize_t kexec_crash_cma_ranges_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+
+	ssize_t len = 0;
+	int i;
+
+	for (i = 0; i < crashk_cma_cnt; ++i) {
+		len += sysfs_emit_at(buf, len, "%08llx-%08llx\n",
+				     crashk_cma_ranges[i].start,
+				     crashk_cma_ranges[i].end);
+	}
+	return len;
+}
+KERNEL_ATTR_RO(kexec_crash_cma_ranges);
+#endif /* CONFIG_CRASH_RESERVE */
+
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
@@ -260,6 +278,9 @@ static struct attribute * kernel_attrs[]
 #ifdef CONFIG_CRASH_DUMP
 	&kexec_crash_loaded_attr.attr,
 	&kexec_crash_size_attr.attr,
+#ifdef CONFIG_CRASH_RESERVE
+	&kexec_crash_cma_ranges_attr.attr,
+#endif
 #endif
 #endif
 #ifdef CONFIG_VMCORE_INFO
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

documentation-abi-add-kexec-and-kdump-sysfs-interface.patch
crash-export-crashkernel-cma-reservation-to-userspace.patch


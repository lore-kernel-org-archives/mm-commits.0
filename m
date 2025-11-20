Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10333D6CC
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676297; cv=none; b=TWud3tuSbFLFWZnoTA3mKIOFSj5Fjn9wH8pNGRlk2r5GfHWFWrY4y97cN2griP177aX3GWAOmDf/HnnNWGvaS397ndh0fP5ob3dd52zkOGvUN6r1Hl4zf+CcMFxulLuMSSZODRSPM/RMMDGGWZuqyQkHWHADjT+3eRIWj03MW5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676297; c=relaxed/simple;
	bh=n6n15O1JJgYpOjGWrMt2BdohTKBTmcM952Q4tEuTuUo=;
	h=Date:To:From:Subject:Message-Id; b=Dgpjw44REcwlM7n7HdMi3VjU/k4njfA2K6PvGua/I68cODSRlBjUlCslnebsu7KVVug6FQNRnvyFBiXLpKSN4zZKIMH8drcFOmWr5BFw7sWrZlTpHo869A/LeGosUMGyvz8MNyW8pEpxg0VDEF6YadypC/oEIxydN97rxWas0Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdYFya7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdYFya7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A43C4CEF1;
	Thu, 20 Nov 2025 22:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676297;
	bh=n6n15O1JJgYpOjGWrMt2BdohTKBTmcM952Q4tEuTuUo=;
	h=Date:To:From:Subject:From;
	b=MdYFya7lR4FEQoujbMj3aQF2/3Y+gkJUOcfS96vAKmWLDCKqMPqDIw6cYxj/fCMS2
	 t0LQBLThSKpnpXB0UqOpYY8C5O34/PH7xfWmAjrbcMWQORF331qfIwHJWJNmyDHrlV
	 /bOJr72BCZAPuQmqME4mBRRLQH69Qji6ec2S5Qu4=
Date: Thu, 20 Nov 2025 14:04:56 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,shivangu@linux.ibm.com,ritesh.list@gmail.com,piliu@redhat.com,mahesh@linux.ibm.com,maddy@linux.ibm.com,jbohac@suse.cz,hbathini@linux.ibm.com,dyoung@redhat.com,bhe@redhat.com,adityag@linux.ibm.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-export-crashkernel-cma-reservation-to-userspace.patch removed from -mm tree
Message-Id: <20251120220457.30A43C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: export crashkernel CMA reservation to userspace
has been removed from the -mm tree.  Its filename was
     crash-export-crashkernel-cma-reservation-to-userspace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



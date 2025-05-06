Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1068B296FA2
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746492581; cv=none; b=pc7JCQYVDjjp1+oPlrt1Y6mC7AtHj7ps9a3CkR6YxljiNw/CBbxD992PPB3E5/oR+vYIxQemiAeIpLCnuLUwX29dVFA8TUoXgS0Rqag/Dg2q+968e+4oEPnTG9C7WycYH/eLpqCW8kEGpuv4IKL4jjEi8hJTWRXFLLMbvKFRjsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746492581; c=relaxed/simple;
	bh=KUiSx8XY/pz79PeS3H5apZPdZPsHFWf76BZ1Bm0D2sQ=;
	h=Date:To:From:Subject:Message-Id; b=NCKlQxoQCgJMxO1pY0Ayg8POn/4zz87sLvapekwUKJmdsjoFDZDropLf14u0NPVdBWAGYqSxNP6OMQjoSCPGWv+B91hn6PDsZPYqHUreFKOmbzYo+sMYiDomkpV5EUoppSO7B/71PHt6aKdqkojYvUermbG/PwQxeu4ik3jC1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MNpiRPey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MNpiRPey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFF4C4CEE4;
	Tue,  6 May 2025 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746492579;
	bh=KUiSx8XY/pz79PeS3H5apZPdZPsHFWf76BZ1Bm0D2sQ=;
	h=Date:To:From:Subject:From;
	b=MNpiRPeye8wVMgDQtwLccy3KNYP+6j10mO0eOiH5rjgzB67RKnnwQYPBC4i/YesMJ
	 mC71YGMSJGW7MUapPx+kODnZwUlnM018QAEuxwP8E1VJ5n96r97Icg0w1yrZSftIJS
	 9TUT50PbAZuOAdHPhcFNjQ4XwojLjtjCGlZ/Ls6c=
Date: Mon, 05 May 2025 17:49:38 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,kees@kernel.org,joel.granados@kernel.org,dianders@chromium.org,cminyard@mvista.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch added to mm-nonmm-unstable branch
Message-Id: <20250506004939.6AFF4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch

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
From: Max Kellermann <max.kellermann@ionos.com>
Subject: kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count
Date: Sun, 4 May 2025 20:08:31 +0200

Expose a simple counter to userspace for monitoring tools.

Link: https://lkml.kernel.org/r/20250504180831.4190860-3-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Cc: Core Minyard <cminyard@mvista.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-rcu_stall_count |    6 ++
 kernel/rcu/tree_stall.h                                |   26 ++++++++++
 2 files changed, 32 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-rcu_stall_count a/Documentation/ABI/testing/sysfs-kernel-rcu_stall_count
new file mode 100644
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-rcu_stall_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/rcu_stall_count
+Date:		May 2025
+KernelVersion:	6.16
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		Shows how many times the system has detected an RCU stall since last boot.
--- a/kernel/rcu/tree_stall.h~kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count
+++ a/kernel/rcu/tree_stall.h
@@ -20,6 +20,28 @@
 int sysctl_panic_on_rcu_stall __read_mostly;
 int sysctl_max_rcu_stall_to_panic __read_mostly;
 
+#ifdef CONFIG_SYSFS
+
+static unsigned int rcu_stall_count;
+
+static ssize_t rcu_stall_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+				    char *page)
+{
+	return sysfs_emit(page, "%u\n", rcu_stall_count);
+}
+
+static struct kobj_attribute rcu_stall_count_attr = __ATTR_RO(rcu_stall_count);
+
+static __init int kernel_rcu_stall_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &rcu_stall_count_attr.attr, NULL);
+	return 0;
+}
+
+late_initcall(kernel_rcu_stall_sysfs_init);
+
+#endif // CONFIG_SYSFS
+
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA		(5 * HZ)
 #else
@@ -784,6 +806,10 @@ static void check_cpu_stall(struct rcu_d
 		if (kvm_check_and_clear_guest_paused())
 			return;
 
+#ifdef CONFIG_SYSFS
+		++rcu_stall_count;
+#endif
+
 		rcu_stall_notifier_call_chain(RCU_STALL_NOTIFY_NORM, (void *)j - gps);
 		if (READ_ONCE(csd_lock_suppress_rcu_stall) && csd_lock_is_stuck()) {
 			pr_err("INFO: %s detected stall, but suppressed full report due to a stuck CSD-lock.\n", rcu_state.name);
_

Patches currently in -mm which might be from max.kellermann@ionos.com are

kernel-watchdog-add-sys-kernel-hardsoftlockup_count.patch
kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch


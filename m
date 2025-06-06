Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2439F1FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186186; cv=none; b=QoJVEKPwcPmbcmz6FTlYFdPGK/e73JsgpQh3r5JgNuEEs8d10XQkaK26APQEJqbsGf/18vxILr238GHQzS4MLl6VA2Xi3X9I8VUEIFspgWSBZcqACtuGZipNeiEwRLrEPiySzM0HmY53BRUHl/jpteE/Ch1aWzVikYDsLBrUTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186186; c=relaxed/simple;
	bh=cbaOKpsKowhZ83IZp5ffF9ZuIoSsXCBhuXW/tQrAAj8=;
	h=Date:To:From:Subject:Message-Id; b=HkamAxZm6mcjwG+KWTQscd/tL6pG6LXZUKmVbVkh4ddyElUzr55KHtNnrqFFbeWM3RvsvzlNqeHA/ugqOWMe9kq9d3XpxDJ/4FB9HuT4BK+38MW6FtwkCii3QXMhMt6jgwXgpgtbz0l6xucWK/6BXYfTfRbwmxCtW3hfHHm0C1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEsQLtZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEsQLtZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D8DC4CEEB;
	Fri,  6 Jun 2025 05:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186185;
	bh=cbaOKpsKowhZ83IZp5ffF9ZuIoSsXCBhuXW/tQrAAj8=;
	h=Date:To:From:Subject:From;
	b=ZEsQLtZc0ytvqDJ+4JaaOzYvT1nTbgjkDTEjS2hl313wMf4xbdPjboPjNAjrnRzx+
	 P9oSkjtqUQQrKm2KMc+krsaFgnEaUBYJeZpYOIse1dHW4zb7MLLseb33frORMHR+ek
	 nc0H7Q8P/dBtgaM/vQQ0MMiCSwVSlcSbmGqqEaU4=
Date: Thu, 05 Jun 2025 22:03:05 -0700
To: mm-commits@vger.kernel.org,sourabhjain@linux.ibm.com,song@kernel.org,joel.granados@kernel.org,dianders@chromium.org,cminyard@mvista.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch removed from -mm tree
Message-Id: <20250606050305.91D8DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count
has been removed from the -mm tree.  Its filename was
     kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Max Kellermann <max.kellermann@ionos.com>
Subject: kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count
Date: Sun, 4 May 2025 20:08:31 +0200

Expose a simple counter to userspace for monitoring tools.

(akpm: 2536c5c7d6ae added the documentation but the code changes were lost)

Link: https://lkml.kernel.org/r/20250504180831.4190860-3-max.kellermann@ionos.com
Fixes: 2536c5c7d6ae ("kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Cc: Core Minyard <cminyard@mvista.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Song Liu <song@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree_stall.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

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



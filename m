Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B7289837
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849742; cv=none; b=QrHabPxI+XE3n5Zz0tlf2uFEsRDDFhaGiB2dUwFwazjDA0i+H8HKvGl62z6f1BxPvApo6rQGr5TFFdjROMG7W/cd4HDLXmKWgZVa4OeUInyZBMZDzDaslpjRdLa+btiLFZSk5vZVAIM/bCaCru1/FNiUgMcxCjxwgR2XtsT4lrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849742; c=relaxed/simple;
	bh=f7R+8f8qYT38ZWDSWLPOWoPZm7T4CSXtzc47tlD0kbQ=;
	h=Date:To:From:Subject:Message-Id; b=e4Z8QVSJpJMbuV9KQAh3iLqaDD4Acq6bAepsWYAwVDRe2PFcV3vxzGvxSQxAaa2CeiHiZiLptLSBwI7Ko7lYVYqz5t+TtDAdw8UB03jNS/l/RQfvDDcw+9qIiqCO9p1yFW5wIS8tEhwQ2DpLhOtzGlCMNDkahyN7xw3HWEkQJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gt03Ctn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gt03Ctn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5810DC4CEE4;
	Wed, 21 May 2025 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849742;
	bh=f7R+8f8qYT38ZWDSWLPOWoPZm7T4CSXtzc47tlD0kbQ=;
	h=Date:To:From:Subject:From;
	b=gt03Ctn2/K7D7k5Hp/FaWzNF6FOAqHJ8I4NlsxN41QpOhM4tyGKLwVnDRR/z5xvF5
	 MI2ztKqVojyPYVST+xZURMOOg8LrSiOP6+7rVRztar3v9/zHe6k2CqSWb1mDC3QNCX
	 a1pOKyIGIpYIAl+M690WDHhbiFWM6OWSoCrU1ANk=
Date: Wed, 21 May 2025 10:49:01 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,kees@kernel.org,joel.granados@kernel.org,dianders@chromium.org,cminyard@mvista.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch removed from -mm tree
Message-Id: <20250521174902.5810DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count
has been removed from the -mm tree.  Its filename was
     kernel-rcu-tree_stall-add-sys-kernel-rcu_stall_count.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 Documentation/ABI/testing/sysfs-kernel-rcu_stall_count |    6 ++++++
 1 file changed, 6 insertions(+)

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
_

Patches currently in -mm which might be from max.kellermann@ionos.com are



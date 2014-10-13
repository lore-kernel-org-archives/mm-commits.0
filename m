From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-check_data_rlimit-helper-v2.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:19:53 -0700
Message-ID: <543c17c9.FVC5feYDxb2/8iF/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaJMSTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com, jln@google.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce check_data_rlimit helper
has been removed from the -mm tree.  Its filename was
     mm-introduce-check_data_rlimit-helper-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: introduce check_data_rlimit helper

To eliminate code duplication lets introduce check_data_rlimit helper
which we will use in brk() and prctl() syscalls.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-check_data_rlimit-helper-v2 include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-check_data_rlimit-helper-v2
+++ a/include/linux/mm.h
@@ -18,6 +18,7 @@
 #include <linux/pfn.h>
 #include <linux/bit_spinlock.h>
 #include <linux/shrinker.h>
+#include <linux/resource.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1780,6 +1781,20 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
+static inline int check_data_rlimit(unsigned long rlim,
+				    unsigned long new,
+				    unsigned long start,
+				    unsigned long end_data,
+				    unsigned long start_data)
+{
+	if (rlim < RLIM_INFINITY) {
+		if (((new - start) + (end_data - start_data)) > rlim)
+			return -ENOSPC;
+	}
+
+	return 0;
+}
+
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-process_vm_accessc-mark-function-as-static.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:44 -0700
Message-ID: <533f08a0.26bOzwLgMShAgpOD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaDDTbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-process_vm_accessc-mark-function-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:44 -0700


The patch titled
     Subject: mm/process_vm_access.c: mark function as static
has been removed from the -mm tree.  Its filename was
     mm-process_vm_accessc-mark-function-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/process_vm_access.c: mark function as static

Mark function as static in process_vm_access.c because it is not used
outside this file.

This eliminates the following warning in mm/process_vm_access.c:
mm/process_vm_access.c:416:1: warning: no previous prototype for `compat_process_vm_rw' [-Wmissing-prototypes]

[akpm@linux-foundation.org: remove unneeded asmlinkage - compat_process_vm_rw isn't referenced from asm]
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/process_vm_access.c~mm-process_vm_accessc-mark-function-as-static mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-process_vm_accessc-mark-function-as-static
+++ a/mm/process_vm_access.c
@@ -412,7 +412,7 @@ SYSCALL_DEFINE6(process_vm_writev, pid_t
 
 #ifdef CONFIG_COMPAT
 
-asmlinkage ssize_t
+static ssize_t
 compat_process_vm_rw(compat_pid_t pid,
 		     const struct compat_iovec __user *lvec,
 		     unsigned long liovcnt,
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch


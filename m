From: akpm@linux-foundation.org
Subject: - vm-security-add-security-hook-to-do_brk.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:30:13 -0800
Message-ID: <200712080130.lB81UDbL013526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbXLHBkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:40:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, alan@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     VM/Security: add security hook to do_brk
has been removed from the -mm tree.  Its filename was
     vm-security-add-security-hook-to-do_brk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VM/Security: add security hook to do_brk
From: Eric Paris <eparis@redhat.com>

Given a specifically crafted binary do_brk() can be used to get low pages
available in userspace virtual memory and can thus be used to circumvent
the mmap_min_addr low memory protection.  Add security checks in do_brk().

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mmap.c~vm-security-add-security-hook-to-do_brk mm/mmap.c
--- a/mm/mmap.c~vm-security-add-security-hook-to-do_brk
+++ a/mm/mmap.c
@@ -1934,6 +1934,10 @@ unsigned long do_brk(unsigned long addr,
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
+	error = security_file_mmap(0, 0, 0, 0, addr, 1);
+	if (error)
+		return error;
+
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = arch_mmap_check(addr, len, flags);
_

Patches currently in -mm which might be from eparis@redhat.com are

origin.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch

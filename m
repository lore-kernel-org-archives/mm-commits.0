From: akpm@linux-foundation.org
Subject: + vm-security-add-security-hook-to-do_brk.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:18:38 -0800
Message-ID: <200712042018.lB4KIcFL003092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbXLDUUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:20:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, alan@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     VM/Security: add security hook to do_brk
has been added to the -mm tree.  Its filename is
     vm-security-add-security-hook-to-do_brk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1946,6 +1946,10 @@ unsigned long do_brk(unsigned long addr,
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

git-selinux.patch
vm-security-add-security-hook-to-do_brk.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch

From: akpm@linux-foundation.org
Subject: + mm-bring-back-sys-kernel-mm.patch added to -mm tree
Date: Mon, 27 Jan 2014 13:51:55 -0800
Message-ID: <52e6d4fb.xwTlW/w58TFnIiqD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaA0Vv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 16:51:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, hughd@google.com

Subject: + mm-bring-back-sys-kernel-mm.patch added to -mm tree
To: hughd@google.com,paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 13:51:55 -0800


The patch titled
     Subject: mm: bring back /sys/kernel/mm
has been added to the -mm tree.  Its filename is
     mm-bring-back-sys-kernel-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bring-back-sys-kernel-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bring-back-sys-kernel-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: bring back /sys/kernel/mm

Commit da29bd36224b ("mm/mm_init.c: make creation of the mm_kobj happen
earlier than device_initcall") changed to pure_initcall(mm_sysfs_init).

That's too early: mm_sysfs_init() depends on core_initcall(ksysfs_init) to
have made the kernel_kobj directory "kernel" in which to create "mm".

Make it postcore_initcall(mm_sysfs_init).  We could use core_initcall(),
and depend upon Makefile link order kernel/ mm/ fs/ ipc/ security/ ...  as
core_initcall(debugfs_init) and core_initcall(securityfs_init) do; but
better not.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mm_init.c~mm-bring-back-sys-kernel-mm mm/mm_init.c
--- a/mm/mm_init.c~mm-bring-back-sys-kernel-mm
+++ a/mm/mm_init.c
@@ -202,4 +202,4 @@ static int __init mm_sysfs_init(void)
 
 	return 0;
 }
-pure_initcall(mm_sysfs_init);
+postcore_initcall(mm_sysfs_init);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-bring-back-sys-kernel-mm.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch


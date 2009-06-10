From: akpm@linux-foundation.org
Subject: [merged] shm-fix-unused-warnings-on-nommu.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:43:59 -0700
Message-ID: <200906101743.n5AHhxDR030722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758335AbZFJRok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     shm: fix unused warnings on nommu
has been removed from the -mm tree.  Its filename was
     shm-fix-unused-warnings-on-nommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shm: fix unused warnings on nommu
From: Mike Frysinger <vapier@gentoo.org>

The massive nommu update (8feae131) resulted in these warnings:
ipc/shm.c: In function `sys_shmdt':
ipc/shm.c:974: warning: unused variable `size'
ipc/shm.c:972: warning: unused variable `next'

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~shm-fix-unused-warnings-on-nommu ipc/shm.c
--- a/ipc/shm.c~shm-fix-unused-warnings-on-nommu
+++ a/ipc/shm.c
@@ -969,10 +969,13 @@ SYSCALL_DEFINE3(shmat, int, shmid, char 
 SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *next;
+	struct vm_area_struct *vma;
 	unsigned long addr = (unsigned long)shmaddr;
-	loff_t size = 0;
 	int retval = -EINVAL;
+#ifdef CONFIG_MMU
+	loff_t size = 0;
+	struct vm_area_struct *next;
+#endif
 
 	if (addr & ~PAGE_MASK)
 		return retval;
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch


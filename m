From: akpm@linux-foundation.org
Subject: + shm-fix-unused-warnings-on-nommu.patch added to -mm tree
Date: Thu, 04 Jun 2009 22:35:16 -0700
Message-ID: <200906050535.n555ZGDC017981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbZFEFfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 01:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dhowells@redhat.com


The patch titled
     shm: fix unused warnings on nommu
has been added to the -mm tree.  Its filename is
     shm-fix-unused-warnings-on-nommu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

kbuild-fix-detection-of-config_frame_warn=0.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
virtio_blk-add-missing-__devinitexit-markings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
gitignore-ignore-patch-files.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
shm-fix-unused-warnings-on-nommu.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch


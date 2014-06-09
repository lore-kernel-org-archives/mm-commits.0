From: akpm@linux-foundation.org
Subject: [merged] ipc-shmc-check-for-ulong-overflows-in-shmat.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:37:12 -0700
Message-ID: <53960ce8.tGj0EF1Uh/bAwf7J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaFIThN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, kosaki.motohiro@jp.fujitsu.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-shmc-check-for-ulong-overflows-in-shmat.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,kosaki.motohiro@jp.fujitsu.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:12 -0700


The patch titled
     Subject: ipc/shm.c: check for ulong overflows in shmat
has been removed from the -mm tree.  Its filename was
     ipc-shmc-check-for-ulong-overflows-in-shmat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/shm.c: check for ulong overflows in shmat

The increase of SHMMAX/SHMALL is a 4 patch series.

The change itself is trivial, the only problem are interger overflows. 
The overflows are not new, but if we make huge values the default, then
the code should be free from overflows.

SHMMAX:

- shmmem_file_setup places a hard limit on the segment size:
  MAX_LFS_FILESIZE.

  On 32-bit, the limit is > 1 TB, i.e. 4 GB-1 byte segments are
  possible. Rounded up to full pages the actual allocated size
  is 0. --> must be fixed, patch 3

- shmat:
  - find_vma_intersection does not handle overflows properly.
    --> must be fixed, patch 1

  - the rest is fine, do_mmap_pgoff limits mappings to TASK_SIZE
    and checks for overflows (i.e.: map 2 GB, starting from
    addr=2.5GB fails).

SHMALL:
- after creating 8192 segments size (1L<<63)-1, shm_tot overflows and
  returns 0.  --> must be fixed, patch 2.

Userspace:
- Obviously, there could be overflows in userspace. There is nothing
  we can do, only use values smaller than ULONG_MAX.
  I ended with "ULONG_MAX - 1L<<24":

  - TASK_SIZE cannot be used because it is the size of the current
    task. Could be 4G if it's a 32-bit task on a 64-bit kernel.

  - The maximum size is not standardized across archs:
    I found TASK_MAX_SIZE, TASK_SIZE_MAX and TASK_SIZE_64.

  - Just in case some arch revives a 4G/4G split, nearly
    ULONG_MAX is a valid segment size.

  - Using "0" as a magic value for infinity is even worse, because
    right now 0 means 0, i.e. fail all allocations.


This patch (of 4):

find_vma_intersection() does not work as intended if addr+size overflows. 
The patch adds a manual check before the call to find_vma_intersection.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/shm.c~ipc-shmc-check-for-ulong-overflows-in-shmat ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-check-for-ulong-overflows-in-shmat
+++ a/ipc/shm.c
@@ -1160,6 +1160,9 @@ long do_shmat(int shmid, char __user *sh
 	down_write(&current->mm->mmap_sem);
 	if (addr && !(shmflg & SHM_REMAP)) {
 		err = -EINVAL;
+		if (addr + size < addr)
+			goto invalid;
+
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
 		/*
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch


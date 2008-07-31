From: akpm@linux-foundation.org
Subject: + mlock-fix-return-values.patch added to -mm tree
Date: Thu, 31 Jul 2008 14:30:48 -0700
Message-ID: <200807312130.m6VLUmL3013242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYGaVbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 17:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, halesh.s@india.com, stable@kernel.org


The patch titled
     mlock() fix return values
has been added to the -mm tree.  Its filename is
     mlock-fix-return-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock() fix return values
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Halesh says:

Please find the below testcase provide to test mlock.

Test Case :
===========================

#include <sys/resource.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>

int main(void)
{
  int fd,ret, i = 0;
  char *addr, *addr1 = NULL;
  unsigned int page_size;
  struct rlimit rlim;

  if (0 != geteuid()) 
  {
   printf("Execute this pgm as root\n");
   exit(1);
  }

  /* create a file */
  if ((fd = open("mmap_test.c",O_RDWR|O_CREAT,0755)) == -1)
  {
   printf("cant create test file\n");
   exit(1);
  }

  page_size = sysconf(_SC_PAGE_SIZE);

  /* set the MEMLOCK limit */
  rlim.rlim_cur = 2000;
  rlim.rlim_max = 2000;

  if ((ret = setrlimit(RLIMIT_MEMLOCK,&rlim)) != 0)
  {
   printf("Cant change limit values\n");
   exit(1);
  }

  addr = 0;
  while (1)
  {
  /* map a page into memory each time*/ 
  if ((addr = (char *) mmap(addr,page_size, PROT_READ |     
PROT_WRITE,MAP_SHARED,fd,0)) == MAP_FAILED) 
  {
   printf("cant do mmap on file\n");
   exit(1);
  }

  if (0 == i)
    addr1 = addr;
  i++;
  errno = 0;	
  /* lock the mapped memory pagewise*/
  if ((ret = mlock((char *)addr, 1500)) == -1) 
  {
   printf("errno value is %d\n", errno);
   printf("cant lock maped region\n");
   exit(1);
  }
  addr = addr + page_size;
 }
}
======================================================


This testcase results in an mlock() failure with errno 14 that is EFAULT,
but it has nowhere been specified that mlock() will return EFAULT.  When I
tested the same on older kernels like 2.6.18, I got the correct result i.e
errno 12 (ENOMEM).

I think in source code mlock(2), setting errno ENOMEM has been missed in
do_mlock() , on mlock_fixup() failure.




SUSv3 requires the following behavior frmo mlock(2).

[ENOMEM]
    Some or all of the address range specified by the addr and
    len arguments does not correspond to valid mapped pages
    in the address space of the process.

[EAGAIN]
    Some or all of the memory identified by the operation could not
    be locked when the call was made.

This rule isn't so nice and slighly strange.  but many people think
POSIX/SUS compliance is important.

Reported-by: Halesh <halesh.s@india.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++++---
 mm/mlock.c  |    2 --
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mlock-fix-return-values mm/memory.c
--- a/mm/memory.c~mlock-fix-return-values
+++ a/mm/memory.c
@@ -2767,16 +2767,26 @@ int make_pages_present(unsigned long add
 
 	vma = find_vma(current->mm, addr);
 	if (!vma)
-		return -1;
+		return -ENOMEM;
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		/*
+		   SUS require strange return value to mlock
+		    - invalid addr generate to ENOMEM.
+		    - out of memory should generate EAGAIN.
+		*/
+		if (ret == -EFAULT)
+			ret = -ENOMEM;
+		else if (ret == -ENOMEM)
+			ret = -EAGAIN;
 		return ret;
-	return ret == len ? 0 : -1;
+	}
+	return ret == len ? 0 : -ENOMEM;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
diff -puN mm/mlock.c~mlock-fix-return-values mm/mlock.c
--- a/mm/mlock.c~mlock-fix-return-values
+++ a/mm/mlock.c
@@ -78,8 +78,6 @@ success:
 
 	mm->locked_vm -= pages;
 out:
-	if (ret == -ENOMEM)
-		ret = -EAGAIN;
 	return ret;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mlock-fix-return-values.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch


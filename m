From: akpm@linux-foundation.org
Subject: + vmcore-enable-proc-vmcore-mmap-for-s390.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:20:57 -0700
Message-ID: <51f2da29.fHF9cXq7hFLZdK6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3GZUU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + vmcore-enable-proc-vmcore-mmap-for-s390.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:57 -0700


The patch titled
     Subject: vmcore: enable /proc/vmcore mmap for s390
has been added to the -mm tree.  Its filename is
     vmcore-enable-proc-vmcore-mmap-for-s390.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-enable-proc-vmcore-mmap-for-s390.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-enable-proc-vmcore-mmap-for-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: vmcore: enable /proc/vmcore mmap for s390

The patch "s390/vmcore: Implement remap_oldmem_pfn_range for s390" allows
now to use mmap also on s390.

So enable mmap for s390 again.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~vmcore-enable-proc-vmcore-mmap-for-s390 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-enable-proc-vmcore-mmap-for-s390
+++ a/fs/proc/vmcore.c
@@ -327,7 +327,7 @@ static inline char *alloc_elfnotes_buf(s
  * regions in the 1st kernel pointed to by PT_LOAD entries) into
  * virtually contiguous user-space in ELF layout.
  */
-#if defined(CONFIG_MMU) && !defined(CONFIG_S390)
+#ifdef CONFIG_MMU
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch


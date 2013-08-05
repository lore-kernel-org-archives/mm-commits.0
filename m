From: akpm@linux-foundation.org
Subject: + vmcore-introduce-remap_oldmem_pfn_range-fix.patch added to -mm
 tree
Date: Mon, 05 Aug 2013 14:08:36 -0700
Message-ID: <52001454.Ucn4GoAKBtccuAcE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3HEVIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 17:08:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, fengguang.wu@intel.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + vmcore-introduce-remap_oldmem_pfn_range-fix.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,fengguang.wu@intel.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 14:08:36 -0700


The patch titled
     Subject: vmcore: fix address space sparse warnings
has been added to the -mm tree.  Its filename is
     vmcore-introduce-remap_oldmem_pfn_range-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-introduce-remap_oldmem_pfn_range-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-introduce-remap_oldmem_pfn_range-fix.patch

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
Subject: vmcore: fix address space sparse warnings

Fix the following sparse warnings:

 fs/proc/vmcore.c:173:34: sparse: incorrect type in argument 1
                                  (different address spaces)
 fs/proc/vmcore.c:173:34:    expected void [noderef] <asn:1>*dst
 fs/proc/vmcore.c:173:34:    got void *target
 fs/proc/vmcore.c:256:30: sparse: incorrect type in argument 1
                                  (different address spaces)
 fs/proc/vmcore.c:256:30:    expected char *[assigned] buffer
 fs/proc/vmcore.c:256:30:    got char [noderef] <asn:1>*buffer

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-introduce-remap_oldmem_pfn_range-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-introduce-remap_oldmem_pfn_range-fix
+++ a/fs/proc/vmcore.c
@@ -170,7 +170,7 @@ int __weak remap_oldmem_pfn_range(struct
 static int copy_to(void *target, void *src, size_t size, int userbuf)
 {
 	if (userbuf) {
-		if (copy_to_user(target, src, size))
+		if (copy_to_user((char __user *) target, src, size))
 			return -EFAULT;
 	} else {
 		memcpy(target, src, size);
@@ -253,7 +253,7 @@ static ssize_t __read_vmcore(char *buffe
 static ssize_t read_vmcore(struct file *file, char __user *buffer,
 			   size_t buflen, loff_t *fpos)
 {
-	return __read_vmcore(buffer, buflen, fpos, 1);
+	return __read_vmcore((__force char *) buffer, buflen, fpos, 1);
 }
 
 /*
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
vmcore-introduce-remap_oldmem_pfn_range-fix.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch


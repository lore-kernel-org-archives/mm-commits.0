From: akpm@linux-foundation.org
Subject: + proc-vmcore-wrong-data-type-casting-fix.patch added to -mm tree
Date: Mon, 14 Mar 2016 13:48:13 -0700
Message-ID: <56e7238d.DUtImh1G5XG9cMXX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbcCNUsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2016 16:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, mhuang@redhat.com, nasa4836@gmail.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-vmcore: wrong data type casting fix
has been added to the -mm tree.  Its filename is
     proc-vmcore-wrong-data-type-casting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-vmcore-wrong-data-type-casting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-vmcore-wrong-data-type-casting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: proc-vmcore: wrong data type casting fix

On i686 PAE enabled machine the contiguous physical area could be large
and it can cause trimming down variables in below calculation in
read_vmcore() and mmap_vmcore():

	tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);

That is, the types being used is like below on i686:
m->offset: unsigned long long int
m->size:   unsigned long long int
*fpos:     loff_t (long long int)
buflen:    size_t (unsigned int)

So casting (m->offset + m->size - *fpos) by size_t means truncating a given
value by 4GB.

Suppose (m->offset + m->size - *fpos) being truncated to 0, buflen >0 then
we will get tsz = 0.  It is of course not an expected result.  Similarly
we could also get other truncated values less than buflen.  Then the real
size passed down is not correct any more.

If (m->offset + m->size - *fpos) is above 4GB, read_vmcore or mmap_vmcore
use the min_t result with truncated values being compared to buflen.
Then, fpos proceeds with the wrong value so that we reach below bugs:

1) read_vmcore will refuse to continue so makedumpfile fails.
2) mmap_vmcore will trigger BUG_ON() in remap_pfn_range().

Use unsigned long long in min_t instead so that the variables in  are not
truncated.

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Cc: Minfei Huang <mhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/vmcore.c~proc-vmcore-wrong-data-type-casting-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-vmcore-wrong-data-type-casting-fix
+++ a/fs/proc/vmcore.c
@@ -231,7 +231,9 @@ static ssize_t __read_vmcore(char *buffe
 
 	list_for_each_entry(m, &vmcore_list, list) {
 		if (*fpos < m->offset + m->size) {
-			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
+			tsz = (size_t)min_t(unsigned long long,
+					    m->offset + m->size - *fpos,
+					    buflen);
 			start = m->paddr + *fpos - m->offset;
 			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
 			if (tmp < 0)
@@ -461,7 +463,8 @@ static int mmap_vmcore(struct file *file
 		if (start < m->offset + m->size) {
 			u64 paddr = 0;
 
-			tsz = min_t(size_t, m->offset + m->size - start, size);
+			tsz = (size_t)min_t(unsigned long long,
+					    m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
 			if (vmcore_remap_oldmem_pfn(vma, vma->vm_start + len,
 						    paddr >> PAGE_SHIFT, tsz,
_

Patches currently in -mm which might be from dyoung@redhat.com are

proc-vmcore-wrong-data-type-casting-fix.patch


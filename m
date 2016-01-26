From: akpm@linux-foundation.org
Subject: + mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch added to -mm tree
Date: Tue, 26 Jan 2016 12:21:27 -0800
Message-ID: <56a7d547.S0H50xL4wG3pyDEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcAZUV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 15:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: don't imply PROT_EXEC on non-exec fs
has been added to the -mm tree.  Its filename is
     mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mprotect.c: don't imply PROT_EXEC on non-exec fs

The mprotect(PROT_READ) fails when called by the READ_IMPLIES_EXEC binary
on a memory mapped file located on non-exec fs.  The mprotect does not
check whether fs is _executable_ or not.  The PROT_EXEC flag is set
automatically even if a memory mapped file is located on non-exec fs.  Fix
it by checking whether a memory mapped file is located on a non-exec fs. 
If so the PROT_EXEC is not implied by the PROT_READ.  The implementation
uses the VM_MAYEXEC flag set properly in mmap.  Now it is consistent with
mmap.

I did the isolated tests (PT_GNU_STACK X/NX, multiple VMAs, X/NX fs).  I
also patched the official 3.19.0-47-generic Ubuntu 14.04 kernel and it
seems to work.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs
+++ a/mm/mprotect.c
@@ -352,10 +352,12 @@ fail:
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-	unsigned long vm_flags, nstart, end, tmp, reqprot;
+	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
 	int error = -EINVAL;
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
+	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
+				(prot & PROT_READ);
 	prot &= ~(PROT_GROWSDOWN|PROT_GROWSUP);
 	if (grows == (PROT_GROWSDOWN|PROT_GROWSUP)) /* can't be both */
 		return -EINVAL;
@@ -372,13 +374,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		return -EINVAL;
 
 	reqprot = prot;
-	/*
-	 * Does the application expect PROT_READ to imply PROT_EXEC:
-	 */
-	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
-		prot |= PROT_EXEC;

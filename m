From: akpm@linux-foundation.org
Subject: +
 mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers.patch added to -mm tree
Date: Fri, 03 Feb 2017 15:21:23 -0800
Message-ID: <58951073.Ok/a78qoWubyI2KU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbdBCXVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:21:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, viro@ZenIV.linux.org.uk, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid returning VM_FAULT_RETRY from ->page_mkwrite handlers
has been added to the -mm tree.  Its filename is
     mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: avoid returning VM_FAULT_RETRY from ->page_mkwrite handlers

Some ->page_mkwrite handlers may return VM_FAULT_RETRY as its return code
(GFS2 or Lustre can definitely do this).  However VM_FAULT_RETRY from
->page_mkwrite is completely unhandled by the mm code and results in
locking and writeably mapping the page which definitely is not what the
caller wanted.  Fix Lustre and block_page_mkwrite_ret() used by other
filesystems (notably GFS2) to return VM_FAULT_NOPAGE instead which results
in bailing out from the fault code, the CPU then retries the access, and
we fault again effectively doing what the handler wanted.

Link: http://lkml.kernel.org/r/20170203150729.15863-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/llite_mmap.c |    4 +---
 include/linux/buffer_head.h                      |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/llite_mmap.c~mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers drivers/staging/lustre/lustre/llite/llite_mmap.c
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c~mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers
+++ a/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -390,15 +390,13 @@ static int ll_page_mkwrite(struct vm_are
 		result = VM_FAULT_LOCKED;
 		break;
 	case -ENODATA:
+	case -EAGAIN:
 	case -EFAULT:
 		result = VM_FAULT_NOPAGE;
 		break;
 	case -ENOMEM:
 		result = VM_FAULT_OOM;
 		break;
-	case -EAGAIN:
-		result = VM_FAULT_RETRY;
-		break;
 	default:
 		result = VM_FAULT_SIGBUS;
 		break;
diff -puN include/linux/buffer_head.h~mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers
+++ a/include/linux/buffer_head.h
@@ -243,12 +243,10 @@ static inline int block_page_mkwrite_ret
 {
 	if (err == 0)
 		return VM_FAULT_LOCKED;
-	if (err == -EFAULT)
+	if (err == -EFAULT || err == -EAGAIN)
 		return VM_FAULT_NOPAGE;
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
-	if (err == -EAGAIN)
-		return VM_FAULT_RETRY;
 	/* -ENOSPC, -EDQUOT, -EIO ... */
 	return VM_FAULT_SIGBUS;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

mm-avoid-returning-vm_fault_retry-from-page_mkwrite-handlers.patch


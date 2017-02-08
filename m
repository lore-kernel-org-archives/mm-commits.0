From: akpm@linux-foundation.org
Subject: [patch 2/4] mm: avoid returning VM_FAULT_RETRY from
 ->page_mkwrite handlers
Date: Wed, 08 Feb 2017 14:30:53 -0800
Message-ID: <589b9c1d.aztBQGfJJwg3K6hC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbdBHWay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, jinshan.xiong@intel.com, viro@ZenIV.linux.org.uk, willy@infradead.org

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
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
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

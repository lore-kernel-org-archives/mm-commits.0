Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D89C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F1C61350
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbhKIChf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63FD361208;
        Tue,  9 Nov 2021 02:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425289;
        bh=RM5MP/fzRm0tw5SlDSR6dbzZETrYndA6YVbT9wdEzwU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RWU5zF1smE2JDfj4Ol8YUxLwD3Xm9vHkip6CqXgPMQN2XiDfzsGTbHQYApNekOh3I
         P7l6OJcvz5537Vvq2DFHSZwkwb301u2709+zSl4lcZUNu2OTyX690U/rCET0p9kpiY
         /RJPWuj8bI4tdaCjegeEY+QhsVwrg9FGgV/+mmQU=
Date:   Mon, 08 Nov 2021 18:34:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 63/87] coda: convert from atomic_t to refcount_t
 on coda_vm_ops->refcnt
Message-ID: <20211109023448.5hgIfW7ol%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: coda: convert from atomic_t to refcount_t on coda_vm_ops->refcnt

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Link: https://lkml.kernel.org/r/20210908140308.18491-8-jaharkes@cs.cmu.edu
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/coda/file.c~coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt
+++ a/fs/coda/file.c
@@ -8,6 +8,7 @@
  * to the Coda project. Contact Peter Braam <coda@cs.cmu.edu>.
  */
 
+#include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/time.h>
@@ -28,7 +29,7 @@
 #include "coda_int.h"
 
 struct coda_vm_ops {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct file *coda_file;
 	const struct vm_operations_struct *host_vm_ops;
 	struct vm_operations_struct vm_ops;
@@ -98,7 +99,7 @@ coda_vm_open(struct vm_area_struct *vma)
 	struct coda_vm_ops *cvm_ops =
 		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
 
-	atomic_inc(&cvm_ops->refcnt);
+	refcount_inc(&cvm_ops->refcnt);
 
 	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->open)
 		cvm_ops->host_vm_ops->open(vma);
@@ -113,7 +114,7 @@ coda_vm_close(struct vm_area_struct *vma
 	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->close)
 		cvm_ops->host_vm_ops->close(vma);
 
-	if (atomic_dec_and_test(&cvm_ops->refcnt)) {
+	if (refcount_dec_and_test(&cvm_ops->refcnt)) {
 		vma->vm_ops = cvm_ops->host_vm_ops;
 		fput(cvm_ops->coda_file);
 		kfree(cvm_ops);
@@ -189,7 +190,7 @@ coda_file_mmap(struct file *coda_file, s
 		cvm_ops->vm_ops.open = coda_vm_open;
 		cvm_ops->vm_ops.close = coda_vm_close;
 		cvm_ops->coda_file = coda_file;
-		atomic_set(&cvm_ops->refcnt, 1);
+		refcount_set(&cvm_ops->refcnt, 1);
 
 		vma->vm_ops = &cvm_ops->vm_ops;
 	}
_

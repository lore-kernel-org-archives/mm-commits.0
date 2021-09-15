Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C3BC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C02461164
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhIOD6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236277AbhIOD6i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3399610E8;
        Wed, 15 Sep 2021 03:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678240;
        bh=dtiLyTaA12yeu//gQ1IN36+ofvbaP8QYgNlXfOd3ByE=;
        h=Date:From:To:Subject:From;
        b=z12ln66wr5MiibCYPwoPuy6+1J3Cl6VU8/b4o4jhW2/+HyPM0PMJ2Y9jAnEbOqedl
         WDexJr5mx3LMcmKsM07VZ6fmWa1APDDirxA/WNRNMEzNwqJNrUzGA8oyMyjib0Rq5i
         aoISf7kL/MEFa6iAWybDDf3rDDEvc4ofCuEezU/s=
Date:   Tue, 14 Sep 2021 20:57:19 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  +
 coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt.patch added
 to -mm tree
Message-ID: <20210915035719.lBBbceWey%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: convert from atomic_t to refcount_t on coda_vm_ops->refcnt
has been added to the -mm tree.  Its filename is
     coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from xiyuyang19@fudan.edu.cn are

mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch
mm-rmap-convert-from-atomic_t-to-refcount_t-on-anon_vma-refcount.patch
coda-convert-from-atomic_t-to-refcount_t-on-coda_vm_ops-refcnt.patch


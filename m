Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CB3C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiDYWdE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiDYWcj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:32:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D5E10DE1B
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2490D61550
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB9DC385A7;
        Mon, 25 Apr 2022 22:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650925628;
        bh=duTziLf+duhI/kGoNqDsx4+uneJXg/yhs+gv86FLMwU=;
        h=Date:To:From:Subject:From;
        b=TE8k+rfXk53eO/w95tbKu1H/CZmoANnK/M18VLX3Qrr4IZqeGAuoJfBZBKFtzH0Hd
         9g0xwWJlohUnw6Woenp4LSwLzOOfsRUfc6OSCn0G19uM2/GY+kVVt2UpuH2X5eBHyb
         889M6x1bbXeP8O/IKqfL7MdJi4Ws7aJH7qZkeAjs=
Date:   Mon, 25 Apr 2022 15:27:07 -0700
To:     mm-commits@vger.kernel.org, yangtiezhu@loongson.cn,
        viro@zeniv.linux.org.uk, hch@lst.de, bhe@redhat.com,
        amit.kachhap@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch added to -mm tree
Message-Id: <20220425222708.7BB9DC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: convert read_from_oldmem() to take an iov_iter
has been added to the -mm tree.  Its filename is
     vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmcore: convert read_from_oldmem() to take an iov_iter

Remove the read_from_oldmem() wrapper introduced earlier and convert all
the remaining callers to pass an iov_iter.

Link: https://lkml.kernel.org/r/20220408090636.560886-4-bhe@redhat.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash_dump_64.c |    7 ++++-
 fs/proc/vmcore.c                |   40 +++++++++++-------------------
 include/linux/crash_dump.h      |   10 +++----
 3 files changed, 25 insertions(+), 32 deletions(-)

--- a/arch/x86/kernel/crash_dump_64.c~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -54,6 +54,11 @@ ssize_t copy_oldmem_page_encrypted(struc
 
 ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0,
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos,
 				cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT));
 }
--- a/fs/proc/vmcore.c~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/fs/proc/vmcore.c
@@ -129,7 +129,7 @@ static int open_vmcore(struct inode *ino
 }
 
 /* Reads a page from the oldmem device from given offset. */
-static ssize_t read_from_oldmem_iter(struct iov_iter *iter, size_t count,
+ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
 			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
@@ -178,27 +178,6 @@ static ssize_t read_from_oldmem_iter(str
 	return read;
 }
 
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted)
-{
-	struct iov_iter iter;
-	struct iovec iov;
-	struct kvec kvec;
-
-	if (userbuf) {
-		iov.iov_base = (__force void __user *)buf;
-		iov.iov_len = count;
-		iov_iter_init(&iter, READ, &iov, 1, count);
-	} else {
-		kvec.iov_base = buf;
-		kvec.iov_len = count;
-		iov_iter_kvec(&iter, READ, &kvec, 1, count);
-	}
-
-	return read_from_oldmem_iter(&iter, count, ppos, encrypted);
-}
-
 /*
  * Architectures may override this function to allocate ELF header in 2nd kernel
  */
@@ -218,7 +197,12 @@ void __weak elfcorehdr_free(unsigned lon
  */
 ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0, false);
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos, false);
 }
 
 /*
@@ -226,7 +210,13 @@ ssize_t __weak elfcorehdr_read(char *buf
  */
 ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0, cc_platform_has(CC_ATTR_MEM_ENCRYPT));
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos,
+			cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 }
 
 /*
@@ -402,7 +392,7 @@ static ssize_t __read_vmcore(struct iov_
 					    m->offset + m->size - *fpos,
 					    iov_iter_count(iter));
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem_iter(iter, tsz, &start,
+			tmp = read_from_oldmem(iter, tsz, &start,
 					cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 			if (tmp < 0)
 				return tmp;
--- a/include/linux/crash_dump.h~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/include/linux/crash_dump.h
@@ -134,13 +134,11 @@ static inline int vmcore_add_device_dump
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 
 #ifdef CONFIG_PROC_VMCORE
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted);
+ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
+			 u64 *ppos, bool encrypted);
 #else
-static inline ssize_t read_from_oldmem(char *buf, size_t count,
-				       u64 *ppos, int userbuf,
-				       bool encrypted)
+static inline ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
+				       u64 *ppos, bool encrypted)
 {
 	return -EOPNOTSUPP;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch


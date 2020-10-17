Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6E2C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7C2208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975847;
	bh=HWUl5jzSi1ndDlvgKx3mfwIhfCipw7yDcCFq+wfQLgI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=N6dFsRRDGDexoejE4UzpS586wK2PFHmqXp13nCQWJXFcN3y+h+L4QqEqml31qhaLo
	 iqrb9Vpksi39CxtYg3VpuScNAhv2aij67FWVaXgx+EZn2wQBz9gR2DVTcwgOZGfNCg
	 XXD2HOvgOzMmjKDuZZydkOKHDFURYIaPkUvEDIOk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439096AbgJQXEG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0FE920878;
        Sat, 17 Oct 2020 23:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975846;
        bh=HWUl5jzSi1ndDlvgKx3mfwIhfCipw7yDcCFq+wfQLgI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ojqu2lRST+wi4rc+tTv6Zby/gIb5ZuDUjhYIG7aBz/UBKVUglDV/l8NxfvKdEq463
         Pz+mO4Je9wqPphvV1jHknmZ/DNcMPFSBz/gGHJG9WJv9p8srvoZxIgRD0mOBFsIeW6
         rUE0k6dWr5LYg7sksPp9LklnEn5Kri12D46q24eg=
Date:   Sat, 17 Oct 2020 16:04:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     fw@deneb.enyo.de, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix.patch?= removed from -mm tree
Message-ID: <20201017230405.bWq3KoV5i%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix

make process_madvise() vlen arg have type size_t, per Florian

Cc: Minchan Kim <minchan@kernel.org>
Cc: Florian Weimer <fw@deneb.enyo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    2 +-
 mm/madvise.c             |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/syscalls.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
+++ a/include/linux/syscalls.h
@@ -880,7 +880,7 @@ asmlinkage long sys_mincore(unsigned lon
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
 asmlinkage long sys_process_madvise(int pidfd, const struct iovec __user *vec,
-			unsigned long vlen, int behavior, unsigned int flags);
+			size_t vlen, int behavior, unsigned int flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
+++ a/mm/madvise.c
@@ -1232,7 +1232,7 @@ put_pid:
 	return ret;
 }
 
-static inline int madv_import_iovec(int type, const struct iovec __user *uvec, unsigned int nr_segs,
+static inline int madv_import_iovec(int type, const struct iovec __user *uvec, size_t nr_segs,
 		unsigned int fast_segs, struct iovec **iov, struct iov_iter *i)
 {
 #ifdef CONFIG_COMPAT
@@ -1245,7 +1245,7 @@ static inline int madv_import_iovec(int
 }
 
 SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
-		unsigned long, vlen, int, behavior, unsigned int, flags)
+		size_t, vlen, int, behavior, unsigned int, flags)
 {
 	ssize_t ret;
 	struct iovec iovstack[UIO_FASTIOV];
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch


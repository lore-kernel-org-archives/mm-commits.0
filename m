Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037B4C31E49
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D4302542C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599242736;
	bh=ReyH01DVXibzes3JFaHMMTPQatCfpse8lGIyEphOT3s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u0OMa6XvP92BnavBiYp4L9RAJWk2AYV8X2pQgY+qyHPERWpoiIL5b/M1EDNn14CMb
	 2xQtXJS2gFgDuew9YLxZDmHJZst42SDPhmfkMr1e8bbQGsDihYM48FzjpmSuZ5zT1i
	 p3ow7ZU7yX23szukDCG7POZpNBQ2Mo7YnFwK0Lk0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgIDSFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgIDSF3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:05:29 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916E62166E;
        Fri,  4 Sep 2020 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599240444;
        bh=ReyH01DVXibzes3JFaHMMTPQatCfpse8lGIyEphOT3s=;
        h=Date:From:To:Subject:From;
        b=jo1G2c2Tjm+X3E4w9KG0IBn0q2orxOaTEYQ/CsWOwXrAPJ6qaDSQb9GiA00BTplkM
         cORaTqRcTXEXTIUOxtF1GhI4g3EdlW1G7U6X5w/6XKoA0eGYhgeGk2kI7xbAUu3Ms9
         aeMVxt4t+0fYccvXuriSu3M5n5D9cOSqmdvdbvsg=
Date:   Fri, 04 Sep 2020 10:27:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, fw@deneb.enyo.de, minchan@kernel.org
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix.patch?= added to -mm tree
Message-ID: <20200904172720.D7vgl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1225,7 +1225,7 @@ put_pid:
 	return ret;
 }
 
-static inline int madv_import_iovec(int type, const struct iovec __user *uvec, unsigned int nr_segs,
+static inline int madv_import_iovec(int type, const struct iovec __user *uvec, size_t nr_segs,
 		unsigned int fast_segs, struct iovec **iov, struct iov_iter *i)
 {
 #ifdef CONFIG_COMPAT
@@ -1238,7 +1238,7 @@ static inline int madv_import_iovec(int
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
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch


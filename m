Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71704C56202
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15D662083E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iP1gxvXA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgKYXZc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731392AbgKYXZc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 18:25:32 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A364207BC;
        Wed, 25 Nov 2020 23:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606346731;
        bh=OXwiOoOJvMvwcTHA7Q07V4qlRvRcOoLldKIYdGWYVzU=;
        h=Date:From:To:Subject:From;
        b=iP1gxvXAB/iJUIF7RvafSw4p54HqWyig9v0b8xDg2NhDEHubTwBvLY8LyM7jlLvED
         5tnbD2de0RTsWBBXkABECAgHHFL17DpwSrutyEEbsVLEsqyUneeqor2u69KCDgJCbG
         U9V68S5nsj8L/4u2Tx4YoZLuldHybId56fPFcUQ4=
Date:   Wed, 25 Nov 2020 15:25:30 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andreyknvl@google.com,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, ebiederm@xmission.com, elver@google.com,
        glider@google.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [to-be-updated]
 proc-use-untagged_addr-for-pagemap_read-addresses.patch removed from -mm
 tree
Message-ID: <20201125232530.zPBaC4gfs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use untagged_addr() for pagemap_read addresses
has been removed from the -mm tree.  Its filename was
     proc-use-untagged_addr-for-pagemap_read-addresses.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: proc: use untagged_addr() for pagemap_read addresses

When we try to visit the pagemap of a tagged userspace pointer, we find
that the start_vaddr is not correct because of the tag.
To fix it, we should untag the usespace pointers in pagemap_read().

I tested with 5.10-rc4 and the issue remains.

My test code is baed on [1]:

A userspace pointer which has been tagged by 0xb4: 0xb400007662f541c8

=== userspace program ===

uint64 OsLayer::VirtualToPhysical(void *vaddr) {
	uint64 frame, paddr, pfnmask, pagemask;
	int pagesize = sysconf(_SC_PAGESIZE);
	off64_t off = ((uintptr_t)vaddr) / pagesize * 8; // off = 0xb400007662f541c8 / pagesize * 8 = 0x5a00003b317aa0
	int fd = open(kPagemapPath, O_RDONLY);
	...

	if (lseek64(fd, off, SEEK_SET) != off || read(fd, &frame, 8) != 8) {
		int err = errno;
		string errtxt = ErrorString(err);
		if (fd >= 0)
			close(fd);
		return 0;
	}
...
}

=== kernel fs/proc/task_mmu.c ===

static ssize_t pagemap_read(struct file *file, char __user *buf,
		size_t count, loff_t *ppos)
{
	...
	src = *ppos;
	svpfn = src / PM_ENTRY_BYTES; // svpfn == 0xb400007662f54
	start_vaddr = svpfn << PAGE_SHIFT; // start_vaddr == 0xb400007662f54000
	end_vaddr = mm->task_size;

	/* watch out for wraparound */
	// svpfn == 0xb400007662f54
	// (mm->task_size >> PAGE) == 0x8000000
	if (svpfn > mm->task_size >> PAGE_SHIFT) // the condition is true because of the tag 0xb4
		start_vaddr = end_vaddr;

	ret = 0;
	while (count && (start_vaddr < end_vaddr)) { // we cannot visit correct entry because start_vaddr is set to end_vaddr
		int len;
		unsigned long end;
		...
	}
	...
}

[1] https://github.com/stressapptest/stressapptest/blob/master/src/os.cc#L158

Link: https://lkml.kernel.org/r/20201123063835.18981-1-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-use-untagged_addr-for-pagemap_read-addresses
+++ a/fs/proc/task_mmu.c
@@ -1599,11 +1599,11 @@ static ssize_t pagemap_read(struct file
 
 	src = *ppos;
 	svpfn = src / PM_ENTRY_BYTES;
-	start_vaddr = svpfn << PAGE_SHIFT;
+	start_vaddr = untagged_addr(svpfn << PAGE_SHIFT);
 	end_vaddr = mm->task_size;
 
 	/* watch out for wraparound */
-	if (svpfn > mm->task_size >> PAGE_SHIFT)
+	if (start_vaddr > mm->task_size)
 		start_vaddr = end_vaddr;
 
 	/*
_

Patches currently in -mm which might be from miles.chen@mediatek.com are



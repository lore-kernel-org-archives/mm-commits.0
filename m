Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE93C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFB260F6B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhJFAX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 20:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236953AbhJFAX1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 20:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8568061130;
        Wed,  6 Oct 2021 00:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633479696;
        bh=DmN+aRv7tnwPQBpkv6S1uzVN5oEOP8NxKqgon033h8Y=;
        h=Date:From:To:Subject:From;
        b=Z1SkYzESNzAsJVv9BNC2SSnRs12rwiB/X3w6PrvLTRPWndzUWNbBxWeYFAxv53pc5
         ELBio4AQOCG9I2AI9LVi6T0YfVAKmIwzhSueDcQH9z77pSz8nQnns7/jOM9AXCfeWd
         gw5rZ1VVWfAOw6v9P5ZKCrkt8cwxsDTIrwhQHC7A=
Date:   Tue, 05 Oct 2021 17:21:36 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  +
 elf-fix-overflow-in-total-mapping-size-calculation.patch added to -mm tree
Message-ID: <20211006002136.jm0YH3WLq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF: fix overflow in total mapping size calculation
has been added to the -mm tree.  Its filename is
     elf-fix-overflow-in-total-mapping-size-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/elf-fix-overflow-in-total-mapping-size-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/elf-fix-overflow-in-total-mapping-size-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF: fix overflow in total mapping size calculation

Kernel assumes that ELF program headers are ordered by mapping address,
but doesn't enforce it.  It is possible to make mapping size extremely
huge by simply shuffling first and last PT_LOAD segments.

As long as PT_LOAD segments do not overlap, it is silly to require sorting
by v_addr anyway because mmap() doesn't care.

Don't assume PT_LOAD segments are sorted and calculate min and max
addresses correctly.

Link: https://lkml.kernel.org/r/YVmd7D0M6G/DcP4O@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/fs/binfmt_elf.c~elf-fix-overflow-in-total-mapping-size-calculation
+++ a/fs/binfmt_elf.c
@@ -93,7 +93,7 @@ static int elf_core_dump(struct coredump
 #define ELF_CORE_EFLAGS	0
 #endif
 
-#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
+#define ELF_PAGESTART(_v) ((_v) & ~(int)(ELF_MIN_ALIGN-1))
 #define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
 
@@ -399,22 +399,21 @@ static unsigned long elf_map(struct file
 	return(map_addr);
 }
 
-static unsigned long total_mapping_size(const struct elf_phdr *cmds, int nr)
+static unsigned long total_mapping_size(const struct elf_phdr *phdr, int nr)
 {
-	int i, first_idx = -1, last_idx = -1;
+	elf_addr_t min_addr = -1;
+	elf_addr_t max_addr = 0;
+	bool pt_load = false;
+	int i;
 
 	for (i = 0; i < nr; i++) {
-		if (cmds[i].p_type == PT_LOAD) {
-			last_idx = i;
-			if (first_idx == -1)
-				first_idx = i;
+		if (phdr[i].p_type == PT_LOAD) {
+			min_addr = min(min_addr, ELF_PAGESTART(phdr[i].p_vaddr));
+			max_addr = max(max_addr, phdr[i].p_vaddr + phdr[i].p_memsz);
+			pt_load = true;
 		}
 	}
-	if (first_idx == -1)
-		return 0;
-
-	return cmds[last_idx].p_vaddr + cmds[last_idx].p_memsz -
-				ELF_PAGESTART(cmds[first_idx].p_vaddr);
+	return pt_load ? (max_addr - min_addr) : 0;
 }
 
 static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-uninline-simple_strntoull-as-well.patch
elf-fix-overflow-in-total-mapping-size-calculation.patch


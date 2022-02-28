Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE5FC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiB1C6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiB1C6r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEC031203
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 383B160EBD
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92101C340E9;
        Mon, 28 Feb 2022 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017087;
        bh=3GwKLCzD9B7n4tV6GHVRybI0uujQfFcqrhFV0684pXE=;
        h=Date:To:From:Subject:From;
        b=rck7oll8DiBNPgBtZ6asDtenKhOQ/8U3WEIpt5m57t5Ev3iJrHs3YLtxFaGX7J8V3
         4gQ/vUMxX+ONj3zy4B7zAw45rrC+3cvbEHoySyapGy9yTEbExxRaT4ogEe06JXPZkU
         gmH8rmFeQ3wtzBUunHGZymuOTXg0JvCx6BPFSV+M=
Date:   Sun, 27 Feb 2022 18:58:07 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        magnus.gross@rwth-aachen.de, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] elf-fix-overflow-in-total-mapping-size-calculation.patch removed from -mm tree
Message-Id: <20220228025807.92101C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF: fix overflow in total mapping size calculation
has been removed from the -mm tree.  Its filename was
     elf-fix-overflow-in-total-mapping-size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Link: https://lore.kernel.org/all/YVmd7D0M6G/DcP4O@localhost.localdomain/
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Magnus Groß <magnus.gross@rwth-aachen.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
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



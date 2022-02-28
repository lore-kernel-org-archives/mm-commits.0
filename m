Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD0AC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiB1C6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiB1C6p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3A830F72
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4592D60EBE
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E3DC340E9;
        Mon, 28 Feb 2022 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017086;
        bh=tVom3K4VJIBP4THbDsdqShuy+WXbnW6C/n3aMIb4W7k=;
        h=Date:To:From:Subject:From;
        b=2ZBVlFVZ3ef5onjzqI0pI0hiTjgwWFciIVaa5CnFj00EMe5LUoDzaA4qer0tGjJLv
         bybKqzLkCbWnnsXqKFR/Nhu861Fznd583S6z2a3z5uLsXRaTuzlGEhzg+hfodCYhKF
         jMjySTOUr4WcWpn4znMQK1swXCQdVLz+VD5pZV6M=
Date:   Sun, 27 Feb 2022 18:58:06 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        lukas.bulwahn@gmail.com, lkp@intel.com, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com, akirakawata1@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-binfmt_elf-refactor-load_elf_binary-function.patch removed from -mm tree
Message-Id: <20220228025806.97E3DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: refactor load_elf_binary function
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-refactor-load_elf_binary-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akira Kawata <akirakawata1@gmail.com>
Subject: fs/binfmt_elf: refactor load_elf_binary function

I delete load_addr because it is not used anymore.  And I rename
load_addr_set to first_pt_load because it is used only to capture the
first iteration of the loop.

Link: https://lkml.kernel.org/r/20211212232414.1402199-3-akirakawata1@gmail.com
Signed-off-by: Akira Kawata <akirakawata1@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-refactor-load_elf_binary-function
+++ a/fs/binfmt_elf.c
@@ -823,8 +823,8 @@ static int parse_elf_properties(struct f
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
-	unsigned long load_addr, load_bias = 0, phdr_addr = 0;
-	int load_addr_set = 0;
+	unsigned long load_bias = 0, phdr_addr = 0;
+	int first_pt_load = 1;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
 	struct elf_phdr *elf_property_phdata = NULL;
@@ -1074,12 +1074,12 @@ out_free_interp:
 
 		vaddr = elf_ppnt->p_vaddr;
 		/*
-		 * The first time through the loop, load_addr_set is false:
+		 * The first time through the loop, first_pt_load is true:
 		 * layout will be calculated. Once set, use MAP_FIXED since
 		 * we know we've already safely mapped the entire region with
 		 * MAP_FIXED_NOREPLACE in the once-per-binary logic following.
 		 */
-		if (load_addr_set) {
+		if (!first_pt_load) {
 			elf_flags |= MAP_FIXED;
 		} else if (elf_ex->e_type == ET_EXEC) {
 			/*
@@ -1139,10 +1139,10 @@ out_free_interp:
 
 		/*
 		 * Calculate the entire size of the ELF mapping (total_size).
-		 * (Note that load_addr_set is set to true later once the
+		 * (Note that first_pt_load is set to false later once the
 		 * initial mapping is performed.)
 		 */
-		if (!load_addr_set) {
+		if (first_pt_load) {
 			total_size = total_mapping_size(elf_phdata,
 							elf_ex->e_phnum);
 			if (!total_size) {
@@ -1159,13 +1159,11 @@ out_free_interp:
 			goto out_free_dentry;
 		}
 
-		if (!load_addr_set) {
-			load_addr_set = 1;
-			load_addr = (elf_ppnt->p_vaddr - elf_ppnt->p_offset);
+		if (first_pt_load) {
+			first_pt_load = 0;
 			if (elf_ex->e_type == ET_DYN) {
 				load_bias += error -
 				             ELF_PAGESTART(load_bias + vaddr);
-				load_addr += load_bias;
 				reloc_func_desc = load_bias;
 			}
 		}
_

Patches currently in -mm which might be from akirakawata1@gmail.com are



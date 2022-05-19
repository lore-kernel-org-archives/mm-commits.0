Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DF1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbiESRik (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbiESRih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:38:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1CB64737
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:38:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79F7D618B6
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEFCC385AA;
        Thu, 19 May 2022 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652981915;
        bh=G4mUCoZYN5OZJ0V6CGPbnPBO4llghdbL/bpMFnk+6og=;
        h=Date:To:From:Subject:From;
        b=EwWePKiXoXgUaoEpfpUXOzQ/n0C3uYCLo+TGdeNYx3PAvoeViqz3VLpHZ8ArM/AXo
         hzo7WnRX7fM8j61Bx6SPYC5LPeQ8A2kRTR4AC+X7cJnZ61ziKt6WyI3XodrkC17r+N
         wDAe3cx+XIJKLF26OAkHHhKM+L54e4l/A21OB8No=
Date:   Thu, 19 May 2022 10:38:35 -0700
To:     mm-commits@vger.kernel.org, stephen.s.brennan@oracle.com,
        len.baker@gmx.com, gustavoars@kernel.org, dhowells@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] assoc_array-fix-bug_on-during-garbage-collect-fix.patch removed from -mm tree
Message-Id: <20220519173835.CFEFCC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: assoc_array-fix-bug_on-during-garbage-collect-fix
has been removed from the -mm tree.  Its filename was
     assoc_array-fix-bug_on-during-garbage-collect-fix.patch

This patch was dropped because it was folded into assoc_array-fix-bug_on-during-garbage-collect.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: assoc_array-fix-bug_on-during-garbage-collect-fix

fix typo in printk

Cc: David Howells <dhowells@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Len Baker <len.baker@gmx.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/assoc_array.c~assoc_array-fix-bug_on-during-garbage-collect-fix
+++ a/lib/assoc_array.c
@@ -1610,7 +1610,7 @@ retry_compress:
 	}
 
 	if (retained && new_n->nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT) {
-		pr_devel("internal nodes remain despite neough space, retrying\n");
+		pr_devel("internal nodes remain despite enough space, retrying\n");
 		goto retry_compress;
 	}
 	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


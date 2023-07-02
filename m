Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD0EEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjGBTcG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjGBTcG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:32:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175A2A0;
        Sun,  2 Jul 2023 12:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9058760C78;
        Sun,  2 Jul 2023 19:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CC0C433C8;
        Sun,  2 Jul 2023 19:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688326323;
        bh=rRM6GjMifgftUKvo/+glxJunFuzIr9/DPDhMhOLJaes=;
        h=Date:To:From:Subject:From;
        b=zMww4EQt9AYVynMXOmYsYUE4C8yitGvG9Kpk9Dg8A44BOBM6a2tQzTLbcKdc2fiBz
         +SOjgAmzVdF3YWHRszKaGdiZMAJFn9riu2IdP+BqpXnPWpcUt2IIWvY6/tKnC0Z5cp
         HlOquNZ+DDE01NdMN90LT7P15amtlnulNbUy4ZxE=
Date:   Sun, 02 Jul 2023 12:32:03 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        steven.price@arm.com, stable@vger.kernel.org,
        Qun-wei.Lin@mediatek.com, david@redhat.com,
        catalin.marinas@arm.com, pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-arch_swap_restore-from-do_swap_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230702193203.D1CC0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call arch_swap_restore() from do_swap_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-call-arch_swap_restore-from-do_swap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-arch_swap_restore-from-do_swap_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: call arch_swap_restore() from do_swap_page()
Date: Mon, 22 May 2023 17:43:08 -0700

Commit c145e0b47c77 ("mm: streamline COW logic in do_swap_page()") moved
the call to swap_free() before the call to set_pte_at(), which meant that
the MTE tags could end up being freed before set_pte_at() had a chance to
restore them.  Fix it by adding a call to the arch_swap_restore() hook
before the call to swap_free().

Link: https://lkml.kernel.org/r/20230523004312.1807357-2-pcc@google.com
Link: https://linux-review.googlesource.com/id/I6470efa669e8bd2f841049b8c61020c510678965
Fixes: c145e0b47c77 ("mm: streamline COW logic in do_swap_page()")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Closes: https://lore.kernel.org/all/5050805753ac469e8d727c797c2218a9d780d434.camel@mediatek.com/
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memory.c~mm-call-arch_swap_restore-from-do_swap_page
+++ a/mm/memory.c
@@ -3954,6 +3954,13 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/*
+	 * Some architectures may have to restore extra metadata to the page
+	 * when reading from swap. This metadata may be indexed by swap entry
+	 * so this must be called before swap_free().
+	 */
+	arch_swap_restore(entry, folio);
+
+	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.
_

Patches currently in -mm which might be from pcc@google.com are

mm-call-arch_swap_restore-from-do_swap_page.patch


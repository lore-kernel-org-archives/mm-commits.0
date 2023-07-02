Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE24EEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjGBXOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBXOW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B6C1BC
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E466D60CE8
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35234C433C7;
        Sun,  2 Jul 2023 23:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688339660;
        bh=4/4gr9D1O5h/mykPCbwE7CB+HsVa/irUDpAkIxDnJJw=;
        h=Date:To:From:Subject:From;
        b=Cc2hAORdaB2m9jtnjjkRpE6r4gmkaYw6R2JTgY/C5vrvktwc1wqg23DUC97ThNHJf
         Nla37Yy+AjMh0dAeRSifVnwRcTF19WwvGJ3EQ1BDFjQa+hlaDqmhUKhojvAOewjPXv
         jIbrgJNz9vRSem8WozGG3qCmm/nwdLT0leiS/pRQ=
Date:   Sun, 02 Jul 2023 16:14:19 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-use-helper-function-destroy_memory_type.patch added to mm-unstable branch
Message-Id: <20230702231420.35234C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tier: use helper function destroy_memory_type()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-use-helper-function-destroy_memory_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-use-helper-function-destroy_memory_type.patch

This patch will later appear in the mm-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: use helper function destroy_memory_type()
Date: Mon, 26 Jun 2023 20:10:53 +0800

Use helper function destroy_memory_type() to release memtype instead of
open code it to help improve code readability a bit.  No functional change
intended.

Link: https://lkml.kernel.org/r/20230626121053.1916447-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~memory-tier-use-helper-function-destroy_memory_type
+++ a/mm/memory-tiers.c
@@ -586,7 +586,7 @@ void clear_node_memory_type(int node, st
 	 */
 	if (!node_memory_types[node].map_count) {
 		node_memory_types[node].memtype = NULL;
-		kref_put(&memtype->kref, release_memtype);
+		destroy_memory_type(memtype);
 	}
 	mutex_unlock(&memory_tier_lock);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch


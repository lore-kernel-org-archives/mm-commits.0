Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423ABE7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbjJDUSH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243998AbjJDUSG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742ADE5
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60D9C433C8;
        Wed,  4 Oct 2023 20:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450682;
        bh=3X4mq1fQYaJfTrRKncTXbMTAIiPUqTxY2SaxTqpSDIA=;
        h=Date:To:From:Subject:From;
        b=HzQQgla+iY3WZ5pXNoGMU0IgLYjWHtq55fKiHDCHefsve+rl2AmQeUAwZUljCuMV2
         pb0TTzyffnhtHX352YTy5IO9P6AL3Z6m28AUvvBU9WSu5fP1pGFnSVicPluHBh0rJ/
         WS6aCY2uaxHhF+9ACVmN+axsKD/JEBQT96S0oGRI=
Date:   Wed, 04 Oct 2023 13:18:00 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch removed from -mm tree
Message-Id: <20231004201801.B60D9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: fix failure case when new remap region was not found
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: selftests: mm: fix failure case when new remap region was not found
Date: Sun, 3 Sep 2023 15:13:24 +0000

When a valid remap region could not be found, the source mapping is not
cleaned up.  Fix the goto statement such that the clean up happens.

Link: https://lkml.kernel.org/r/20230903151328.2981432-4-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-failure-case-when-new-remap-region-was-not-found
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -316,7 +316,7 @@ static long long remap_region(struct con
 		if (addr + c.dest_alignment < addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
-			goto out;
+			goto clean_up_src;
 		}
 		addr += c.dest_alignment;
 	}
_

Patches currently in -mm which might be from joel@joelfernandes.org are



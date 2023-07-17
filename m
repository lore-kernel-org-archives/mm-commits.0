Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C8AC001DE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 19:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjGQTyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjGQTyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 15:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550EC126;
        Mon, 17 Jul 2023 12:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC98061236;
        Mon, 17 Jul 2023 19:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BCAC433C7;
        Mon, 17 Jul 2023 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689623640;
        bh=QRhfPXmcF28k3GR/75K5XHvvkEZPXSsXoMy50F5YT9g=;
        h=Date:To:From:Subject:From;
        b=Xa5A4fB+8qUl9B6VF7asfMaeQ/7yO9sB1ZYVjbMX0R/uZOzFxOCDKoQSGeNa7RAs3
         mfe5bnFpZTXlIXowBYDjOxXST7rrm0vzAvdh67BW9O4m1y970GAOeC4u251WikI25N
         b4ZBj83ocxDv9qHNQASBAvekdjiLAop3yjzbuKY0=
Date:   Mon, 17 Jul 2023 12:53:59 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        geert@linux-m68k.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-32-bit-mas_next-testing.patch removed from -mm tree
Message-Id: <20230717195400.42BCAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix 32 bit mas_next testing
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-32-bit-mas_next-testing.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix 32 bit mas_next testing
Date: Wed, 12 Jul 2023 13:39:15 -0400

The test setup of mas_next is dependent on node entry size to create a 2
level tree, but the tests did not account for this in the expected value
when shifting beyond the scope of the tree.

Fix this by setting up the test to succeed depending on the node entries
which is dependent on the 32/64 bit setup.

Link: https://lkml.kernel.org/r/20230712173916.168805-1-Liam.Howlett@oracle.com
Fixes: 120b116208a0 ("maple_tree: reorganize testing to restore module testing")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
  Closes: https://lore.kernel.org/linux-mm/CAMuHMdV4T53fOw7VPoBgPR7fP6RYqf=CBhD_y_vOg53zZX_DnA@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/test_maple_tree.c~maple_tree-fix-32-bit-mas_next-testing
+++ a/lib/test_maple_tree.c
@@ -1898,13 +1898,16 @@ static noinline void __init next_prev_te
 						   725};
 	static const unsigned long level2_32[] = { 1747, 2000, 1750, 1755,
 						   1760, 1765};
+	unsigned long last_index;
 
 	if (MAPLE_32BIT) {
 		nr_entries = 500;
 		level2 = level2_32;
+		last_index = 0x138e;
 	} else {
 		nr_entries = 200;
 		level2 = level2_64;
+		last_index = 0x7d6;
 	}
 
 	for (i = 0; i <= nr_entries; i++)
@@ -2011,7 +2014,7 @@ static noinline void __init next_prev_te
 
 	val = mas_next(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, val != NULL);
-	MT_BUG_ON(mt, mas.index != 0x7d6);
+	MT_BUG_ON(mt, mas.index != last_index);
 	MT_BUG_ON(mt, mas.last != ULONG_MAX);
 
 	val = mas_prev(&mas, 0);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch


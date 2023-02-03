Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22689C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjBCGwP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjBCGva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF588D616
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F85FB8298A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15634C433D2;
        Fri,  3 Feb 2023 06:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407078;
        bh=b+CCqjClbyGmKwsbO0QY6kCshl/8MLw+bHY69wL+NNQ=;
        h=Date:To:From:Subject:From;
        b=PPO+zuNHYBr4CD2STLMeqIwtYFe30KVY5h8nL2exaeLVq7o+ck3/JyEP5rrIqDFxy
         1lPx5h1u+39I4FNEbKWWkXzbuMlRRbTlq1U+mcLl+L8edqeKKSz2YT3v104mH6kLE9
         us7UuMlNHVOrRlfkS5FjVsv5QJiweg3+JCxto7h0=
Date:   Thu, 02 Feb 2023 22:51:17 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch removed from -mm tree
Message-Id: <20230203065118.15634C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ext4: use try_cmpxchg in ext4_update_bh_state
has been removed from the -mm tree.  Its filename was
     fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: fs/ext4: use try_cmpxchg in ext4_update_bh_state
Date: Wed, 2 Nov 2022 08:11:47 +0100

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
ext4_update_bh_state.  x86 CMPXCHG instruction returns success in ZF flag,
so this change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails.  There is no need to re-read the value in the loop.

No functional change intended.

Link: https://lkml.kernel.org/r/20221102071147.6642-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ext4/inode.c~fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state
+++ a/fs/ext4/inode.c
@@ -786,11 +786,10 @@ static void ext4_update_bh_state(struct
 	 * once we get rid of using bh as a container for mapping information
 	 * to pass to / from get_block functions, this can go away.
 	 */
+	old_state = READ_ONCE(bh->b_state);
 	do {
-		old_state = READ_ONCE(bh->b_state);
 		new_state = (old_state & ~EXT4_MAP_FLAGS) | flags;
-	} while (unlikely(
-		 cmpxchg(&bh->b_state, old_state, new_state) != old_state));
+	} while (unlikely(!try_cmpxchg(&bh->b_state, &old_state, new_state)));
 }
 
 static int _ext4_get_block(struct inode *inode, sector_t iblock,
_

Patches currently in -mm which might be from ubizjak@gmail.com are



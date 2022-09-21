Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64463C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiIUTaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUTaH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:30:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43D8B2D3
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1840CB8325E
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571CAC433C1;
        Wed, 21 Sep 2022 19:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663788602;
        bh=RDVV8LI8C7cpGXNpAj7w17J1TifkVcxZ6da8ghKhzwY=;
        h=Date:To:From:Subject:From;
        b=BHRQ/E1w3pccmxdabhCLDKaxZp4zQ3opnRBwa6MSBLnstWjt6SGMKCY4bDA/MzB/C
         G/bccFDPros+psEuElJMjnp5xDv9N8GREMAvaCNyp6PxznF7w4R23deoFQlGF7MRK/
         yJdjHZyAIj9kbSEikb49tzVOQmKBE29EfV8XqvAQ=
Date:   Wed, 21 Sep 2022 12:30:00 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        konishi.ryusuke@gmail.com, chi.minghao@zte.com.cn,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-the-unneeded-result-variable.patch added to mm-nonmm-unstable branch
Message-Id: <20220921193002.571CAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: Remove the unneeded result variable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-the-unneeded-result-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-the-unneeded-result-variable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: nilfs2: Remove the unneeded result variable
Date: Wed, 21 Sep 2022 12:48:03 +0900

Return the value nilfs_segctor_sync() directly instead of storing it in
another redundant variable.

Link: https://lkml.kernel.org/r/20220831033403.302184-1-ye.xingchen@zte.com.cn
Link: https://lkml.kernel.org/r/20220921034803.2476-3-konishi.ryusuke@gmail.com
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/segment.c~nilfs2-remove-the-unneeded-result-variable
+++ a/fs/nilfs2/segment.c
@@ -2235,7 +2235,6 @@ int nilfs_construct_segment(struct super
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
-	int err;
 
 	if (!sci)
 		return -EROFS;
@@ -2243,8 +2242,7 @@ int nilfs_construct_segment(struct super
 	/* A call inside transactions causes a deadlock. */
 	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
 
-	err = nilfs_segctor_sync(sci);
-	return err;
+	return nilfs_segctor_sync(sci);
 }
 
 /**
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are

nilfs2-remove-the-unneeded-result-variable.patch


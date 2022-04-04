Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D837C4167D
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiDDVlM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380164AbiDDTIH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 15:08:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16E6344E8
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 12:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48BE960AFD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 19:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969FDC340F3;
        Mon,  4 Apr 2022 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649099169;
        bh=8FnKKJR1a+ruAQWIIPXHEMY7g/RxFntBIjeUhXXWSEU=;
        h=Date:To:From:Subject:From;
        b=RKoMQh7d2KS+AAnCiKTR8BL2ogucn66Uq4V19fQ+kZ2HF+yRsCdp4RrC1fkolelFz
         2ymk7L0bpHQB7NbSfUFrK2QZS3REeLz6uhAhpyIW3bXnDgrm4dlsERxavvfz5WXfBp
         5IAapLx9oF4K9VIeXySo3iTHvg2mJTR38pyZE+SQ=
Date:   Mon, 04 Apr 2022 12:06:08 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch added to -mm tree
Message-Id: <20220404190609.969FDC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: sysv: check sbi->s_firstdatazone in complete_read_super
has been added to the -mm tree.  Its filename is
     fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: fs: sysv: check sbi->s_firstdatazone in complete_read_super

sbi->s_firstinodezone is initialized to 2 and sbi->s_firstdatazone is read
from sbd.  There's no guarantee that sbi->s_firstdatazone must bigger than
sbi->s_firstinodezone.  If sbi->s_firstdatazone less than 2, the
filesystem can still be mounted unexpetly.  At this point, sbi->s_ninodes
flip to very large value and this filesystem is broken.  We can observe
this by executing 'df' command.  When we execute, we will get an error
message:

	"sysv_count_free_inodes: unable to read inode table"

Link: https://lkml.kernel.org/r/20220330104215.530223-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/sysv/super.c~fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super
+++ a/fs/sysv/super.c
@@ -312,7 +312,9 @@ static int complete_read_super(struct su
 	sbi->s_firstinodezone = 2;
 
 	flavour_setup[sbi->s_type](sbi, &sb->s_max_links);
-	
+	if (sbi->s_firstdatazone < sbi->s_firstinodezone)
+		return 0;
+
 	sbi->s_ndatazones = sbi->s_nzones - sbi->s_firstdatazone;
 	sbi->s_inodes_per_block = bsize >> 6;
 	sbi->s_inodes_per_block_1 = (bsize >> 6)-1;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch


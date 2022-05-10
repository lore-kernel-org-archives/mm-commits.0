Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F3CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiEJEZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiEJEXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30191CC9AC
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B253B81B08
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39FC385C5;
        Tue, 10 May 2022 04:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156279;
        bh=BjvesEEsG1fEphqDigiG3bH05POMTX6Q4nOuXom17fo=;
        h=Date:To:From:Subject:From;
        b=fCWeGanyGf1vRwmrlN9PCIoyzD1K2XG39lCAbq1KBBIeJOR6kCGvYFmMeHJ+7U0kZ
         CeDrP3DlMWbDcZwVfNp+bTAA/gnxe7LHFWRFDcYe12DYezk7c9tLD5TL2krVyWhAl4
         BkXLXjZXpwX+McUQyGvZETiJrMazVWSXPAaL/+GY=
Date:   Mon, 09 May 2022 21:17:58 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch removed from -mm tree
Message-Id: <20220510041759.0A39FC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: sysv: check sbi->s_firstdatazone in complete_read_super
has been removed from the -mm tree.  Its filename was
     fs-sysv-check-sbi-s_firstdatazone-in-complete_read_super.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



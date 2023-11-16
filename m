Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366A8C197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjKPVsY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjKPVsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:48:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431FE11F
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:48:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1413C433C7;
        Thu, 16 Nov 2023 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700171300;
        bh=gJjhSIxQSq7jGkGomjgnrOwSL0DvACjqey3xOLXAuuU=;
        h=Date:To:From:Subject:From;
        b=Lyd464HPPRS9epSXLFYTHCusH6xmGr9WyR328ky/KXI6gE1B4ARRAyOq+Uyw0o+HQ
         qlDxw1NDtKndWvpW9Aav5u9zRa6MNxU3+4kSOkF69azWo8LWTkBgni15UkVFcbPZRf
         0p8Ricj0t850oRzhRErsfQnLleDVhQ0MItXzPavQ=
Date:   Thu, 16 Nov 2023 13:48:20 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        lizhi.xu@windriver.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116214820.D1413C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: squashfs_read_data need to check if the length is 0
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch

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
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: squashfs: squashfs_read_data need to check if the length is 0
Date: Thu, 16 Nov 2023 11:13:52 +0800

When the length passed in is 0, the pagemap_scan_test_walk() caller should
bail.  This error causes at least a WARN_ON().

Link: https://lkml.kernel.org/r/20231116031352.40853-1-lizhi.xu@windriver.com
Reported-by: syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000000526f2060a30a085@google.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-squashfs_read_data-need-to-check-if-the-length-is-0
+++ a/fs/squashfs/block.c
@@ -321,7 +321,7 @@ int squashfs_read_data(struct super_bloc
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
-	if (length < 0 || length > output->length ||
+	if (length <= 0 || length > output->length ||
 			(index + length) > msblk->bytes_used) {
 		res = -EIO;
 		goto out;
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are

squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch


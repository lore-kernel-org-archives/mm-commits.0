Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AACDECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 21:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiHaVt2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 17:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiHaVtS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 17:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62422F72F5
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 14:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1476CB8238B
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 21:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F74C433C1;
        Wed, 31 Aug 2022 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661982554;
        bh=CW5Vc3IAWUpLml318ykeGlTC2aqMjZpizpquKD0Abcg=;
        h=Date:To:From:Subject:From;
        b=fpQEmh9gGbhgmnIHRG3iJpF5kanqZDC+4x5PGOF7heN9DtBaCXYj3lE/gSXXO0daZ
         Uq3qQng9fXtQKEbLoFk+W+EIRCtkQX5jRHspmgpyuzbHQiKYbTNBrstb2/iefk52TA
         teGZD+U7BM5Qazqn+DDVINtqNYuqMO6VlF1ZO/Dk=
Date:   Wed, 31 Aug 2022 14:49:14 -0700
To:     mm-commits@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        dan.carpenter@oracle.com, chenxiaosong2@huawei.com,
        anton@tuxera.com, yin31149@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-check-overflow-when-iterates-attr_records.patch added to mm-nonmm-unstable branch
Message-Id: <20220831214914.B0F74C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: check overflow when iterating ATTR_RECORDs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ntfs-check-overflow-when-iterates-attr_records.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-check-overflow-when-iterates-attr_records.patch

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
From: Hawkins Jiawei <yin31149@gmail.com>
Subject: ntfs: check overflow when iterating ATTR_RECORDs
Date: Thu, 1 Sep 2022 00:09:38 +0800

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find(). 
Because the ATTR_RECORDs are next to each other, kernel can get the next
ATTR_RECORD from end address of current ATTR_RECORD, through current
ATTR_RECORD length field.

The problem is that during iteration, when kernel calculates the end
address of current ATTR_RECORD, kernel may trigger an integer overflow bug
in executing `a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))`.  This
may wrap, leading to a forever iteration on 32bit systems.

This patch solves it by adding some checks on calculating end address
of current ATTR_RECORD during iteration.

Link: https://lkml.kernel.org/r/20220831160935.3409-4-yin31149@gmail.com
Link: https://lore.kernel.org/all/20220827105842.GM2030@kadam/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: chenxiaosong (A) <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ntfs/attrib.c~ntfs-check-overflow-when-iterates-attr_records
+++ a/fs/ntfs/attrib.c
@@ -617,6 +617,14 @@ static int ntfs_attr_find(const ATTR_TYP
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*
_

Patches currently in -mm which might be from yin31149@gmail.com are

ntfs-fix-use-after-free-in-ntfs_attr_find.patch
ntfs-fix-out-of-bounds-read-in-ntfs_attr_find.patch
ntfs-check-overflow-when-iterates-attr_records.patch


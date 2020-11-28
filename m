Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C315C3E8C5
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EF52075E
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pnrnlAcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgK1CMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbgK1CKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:10:07 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF1E2224E;
        Sat, 28 Nov 2020 02:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529330;
        bh=Q7nq7Jg6VvdZxR9pqQmNqPwy7KsZvxDJ2oxbJHDcl74=;
        h=Date:From:To:Subject:From;
        b=pnrnlAcyOwj8T9kPR4Ou2pAyZ85hFJGY4NpR4x77kc46HovrjEGthaRcnY0gw8Cl9
         1usXYw3e8wCpBi+p3vZhcDiVvTLPyOP5pCYGVrLeX9OULMFmiPK2CmM0DXdmdEI5V4
         GtmGoypT42ZyjvVbjNGVxlc12WLFq5d8WcslAwRk=
Date:   Fri, 27 Nov 2020 18:08:50 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mm-commits@vger.kernel.org, rkovhaev@gmail.com
Subject:  [merged]
 reiserfs-add-check-for-an-invalid-ih_entry_count.patch removed from -mm
 tree
Message-ID: <20201128020850.xO-WawmxV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: add check for an invalid ih_entry_count
has been removed from the -mm tree.  Its filename was
     reiserfs-add-check-for-an-invalid-ih_entry_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: reiserfs: add check for an invalid ih_entry_count

When a directory item has an invalid value set for ih_entry_count it might
trigger use-after-free or out-of-bounds read in bin_search_in_dir_item()

ih_entry_count * IH_SIZE for directory item should not be larger than
ih_item_len

Link: https://syzkaller.appspot.com/bug?extid=83b6f7cf9922cae5c4d7
Link: https://lkml.kernel.org/r/20201101140958.3650143-1-rkovhaev@gmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reported-and-tested-by: syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/stree.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/reiserfs/stree.c~reiserfs-add-check-for-an-invalid-ih_entry_count
+++ a/fs/reiserfs/stree.c
@@ -454,6 +454,12 @@ static int is_leaf(char *buf, int blocks
 					 "(second one): %h", ih);
 			return 0;
 		}
+		if (is_direntry_le_ih(ih) && (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE))) {
+			reiserfs_warning(NULL, "reiserfs-5093",
+					 "item entry count seems wrong %h",
+					 ih);
+			return 0;
+		}
 		prev_location = ih_location(ih);
 	}
 
_

Patches currently in -mm which might be from rkovhaev@gmail.com are



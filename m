Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F61C55178
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93918206F8
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459839;
	bh=VJsuWyXtxguqbuyP3D1+MB495A8WvpXoZ5S2HQvJm00=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Zq753pT1vOVd5CPZT58UcxQ5ZoEaBfGPEC6GfNMrzupjiEk5yca8p7+1BWaSGEyvN
	 UrlOpVW+pfS42uooFGtBdfXPyFXDlDThX//3lS5QLuvQ4kMKewtCzKS4IjHQeBvSpi
	 q878wKVu0YndKg8Lvkr1QslofG1lneEtqP1H/Jkw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgKDDRS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbgKDDRR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:17:17 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146AF206DF;
        Wed,  4 Nov 2020 03:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459837;
        bh=VJsuWyXtxguqbuyP3D1+MB495A8WvpXoZ5S2HQvJm00=;
        h=Date:From:To:Subject:From;
        b=e3JTjhJJbnKRkorgg03Y0NCNewGB/mriRQBarR1Zb1qZN+jsRuIeLEHQRpiLOU/rv
         olpnFJMTNdQ5Tp3ddqtqKW4UQj2SG3QdNHWNfSiqkUzeydtJMPwtJqCFF6zkIaqVR+
         kz2Cd6ISqXV57/hG3pnSPmWDx+4zRjehnGmbVuwI=
Date:   Tue, 03 Nov 2020 19:17:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rkovhaev@gmail.com
Subject:  + reiserfs-add-check-for-an-invalid-ih_entry_count.patch
 added to -mm tree
Message-ID: <20201104031716.O0rhn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: add check for an invalid ih_entry_count
has been added to the -mm tree.  Its filename is
     reiserfs-add-check-for-an-invalid-ih_entry_count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reiserfs-add-check-for-an-invalid-ih_entry_count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reiserfs-add-check-for-an-invalid-ih_entry_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: reiserfs: add check for an invalid ih_entry_count

when directory item has an invalid value set for ih_entry_count it might
trigger use-after-free or out-of-bounds read in bin_search_in_dir_item()

ih_entry_count * IH_SIZE for directory item should not be larger than
ih_item_len

Reported-and-tested-by: syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=83b6f7cf9922cae5c4d7
Link: https://lkml.kernel.org/r/20201101140958.3650143-1-rkovhaev@gmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
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

reiserfs-add-check-for-an-invalid-ih_entry_count.patch


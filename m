Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C1BC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9AE20706
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598299324;
	bh=H0nmgMLxCjQdi0nlr6zS4z1okisHTZqn1AzusVqwSkI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XSQf+ulZyeNr/1P/v51nub514jN/qW8mDgW1rQoZzKkd04YDX53XXDVYCVqXa/hAK
	 mmAzTzwBHIShoIij2+vf2UCwG0TyrtJ+azdijFbqh6vK0STjZyWG3wTE68xquDwBYs
	 H1jyWpfe6QgSIXYAxQ/+uUqaj5CJbZfSpoTDq+wU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHXUCE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXUCD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:02:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5DA920656;
        Mon, 24 Aug 2020 20:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598299322;
        bh=H0nmgMLxCjQdi0nlr6zS4z1okisHTZqn1AzusVqwSkI=;
        h=Date:From:To:Subject:From;
        b=q4Fc7HA6B0unqvLLR1yWP9veUQgoNyNDLPwrAl8tBfHQkF4P2ZgS7VV/feOdqr6tL
         UdGONhy2XbS9VCNmaDVfFJvcc4iLLI9mrQ26XQfXO3CCwDRZvJFN3zNdOtUF6YODi5
         ff6O0POc9N5YbFTlg8woTtBgJ6vvmV/cf6n8rptU=
Date:   Mon, 24 Aug 2020 13:02:02 -0700
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, rkovhaev@gmail.com
Subject:  + ntfs-add-check-for-mft-record-size-in-superblock.patch
 added to -mm tree
Message-ID: <20200824200202.AKem0Yyq9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: add check for mft record size in superblock
has been added to the -mm tree.  Its filename is
     ntfs-add-check-for-mft-record-size-in-superblock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-add-check-for-mft-record-size-in-superblock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-add-check-for-mft-record-size-in-superblock.patch

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
Subject: ntfs: add check for mft record size in superblock

Number of bytes allocated for mft record should be equal to the mft record
size stored in ntfs superblock as reported by syzbot, userspace might
trigger out-of-bounds read by dereferencing ctx->attr in ntfs_attr_find()

Link: https://syzkaller.appspot.com/bug?extid=aed06913f36eff9b544e
Link: https://lkml.kernel.org/r/20200824022804.226242-1-rkovhaev@gmail.com
Reported-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Tested-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs/inode.c~ntfs-add-check-for-mft-record-size-in-superblock
+++ a/fs/ntfs/inode.c
@@ -1810,6 +1810,12 @@ int ntfs_read_inode_mount(struct inode *
 		brelse(bh);
 	}
 
+	if (le32_to_cpu(m->bytes_allocated) != vol->mft_record_size) {
+		ntfs_error(sb, "Incorrect mft record size %u in superblock, should be %u.",
+				le32_to_cpu(m->bytes_allocated), vol->mft_record_size);
+		goto err_out;
+	}
+
 	/* Apply the mst fixups. */
 	if (post_read_mst_fixup((NTFS_RECORD*)m, vol->mft_record_size)) {
 		/* FIXME: Try to use the $MFTMirr now. */
_

Patches currently in -mm which might be from rkovhaev@gmail.com are

scripts-tagssh-exclude-tools-directory-from-tags-generation.patch
ntfs-add-check-for-mft-record-size-in-superblock.patch


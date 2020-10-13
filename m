Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE36C43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E17321D7A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632900;
	bh=MG30du+WB4Ja68D+IS+bL1+JBbAJlRHun3Gliqw0jm0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PTYvUeO3WNhIjHOR20IlQNq2oUARn2rpL8zmhnyy+xE2mF9KuFNt9KCAxmdNlvHV1
	 L3rZCKQ9dfNctbfThoUBqZDrzlr065GjRwMmWeX+qxq7voN4C6Fs363QxNSerGnY4d
	 6AlrdExhox0Kq9QqK7rx6FahDfwXgqHUx2L07RzU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbgJMXsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F22C21D7F;
        Tue, 13 Oct 2020 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632898;
        bh=MG30du+WB4Ja68D+IS+bL1+JBbAJlRHun3Gliqw0jm0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a9fXMcyK/Q79fu0Gc6qOJ9KOQG71tr9P3MnGSPx3l88MpPZEA0dGEJp4g4v8DUq19
         s+DtXtrFJbv+fY0g7Sg71gVNQq8+zdQZlj4+lmcT4tjzBoSQwmMmRjwCKQikfdCeXH
         pqUL5yPmk+BgLfAA602GbVGZ5LU9KB37LX8wURfQ=
Date:   Tue, 13 Oct 2020 16:48:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@tuxera.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rkovhaev@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 014/181] ntfs: add check for mft record size in
 superblock
Message-ID: <20201013234817.kgKs7HBdo%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EDFC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC2560C3F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhBEA4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhBEA4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 19:56:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3897E64FAF;
        Fri,  5 Feb 2021 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612486519;
        bh=MJJVq9jOhVXkY5Fmzn/EyEAA8MkVWKXJr33BKF0vLOg=;
        h=Date:From:To:Subject:From;
        b=nfCJyVu/OUB+2KNkJiPWZdmkWzEs5t8jdaKUnkE6hHYAbN0j3LAh2FIpTKnUPkTxT
         uIUjV99D78f76AvR2fX+BrrdzfXE9wKzevKQcuphLOmWZADULVStFdvwrZuIu81QM4
         VvDUv+AGnPDOJfH8wigwZR1k/o5ihI7iEecOz4PQ=
Date:   Thu, 04 Feb 2021 16:55:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        pliard@google.com
Subject:  +
 squashfs-avoid-out-of-bounds-writes-in-decompressors.patch added to -mm
 tree
Message-ID: <20210205005518.6FsRYL98e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: avoid out of bounds writes in decompressors
has been added to the -mm tree.  Its filename is
     squashfs-avoid-out-of-bounds-writes-in-decompressors.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-avoid-out-of-bounds-writes-in-decompressors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: avoid out of bounds writes in decompressors

Patch series "Squashfs: fix BIO migration regression and add sanity checks".

Patch [1/4] fixes a regression introduced by the "migrate from ll_rw_block
usage to BIO" patch, which has produced a number of Sysbot/Syzkaller
reports.

Patches [2/4], [3/4], and [4/4] fix a number of filesystem corruption
issues which have produced Sysbot reports in the id, inode and xattr
lookup code.

Each patch has been tested against the Sysbot reproducers using the given
kernel configuration.  They have the appropriate "Reported-by:" lines
added.

Additionally, all of the reproducer filesystems are indirectly fixed by
patch [4/4] due to the fact they all have xattr corruption which is now
detected there.

Additional testing with other configurations and architectures (32bit, big
endian), and normal filesystems has also been done to trap any inadvertent
regressions caused by the additional sanity checks.


This patch (of 4):

This is a regression introduced by the patch "migrate from ll_rw_block
usage to BIO".

Sysbot/Syskaller has reported a number of "out of bounds writes" and
"unable to handle kernel paging request in squashfs_decompress" errors
which have been identified as a regression introduced by the above patch.

Specifically, the patch removed the following sanity check

if (length < 0 || length > output->length ||
		(index + length) > msblk->bytes_used)

This check did two things:

1. It ensured any reads were not beyond the end of the filesystem

2. It ensured that the "length" field read from the filesystem
   was within the expected maximum length.  Without this any
   corrupted values can over-run allocated buffers.

Link: https://lkml.kernel.org/r/20210204130249.4495-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20210204130249.4495-2-phillip@squashfs.org.uk
Fixes: 93e72b3c612adc ("squashfs: migrate from ll_rw_block usage to BIO")
Reported-by: syzbot+6fba78f99b9afd4b5634@syzkaller.appspotmail.com
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Philippe Liard <pliard@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-avoid-out-of-bounds-writes-in-decompressors
+++ a/fs/squashfs/block.c
@@ -196,9 +196,15 @@ int squashfs_read_data(struct super_bloc
 		length = SQUASHFS_COMPRESSED_SIZE(length);
 		index += 2;
 
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
+	if (length < 0 || length > output->length ||
+			(index + length) > msblk->bytes_used) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (next_index)
 		*next_index = index + length;
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
squashfs-add-more-sanity-checks-in-id-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch


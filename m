Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0981C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 07:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388664AbiAYHoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 02:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446649AbiAYHl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 02:41:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEC0C08C5FD
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ACBCB81711
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C077DC340E0;
        Tue, 25 Jan 2022 06:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643092509;
        bh=H5TOtJt6fU34RpcoD+a8lpuPVMkLvsn21fh7rBmfJTw=;
        h=Date:From:To:Subject:From;
        b=YYY0XcjofQ0vj2V5QLdzOSUBiN6WOlvbkB74F0FWjK9qN7zJ4a1Qeekzzv2zA7X3R
         3ns6BnJ8AIZdB6+ILocsZErduHkv4F8Zw7tPAQUiaywr+U8J4XRKbkgm+h2QJfN9dr
         8fERF91b5mZ/H33DrFoEzgX/xhBxW08j6u8jYm6k=
Date:   Mon, 24 Jan 2022 22:35:08 -0800
From:   akpm@linux-foundation.org
To:     ailiop@suse.com, christian.brauner@ubuntu.com,
        deepa.kernel@gmail.com, djwong@kernel.org, hch@lst.de,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 mount-warn-only-once-about-timestamp-range-expiration.patch added to -mm
 tree
Message-ID: <20220125063508.YmQot6xi-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mount: warn only once about timestamp range expiration
has been added to the -mm tree.  Its filename is
     mount-warn-only-once-about-timestamp-range-expiration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mount-warn-only-once-about-timestamp-range-expiration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mount-warn-only-once-about-timestamp-range-expiration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anthony Iliopoulos <ailiop@suse.com>
Subject: mount: warn only once about timestamp range expiration

Commit f8b92ba67c5d ("mount: Add mount warning for impending timestamp
expiry") introduced a mount warning regarding filesystem timestamp limits,
that is printed upon each writable mount or remount.

This can result in a lot of unnecessary messages in the kernel log in
setups where filesystems are being frequently remounted (or mounted
multiple times).

Avoid this by setting a superblock flag which indicates that the warning
has been emitted at least once for any particular mount, as suggested in
[1].

[1] https://lore.kernel.org/CAHk-=wim6VGnxQmjfK_tDg6fbHYKL4EFkmnTjVr9QnRqjDBAeA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220119202934.26495-1-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |    2 ++
 include/linux/fs.h |    1 +
 2 files changed, 3 insertions(+)

--- a/fs/namespace.c~mount-warn-only-once-about-timestamp-range-expiration
+++ a/fs/namespace.c
@@ -2567,6 +2567,7 @@ static void mnt_warn_timestamp_expiry(st
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2581,6 +2582,7 @@ static void mnt_warn_timestamp_expiry(st
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
--- a/include/linux/fs.h~mount-warn-only-once-about-timestamp-range-expiration
+++ a/include/linux/fs.h
@@ -1435,6 +1435,7 @@ extern int send_sigurg(struct fown_struc
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
_

Patches currently in -mm which might be from ailiop@suse.com are

mount-warn-only-once-about-timestamp-range-expiration.patch


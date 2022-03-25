Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7A2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357312AbiCYBbv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357314AbiCYBbb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758B030F77
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 105D1617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A69EC340EC;
        Fri, 25 Mar 2022 01:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171795;
        bh=5i+nDh36HdB/+yOPhErNE8AHTTy3yJ0t0Lzn0C4ZQkk=;
        h=Date:To:From:Subject:From;
        b=xFmKknetqu3WhrUbQp6mox39UdTyh9mnS+qrk5mn9ay+I6/mqO3aMbPo/fQ6IBtlT
         0Z1UEfC8ICwFsW1qRFhW/Gr0jjGRkZRhBdpfbkW8VosLS7Gp35Qc7iZ64Apu2H4kop
         jcziu1biermSFhxk/PWQjltEYn49V3arIKoc9jD0=
Date:   Thu, 24 Mar 2022 18:29:54 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
        djwong@kernel.org, deepa.kernel@gmail.com,
        christian.brauner@ubuntu.com, ailiop@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mount-warn-only-once-about-timestamp-range-expiration.patch removed from -mm tree
Message-Id: <20220325012955.6A69EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mount: warn only once about timestamp range expiration
has been removed from the -mm tree.  Its filename was
     mount-warn-only-once-about-timestamp-range-expiration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2597,6 +2597,7 @@ static void mnt_warn_timestamp_expiry(st
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2611,6 +2612,7 @@ static void mnt_warn_timestamp_expiry(st
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
--- a/include/linux/fs.h~mount-warn-only-once-about-timestamp-range-expiration
+++ a/include/linux/fs.h
@@ -1440,6 +1440,7 @@ extern int send_sigurg(struct fown_struc
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
_

Patches currently in -mm which might be from ailiop@suse.com are



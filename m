Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E85DC433E4
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC74207DA
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790439;
	bh=mrLWYU0VpcPzhLQmOIGsc0oa3QvXQZPKKkO+j6zzxL8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ySkG0kHTAHL5DRkkYt50clkD53T1mV1qTzRtkQjY+MAYtrb6hYMSC3RsveKTNYets
	 41jLBB15tzQyk+Z8xMsMFrMd5Qyq7SV4p6GWg1/z00ZznVrPs6VeB3SAJtWrTV4C2G
	 qZrzBhIG+e9BR9RRjRzbAnW+SY3zBHNacU+zHUyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgHRWkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgHRWkf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB52207BB;
        Tue, 18 Aug 2020 22:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790435;
        bh=mrLWYU0VpcPzhLQmOIGsc0oa3QvXQZPKKkO+j6zzxL8=;
        h=Date:From:To:Subject:From;
        b=BpDd0vba9CmwMauzoNPVOvH82OIQmk2x58mKreUvpxSdQqM/gR7jwliYrj+9GfkRD
         UB4Ryc1j0ipNi5SECb+qGrk+JRBzw+nciqL0e9PQppcTNJnpzasYRjx0SXjuhqab2w
         T9K6bJAHSfgqWEl6wWJ1qUxhyA+weKocAaf85q1g=
Date:   Tue, 18 Aug 2020 15:40:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, raven@themaw.net, rdunlap@infradead.org
Subject:  [merged]
 fs-autofs-delete-repeated-words-in-comments.patch removed from -mm tree
Message-ID: <20200818224035.50GgYSJJh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: autofs: delete repeated words in comments
has been removed from the -mm tree.  Its filename was
     fs-autofs-delete-repeated-words-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs: autofs: delete repeated words in comments

Drop duplicated words {the, at} in comments.

Link: http://lkml.kernel.org/r/20200811021817.24982-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~fs-autofs-delete-repeated-words-in-comments
+++ a/fs/autofs/dev-ioctl.c
@@ -20,7 +20,7 @@
  * another mount. This situation arises when starting automount(8)
  * or other user space daemon which uses direct mounts or offset
  * mounts (used for autofs lazy mount/umount of nested mount trees),
- * which have been left busy at at service shutdown.
+ * which have been left busy at service shutdown.
  */
 
 typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
@@ -496,7 +496,7 @@ static int autofs_dev_ioctl_askumount(st
  * located path is the root of a mount we return 1 along with
  * the super magic of the mount or 0 otherwise.
  *
- * In both cases the the device number (as returned by
+ * In both cases the device number (as returned by
  * new_encode_dev()) is also returned.
  */
 static int autofs_dev_ioctl_ismountpoint(struct file *fp,
_

Patches currently in -mm which might be from rdunlap@infradead.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF53C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 006E76187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhKKCma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCma (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A781D61284;
        Thu, 11 Nov 2021 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598381;
        bh=ariYPGzsXg/+UstsF5VQgrmj8Uq3z+M1ixGrHaUiVuE=;
        h=Date:From:To:Subject:From;
        b=rA3+I49nxCrWPGQUW2D5QI/kmpAFLyQAIlpAK4OSFWzGsD8p50xHjs2rpHmZEJSDe
         Qj/ZNYuK/yYWpriwwNEGUpsOYLRwBw/Ba8R4mWOHhrPfctrqMWB2tssWIiGGjK9TgY
         UBfALreik7WxwZSpDvLslv2WUnh1XkFDawTqzID0=
Date:   Wed, 10 Nov 2021 18:39:41 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, justin.he@arm.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 d_path-fix-kernel-doc-validator-complaining.patch removed from -mm tree
Message-ID: <20211111023941.7Lh1cYGHs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: d_path: fix Kernel doc validator complaining
has been removed from the -mm tree.  Its filename was
     d_path-fix-kernel-doc-validator-complaining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jia He <justin.he@arm.com>
Subject: d_path: fix Kernel doc validator complaining

Kernel doc validator complains:
  Function parameter or member 'p' not described in 'prepend_name'
  Excess function parameter 'buffer' description in 'prepend_name'

Link: https://lkml.kernel.org/r/20211011005614.26189-1-justin.he@arm.com
Fixes: ad08ae586586 ("d_path: introduce struct prepend_buffer")
Signed-off-by: Jia He <justin.he@arm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/d_path.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/d_path.c~d_path-fix-kernel-doc-validator-complaining
+++ a/fs/d_path.c
@@ -77,9 +77,8 @@ static bool prepend(struct prepend_buffe
 
 /**
  * prepend_name - prepend a pathname in front of current buffer pointer
- * @buffer: buffer pointer
- * @buflen: allocated length of the buffer
- * @name:   name string and length qstr structure
+ * @p: prepend buffer which contains buffer pointer and allocated length
+ * @name: name string and length qstr structure
  *
  * With RCU path tracing, it may race with d_move(). Use READ_ONCE() to
  * make sure that either the old or the new name pointer and length are
@@ -141,8 +140,7 @@ static int __prepend_path(const struct d
  * prepend_path - Prepend path string to a buffer
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry
- * @buffer: pointer to the end of the buffer
- * @buflen: pointer to buffer length
+ * @p: prepend buffer which contains buffer pointer and allocated length
  *
  * The function will first try to write out the pathname without taking any
  * lock other than the RCU read lock to make sure that dentries won't go away.
_

Patches currently in -mm which might be from justin.he@arm.com are



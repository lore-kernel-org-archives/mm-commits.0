Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6BEC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB8660ED4
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhJ0Ueh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhJ0Ueg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E2C60EB4;
        Wed, 27 Oct 2021 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635366730;
        bh=kqweQG3FOTMAbxxkrKSxveWvZxxk0fVnRMcqFVMxnrg=;
        h=Date:From:To:Subject:From;
        b=MvCMZsqT06L1alM16DRLV/yGnRM+FSj+mbyQm5J4il5/ilWJ0Ci/oTTr7/fzSWTfI
         c32UwMqaiZmy6MTSeS2BXm1i7PTIBWaLYoSvGZMW1m27j3KG0H8ez0eZ9kC/+5yFkf
         3MI+DaqGAZiKmYvXjw08BGEqFC37B6YBPtHuZLFw=
Date:   Wed, 27 Oct 2021 13:32:10 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, justin.he@arm.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject:  + d_path-fix-kernel-doc-validator-complaining.patch added
 to -mm tree
Message-ID: <20211027203210.-1mSh6ss0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: d_path: fix Kernel doc validator complaining
has been added to the -mm tree.  Its filename is
     d_path-fix-kernel-doc-validator-complaining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/d_path-fix-kernel-doc-validator-complaining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/d_path-fix-kernel-doc-validator-complaining.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

d_path-fix-kernel-doc-validator-complaining.patch


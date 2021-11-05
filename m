Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF90C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB786611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhKEUhp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhKEUhp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51595611C0;
        Fri,  5 Nov 2021 20:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144505;
        bh=lvO/Xal88SvK8JgJPCjeMxe0PNEcLisn+UlciSN2QV4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HFvUNp7RjRAYZUooYaWxSUfF10d/wE3dmxoWA036/wdk3ANexAZuYk5fWYrJnrPwa
         OgfFN/eQlOj+vTPzFBOznm1otk98dZmXvee9DExqi5DWQNenhmuCtz0lTd3rzBQq2T
         qHzqFgj9fqBrufb/zYkrf31/kQP8Bo88UR69Iwgk=
Date:   Fri, 05 Nov 2021 13:35:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        justin.he@arm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 010/262] d_path: fix Kernel doc validator
 complaining
Message-ID: <20211105203504.mi-qYxPAX%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

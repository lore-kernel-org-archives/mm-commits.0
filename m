Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BC9C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6084D61040
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhHIStW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhHIStV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 14:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B2260EDF;
        Mon,  9 Aug 2021 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628534932;
        bh=AGOuXj8APnGjIS0XuaDfgMtlPcl5t2Kv2lqFH783M9M=;
        h=Date:From:To:Subject:From;
        b=TwUjHx9eVgWx0zbKAPCG7l2u9itgHg40swOg3yw/0EU319gYEWM4/23zxeGcBhXJh
         ToIqrM+BRFfDoAbFQJvuliWOE3+Z0Hb17XJFyEEU+vYM2oebfVtDFm4hKnBghtzko+
         Qf69VS3fB2WVBiQ4QUnaRxRmsA/ySJiWkq36SeU8=
Date:   Mon, 09 Aug 2021 11:48:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        rdunlap@infradead.org
Subject:  + lib-iov_iterc-fix-kernel-doc-warnings.patch added to -mm
 tree
Message-ID: <20210809184852.vLyAh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iov_iter.c: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     lib-iov_iterc-fix-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-iov_iterc-fix-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-iov_iterc-fix-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/iov_iter.c: fix kernel-doc warnings

Fix all kernel-doc warnings in lib/iov_iter.c:

lib/iov_iter.c:695: warning: Function parameter or member 'i' not described in '_copy_mc_to_iter'
lib/iov_iter.c:695: warning: Excess function parameter 'iter' description in '_copy_mc_to_iter'
lib/iov_iter.c:695: warning: No description found for return value of '_copy_mc_to_iter'
lib/iov_iter.c:758: warning: Function parameter or member 'i' not described in '_copy_from_iter_flushcache'
lib/iov_iter.c:758: warning: Excess function parameter 'iter' description in '_copy_from_iter_flushcache'
lib/iov_iter.c:758: warning: No description found for return value of '_copy_from_iter_flushcache'

Link: https://lkml.kernel.org/r/20210809051053.6531-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c~lib-iov_iterc-fix-kernel-doc-warnings
+++ a/lib/iov_iter.c
@@ -672,7 +672,7 @@ static size_t copy_mc_pipe_to_iter(const
  * _copy_mc_to_iter - copy to iter with source memory error exception handling
  * @addr: source kernel address
  * @bytes: total transfer length
- * @iter: destination iterator
+ * @i: destination iterator
  *
  * The pmem driver deploys this for the dax operation
  * (dax_copy_to_iter()) for dax reads (bypass page-cache and the
@@ -690,6 +690,8 @@ static size_t copy_mc_pipe_to_iter(const
  * * ITER_KVEC, ITER_PIPE, and ITER_BVEC can return short copies.
  *   Compare to copy_to_iter() where only ITER_IOVEC attempts might return
  *   a short copy.
+ *
+ * Return: number of bytes copied (may be %0)
  */
 size_t _copy_mc_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
@@ -744,7 +746,7 @@ EXPORT_SYMBOL(_copy_from_iter_nocache);
  * _copy_from_iter_flushcache - write destination through cpu cache
  * @addr: destination kernel address
  * @bytes: total transfer length
- * @iter: source iterator
+ * @i: source iterator
  *
  * The pmem driver arranges for filesystem-dax to use this facility via
  * dax_copy_from_iter() for ensuring that writes to persistent memory
@@ -753,6 +755,8 @@ EXPORT_SYMBOL(_copy_from_iter_nocache);
  * all iterator types. The _copy_from_iter_nocache() only attempts to
  * bypass the cache for the ITER_IOVEC case, and on some archs may use
  * instructions that strand dirty-data in the cache.
+ *
+ * Return: number of bytes copied (may be %0)
  */
 size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
scripts-check_extable-fix-typo-in-user-error-message.patch


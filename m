Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69391C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E9661131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbhIHDAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHDAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 047C461100;
        Wed,  8 Sep 2021 02:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069935;
        bh=xzDyQFzSg4dX7OcdFUUFWHpxdJ2lSGmbuoeNMUCsjfc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CMXDFszRe1SmtAtccFEB6OQdfc3uUWCmQgyvctKTdFT3sfNw9MgfM2t0rRyjRxfjx
         7H2T+q0UBQI4W8YaR7lJ3qx0Xvvurx8RTrY8bcLnrzSB4sLoL3TPq2GipqgyiwXRh2
         1FXGp7rvuHm3utTpG1VGL71y0mIOhzTsWD9eLUc0=
Date:   Tue, 07 Sep 2021 19:58:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 106/147] lib/iov_iter.c: fix kernel-doc warnings
Message-ID: <20210908025854.WyQCOMmvy%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

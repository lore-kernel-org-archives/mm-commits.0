Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1348C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBFCE61260
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhKRVjV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhKRVjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:39:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4AF96120A;
        Thu, 18 Nov 2021 21:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637271380;
        bh=M7eLWHZUkpQFqU86SLNrcCzHfd7iXMxlEnpyM00wrHg=;
        h=Date:From:To:Subject:From;
        b=wWqpfsxr6YRnXva8TJBdzOEgl01nK1KNbbJLdAPtQgyv8oLaaYpUHVvG7CdIb2JWM
         t0ig2NWW8CrX6FCoYnKdjwbyAPYB7u2qEqQWNLc6VnEpcvM4h6d01pDXyxdakIq6IR
         6+0wcs5U0wHlTdPftjr28QLw07Qe1OjkwBQZU4jI=
Date:   Thu, 18 Nov 2021 13:36:20 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  +
 mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
 added to -mm tree
Message-ID: <20211118213620.rJbJk4SF9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
has been added to the -mm tree.  Its filename is
     mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix

mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch[1],
which is merged in -mm but mainline yet, is making unnecessary function
prototype position changes in the damon.h.  This could make later
'git-blame' a little bit complex.  It also violates the 80 columns limit,
which is not madated but preferred and all other code of DAMON is
following.

This commit fixes those.  This should be folded into the patch before it
is sent to Linus.

[1] https://lore.kernel.org/mm-commits/20211115174837.wvyS8FbLx%25akpm@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211118114827.20052-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++--
 mm/damon/paddr.c      |    5 +++--
 mm/damon/vaddr.c      |    8 +++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/include/linux/damon.h
@@ -461,13 +461,13 @@ int damon_stop(struct damon_ctx **ctxs,
 #endif	/* CONFIG_DAMON */
 
 #ifdef CONFIG_DAMON_VADDR
-void damon_va_set_primitives(struct damon_ctx *ctx);
 bool damon_va_target_valid(void *t);
+void damon_va_set_primitives(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_VADDR */
 
 #ifdef CONFIG_DAMON_PADDR
-void damon_pa_set_primitives(struct damon_ctx *ctx);
 bool damon_pa_target_valid(void *t);
+void damon_pa_set_primitives(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_PADDR */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/paddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/mm/damon/paddr.c
@@ -246,8 +246,9 @@ static int damon_pa_apply_scheme(struct
 	return 0;
 }
 
-static int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_pa_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/mm/damon/vaddr.c
@@ -291,7 +291,8 @@ static void damon_va_init(struct damon_c
  *
  * Returns true if it is.
  */
-static bool damon_intersect(struct damon_region *r, struct damon_addr_range *re)
+static bool damon_intersect(struct damon_region *r,
+		struct damon_addr_range *re)
 {
 	return !(r->ar.end <= re->start || re->end <= r->ar.start);
 }
@@ -633,8 +634,9 @@ static int damon_va_apply_scheme(struct
 	return damos_madvise(t, r, madv_action);
 }
 
-static int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_va_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 
 	switch (scheme->action) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-use-__gfp_nowarn-for-user-specified-size-buffer-allocation.patch
mm-damon-dbgfs-fix-missed-use-of-damon_dbgfs_lock.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch


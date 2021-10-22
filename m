Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9E6C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 21:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7430E61040
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 21:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhJVV6T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 17:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhJVV6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 17:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC2236103E;
        Fri, 22 Oct 2021 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634939761;
        bh=GUImW+n04J15KaTLxtkrXf6ppVjzmKXEE0P5jRz1K0w=;
        h=Date:From:To:Subject:From;
        b=Vc+4w6Lb3E3gbSJUXv7Om4QYxO58pJ6CdYygSz9avZCLO6TMj+EJUyxzO5VAUkNRG
         14ojbE9Y7ThVSb3o5aBdgn9TJ/eUNyNpi4zA22rfSc9NUr7+CRaSlMzaMfqNUEGjbt
         z+mVIg42iZJaFXkCJkCR2E23LE94E7lvgegjpbDc=
Date:   Fri, 22 Oct 2021 14:56:00 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, nathan@kernel.org, osalvador@suse.de,
        sfr@canb.auug.org.au, shy828301@gmail.com
Subject:  +
 mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch added to
 -mm tree
Message-ID: <20211022215600.xi75zdmaM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: fix uninitialized variable use in me_pagecache_clean()
has been added to the -mm tree.  Its filename is
     mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: shmem: fix uninitialized variable use in me_pagecache_clean()

It appears that the has_extra_refcount() is now in the wrong place:

mm/memory-failure.c:892:6: error: variable 'extra_pins' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (!mapping) {
            ^~~~~~~~
mm/memory-failure.c:915:32: note: uninitialized use occurs here
        if (has_extra_refcount(ps, p, extra_pins))
                                      ^~~~~~~~~~
mm/memory-failure.c:892:2: note: remove the 'if' if its condition is always false
        if (!mapping) {
        ^~~~~~~~~~~~~~~
mm/memory-failure.c:879:6: error: variable 'extra_pins' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (PageAnon(p)) {
            ^~~~~~~~~~~
mm/memory-failure.c:915:32: note: uninitialized use occurs here
        if (has_extra_refcount(ps, p, extra_pins))
                                      ^~~~~~~~~~
mm/memory-failure.c:879:2: note: remove the 'if' if its condition is always false
        if (PageAnon(p)) {
        ^~~~~~~~~~~~~~~~~~
mm/memory-failure.c:871:17: note: initialize the variable 'extra_pins' to silence this warning
        bool extra_pins;
                       ^
                        = 0

In both of those cases, we already set an error code and don't
need to override that one.

Link: https://lkml.kernel.org/r/20211022064748.4173718-1-arnd@kernel.org
Fixes: d882a43a0011 ("mm: shmem: don't truncate page if memory failure happens")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2
+++ a/mm/memory-failure.c
@@ -909,12 +909,12 @@ static int me_pagecache_clean(struct pag
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_page(p, page_to_pfn(p), mapping);
-out:
-	unlock_page(p);
-
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
+out:
+	unlock_page(p);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-test-use-underlying-string-helpers.patch
posix-acl-avoid-wempty-body-warning.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch
hfs-hfsplus-use-warn_on-for-sanity-check.patch


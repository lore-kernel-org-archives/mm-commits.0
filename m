Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BDAC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5676D613AD
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhJVChr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 22:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231887AbhJVChq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 22:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF98A6128E;
        Fri, 22 Oct 2021 02:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634870130;
        bh=tv9HOK1r6q1H4gIOJYN/4wH9mbDfsx9S31hvQBlw69c=;
        h=Date:From:To:Subject:From;
        b=pvcVoep25dEGvs97OEhlV8o79wfh5+DYnyOvl2xJ5jObn4NVZzTYJphKomQ4kY1tV
         6Rc6h23pgKho3+v0dEsgXiPdHKLKetdQ7khfJyT4BG4XDmZPee32+vqSdC9crLf9Lh
         8lViXKINEuxu9UvaKbKLUCggzwHQ1nUFqoZaxPPE=
Date:   Thu, 21 Oct 2021 19:35:29 -0700
From:   akpm@linux-foundation.org
To:     bot@kernelci.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        sfr@canb.auug.org.au, shy828301@gmail.com
Subject:  +
 mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch added to
 -mm tree
Message-ID: <20211022023529.rGwWR0IKz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_failure: initialize extra_pins in me_pagecache_clean()
has been added to the -mm tree.  Its filename is
     mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/memory_failure: initialize extra_pins in me_pagecache_clean()

Clang warns:

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
2 errors generated.

Initialize extra_pins to false so that it is not used uninitialized.

Link: https://lkml.kernel.org/r/20211021180336.2328086-1-nathan@kernel.org
Fixes: d882a43a0011 ("mm: shmem: don't truncate page if memory failure happens")
Link: https://github.com/ClangBuiltLinux/linux/issues/1487
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-shmem-dont-truncate-page-if-memory-failure-happens-fix
+++ a/mm/memory-failure.c
@@ -868,7 +868,7 @@ static int me_pagecache_clean(struct pag
 {
 	int ret;
 	struct address_space *mapping;
-	bool extra_pins;
+	bool extra_pins = false;
 
 	delete_from_lru_cache(p);
 
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch


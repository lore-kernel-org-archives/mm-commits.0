Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EBEC433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B4F6198C
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCSXSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 19:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhCSXSP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 19:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D066198A;
        Fri, 19 Mar 2021 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616195895;
        bh=UTEA2aeulICGJdGzpAaVPXVPLh3GCQgm5stDkOTfHlY=;
        h=Date:From:To:Subject:From;
        b=mLlhuY3YC4x6joVLm2XLN83kb00Q+imAWahheMRiQH4M887XOCoKx4xEk+GS83C75
         rfQA6j+o5RzTmD/ttvI3XlfA/h2QA+FhwIwNCBlS9Yiybk6SxsWSsroDkA34/NRvAb
         9sZIddBIkGKQcLGjf/0IpoUPxtItHSHy4AeuSVOU=
Date:   Fri, 19 Mar 2021 16:18:14 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, gregkh@google.com,
        mm-commits@vger.kernel.org
Subject:  + proc-fix-incorrect-pde_is_permanent-check.patch added
 to -mm tree
Message-ID: <20210319231814.DJd9aSf0-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/generic.c: fix incorrect pde_is_permanent check
has been added to the -mm tree.  Its filename is
     proc-fix-incorrect-pde_is_permanent-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-fix-incorrect-pde_is_permanent-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-incorrect-pde_is_permanent-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: fs/proc/generic.c: fix incorrect pde_is_permanent check

Currently the pde_is_permanent() check is being run on root multiple times
rather than on the next proc directory entry.  This looks like a
copy-paste error.  Fix this by replacing root with next.

Addresses-Coverity: ("Copy-paste error")
Link: https://lkml.kernel.org/r/20210318122633.14222-1-colin.king@canonical.com
Fixes: d919b33dafb3 ("proc: faster open/read/close with "permanent" files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-fix-incorrect-pde_is_permanent-check
+++ a/fs/proc/generic.c
@@ -756,7 +756,7 @@ int remove_proc_subtree(const char *name
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
-			if (unlikely(pde_is_permanent(root))) {
+			if (unlikely(pde_is_permanent(next))) {
 				write_unlock(&proc_subdir_lock);
 				WARN(1, "removing permanent /proc entry '%s/%s'",
 					next->parent->name, next->name);
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-slab-fix-spelling-mistake-disired-desired.patch
mm-vmalloc-hugepage-vmalloc-mappings-fix.patch
mm-cma-support-sysfs-fix.patch
proc-fix-incorrect-pde_is_permanent-check.patch


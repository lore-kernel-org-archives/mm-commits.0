Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04168C6FD1F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCHUIz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCHUIx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E143738B5
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A0B4B81DF1
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E230EC433D2;
        Wed,  8 Mar 2023 20:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306128;
        bh=ff4nQypoAn6cNlm1i7aQdFkcOTPXTv4xnbTK222p9C8=;
        h=Date:To:From:Subject:From;
        b=cXItqZKayPtIOH2CqtunevCV/n5g1TYitxk9FNf8ZdXgxoRgRWLVL0RDFLXwHaWuA
         utUDOP5rLohDDwKENEZn378UY36GmE1LV/MTjp3TzjyYIZ+rs6i3GuI5tHR3k+BVQL
         wAcaZDQuB7NjLDiSSCL7nKzwxA+ht2kxYsH8bGNs=
Date:   Wed, 08 Mar 2023 12:08:47 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        nd@arm.com, keescook@chromium.org, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, joey.gouly@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-error-handling-for-map_deny_write_exec.patch added to mm-hotfixes-unstable branch
Message-Id: <20230308200847.E230EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix error handling for map_deny_write_exec
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-error-handling-for-map_deny_write_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-error-handling-for-map_deny_write_exec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joey Gouly <joey.gouly@arm.com>
Subject: mm: fix error handling for map_deny_write_exec
Date: Wed, 8 Mar 2023 19:04:21 +0000

Commit 4a18419f71cd ("mm/mprotect: use mmu_gather") changed 'goto out;' to
'break' in the loop.

This wasn't noticed while rebasing the MDWE patches, so fix it now.

Link: https://lkml.kernel.org/r/20230308190423.46491-3-joey.gouly@arm.com
Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reported-by: Alexey Izbyshev <izbyshev@ispras.ru>
  Link: https://lore.kernel.org/linux-arm-kernel/8408d8901e9d7ee6b78db4c6cba04b78@ispras.ru/
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: nd <nd@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-fix-error-handling-for-map_deny_write_exec
+++ a/mm/mprotect.c
@@ -805,7 +805,7 @@ static int do_mprotect_pkey(unsigned lon
 
 		if (map_deny_write_exec(vma, newflags)) {
 			error = -EACCES;
-			goto out;
+			break;
 		}
 
 		/* Allow architectures to sanity-check the new flags */
_

Patches currently in -mm which might be from joey.gouly@arm.com are

mm-deduplicate-error-handling-for-map_deny_write_exec.patch
mm-fix-error-handling-for-map_deny_write_exec.patch


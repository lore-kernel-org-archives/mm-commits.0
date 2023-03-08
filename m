Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB4BC678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCHUIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCHUIs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:08:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DAB72B24
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4B6761941
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E192C433EF;
        Wed,  8 Mar 2023 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306126;
        bh=vlui+6/8Z0PpqUZx4fTEMRtK9SqjNInOJHQWtuUOpLI=;
        h=Date:To:From:Subject:From;
        b=dptTTN69b796z/GNf9B5tnqm2aTXoROjc4C+p1pEBr2+jCtw40iz7eqogH/jqR3hC
         hNtncnyBRhT9mBCjTYeqOYQoYmk0jml/EBr7VqzvTmCa4Y4zHHtjr/1eCPwvddGwIp
         rnxFYFI4V+yBrj7XS/zy5X/nGa00pzqJFw/GDCTE=
Date:   Wed, 08 Mar 2023 12:08:45 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        nd@arm.com, keescook@chromium.org, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, joey.gouly@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-deduplicate-error-handling-for-map_deny_write_exec.patch added to mm-hotfixes-unstable branch
Message-Id: <20230308200846.1E192C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: deduplicate error handling for map_deny_write_exec
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-deduplicate-error-handling-for-map_deny_write_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-deduplicate-error-handling-for-map_deny_write_exec.patch

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
Subject: mm: deduplicate error handling for map_deny_write_exec
Date: Wed, 8 Mar 2023 19:04:20 +0000

Patch series "Fixes for MDWE prctl"

These are four small fixes for the recent memory-write-deny-execute prctl
patches [1].  Two reported by Alexey about error handling and two tooling
fixes by Peter.


This patch (of 4):

Commit cc8d1b097de7 ("mmap: clean up mmap_region() unrolling")
deduplicated the error handling, do the same for the return value of
`map_deny_write_exec`.

Link: https://lkml.kernel.org/r/20230308190423.46491-1-joey.gouly@arm.com
Link: https://lkml.kernel.org/r/20230308190423.46491-2-joey.gouly@arm.com
Link: https://lore.kernel.org/linux-arm-kernel/20230119160344.54358-1-joey.gouly@arm.com/ [1]
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


--- a/mm/mmap.c~mm-deduplicate-error-handling-for-map_deny_write_exec
+++ a/mm/mmap.c
@@ -2621,12 +2621,7 @@ cannot_expand:
 
 	if (map_deny_write_exec(vma, vma->vm_flags)) {
 		error = -EACCES;
-		if (file)
-			goto close_and_free_vma;
-		else if (vma->vm_file)
-			goto unmap_and_free_vma;
-		else
-			goto free_vma;
+		goto close_and_free_vma;
 	}
 
 	/* Allow architectures to sanity-check the vm_flags */
_

Patches currently in -mm which might be from joey.gouly@arm.com are

mm-deduplicate-error-handling-for-map_deny_write_exec.patch
mm-fix-error-handling-for-map_deny_write_exec.patch


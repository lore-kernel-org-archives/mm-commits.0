Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58C0C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCWBds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCWBda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD613171A
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D17576239C
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AC7C433EF;
        Thu, 23 Mar 2023 01:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535132;
        bh=aulvVFW5csFq09gYjd37YdE6+0L2WpcG7swG9FdjIM8=;
        h=Date:To:From:Subject:From;
        b=lS1OBbaRAX1C3lMyuS5Yg0Errp2v7qWXeTgVOXg2U+tUyAi584DDhklR4A0bEovzW
         sn2i7P0YgyRAPLFur8DjyY6KlNj3nAvmY6dBXH2MWGtg51AmHJ2/L4fI/dftIeHmuZ
         9ydaTzTkGDz1o/riCM/ZwzyN9atCu2bWhSbYpKUc=
Date:   Wed, 22 Mar 2023 18:32:11 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        nd@arm.com, keescook@chromium.org, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, joey.gouly@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-deduplicate-error-handling-for-map_deny_write_exec.patch removed from -mm tree
Message-Id: <20230323013212.29AC7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: deduplicate error handling for map_deny_write_exec
has been removed from the -mm tree.  Its filename was
     mm-deduplicate-error-handling-for-map_deny_write_exec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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



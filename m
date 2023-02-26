Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6A3C7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 21:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjBZVaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 16:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZVaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 16:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3609CCA23
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 13:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C337360C35
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 21:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16365C433EF;
        Sun, 26 Feb 2023 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677447010;
        bh=Lo45mb8Frm0w8NBjQUknhZgAcu3BV/7NrlVGIuDqlWw=;
        h=Date:To:From:Subject:From;
        b=WNmFBOQuwHC7RvJMBd5nsWTrggm/GVQdQv5cDcP9OzrJHcrWaitwIVU9mLV4IAkpC
         r3DIBE4694fyWppBH/GFTnH0IQU14KrKXPh9IUNnCi5zCCFMt8Ov2ZwlICLSOjBBlJ
         +MUIuYOOKihyYSCynM/PsgSuJEvWxT0GWuGRKHDk=
Date:   Sun, 26 Feb 2023 13:30:09 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        gregkh@linuxfoundation.org, eggert@cs.ucla.edu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-make-sh-files-executable.patch added to mm-nonmm-unstable branch
Message-Id: <20230226213010.16365C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/: make .sh files executable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-make-sh-files-executable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-make-sh-files-executable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/: make .sh files executable
Date: Sun Feb 26 12:50:54 PM PST 2023

scripts/spdxcheck-test.sh and scripts/test_fortify.sh don't have their x
bits set.

I really only did this to check whether `git diff --no-index --' can be
used to replace `diff', so as to preserve file permissions.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
  Link: https://lkml.kernel.org/r/CAHk-=wj-+PTUfu9NsdDt3p7tLXbUH-KJPBz+r4wHX075fydEOQ@mail.gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Eggert <eggert@cs.ucla.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff --git a/scripts/spdxcheck-test.sh~scripts-make-sh-files-executable b/scripts/spdxcheck-test.sh
old mode 100644
new mode 100755
diff --git a/scripts/test_fortify.sh~scripts-make-sh-files-executable b/scripts/test_fortify.sh
old mode 100644
new mode 100755
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-cramfs-inodec-initialize-file_ra_state.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
scripts-make-sh-files-executable.patch


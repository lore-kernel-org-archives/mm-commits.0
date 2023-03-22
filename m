Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7237C6FD1C
	for <mm-commits@archiver.kernel.org>; Wed, 22 Mar 2023 23:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCVXNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 19:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCVXNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 19:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A45CDBDF
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 16:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50397B81E62
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 23:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0656BC433EF;
        Wed, 22 Mar 2023 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679526816;
        bh=R+6Hty7MW6hsY5tp/PdQy6v1NVyXyelVKFfLvM73dqg=;
        h=Date:To:From:Subject:From;
        b=wenEYiqjjO6zPBnxdTVa2lRbfIZf3uV6TrRw6EdZEv+2BQxqlIgepJFtKI8LWmU0q
         Seg7YNbmlXEKnX6awoVSk/jR1XR4MYix0qCGOqXPTxwmSybhiC9Nyun5dTzpIubYcp
         goYWxYKMWuZSj8eTRKJMEAcYLrSz1hK44f4TCNI8=
Date:   Wed, 22 Mar 2023 16:13:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch added to mm-unstable branch
Message-Id: <20230322231336.0656BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: dedupe should compare the min of two iters' length
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch

This patch will later appear in the mm-unstable branch at
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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: dedupe should compare the min of two iters' length
Date: Wed, 22 Mar 2023 07:25:58 +0000

In an dedupe comparison iter loop, the length of iomap_iter decreases
because it implies the remaining length after each iteration.  The compare
function should use the min length of the current iters, not the total
length.

Link: https://lkml.kernel.org/r/1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/dax.c~fsdax-dedupe-should-compare-the-min-of-two-iters-length
+++ a/fs/dax.c
@@ -2027,8 +2027,8 @@ int dax_dedupe_file_range_compare(struct
 
 	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
 	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
-		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
-						  same);
+		compared = dax_range_compare_iter(&src_iter, &dst_iter,
+				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
 			return ret;
 		src_iter.processed = dst_iter.processed = compared;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch
fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch


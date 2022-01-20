Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088C1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377934AbiATVbD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60356 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348004AbiATVbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CE96B81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98159C340E0;
        Thu, 20 Jan 2022 21:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714260;
        bh=UiqD6i86iKTEEqdy4AM8FJPUIjrn4omFta76Y5vK7ko=;
        h=Date:From:To:Subject:From;
        b=aS9QNkFU8S54n4qGX+djtkX6P2T2AHvcy2bEgsfCHy793fWovW8xFFnaQyH/1plkT
         1wYE3aOtIuChZvA10/B4VQJcbLQyuWg1b64clmAt4bwjIYkKcjYrN9Eaj0QKH+QZhC
         fMSeHrovge2pK2TwqMFK/0PAM/uV+VRLlVl91Foc=
Date:   Thu, 20 Jan 2022 13:31:00 -0800
From:   akpm@linux-foundation.org
To:     apw@canonical.com, dwaipayanray1@gmail.com, jerome@forissier.org,
        joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-relax-regexp-for-commit_log_long_line.patch removed from -mm
 tree
Message-ID: <20220120213100.AcNuhVBBB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: relax regexp for COMMIT_LOG_LONG_LINE
has been removed from the -mm tree.  Its filename was
     checkpatch-relax-regexp-for-commit_log_long_line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jerome Forissier <jerome@forissier.org>
Subject: checkpatch: relax regexp for COMMIT_LOG_LONG_LINE

One exceptions to the COMMIT_LOG_LONG_LINE rule is a file path followed by
:.  That is typically some sort diagnostic message from a compiler or a
build tool, in which case we don't want to wrap the lines but keep the
message unmodified.

The regular expression used to match this pattern currently doesn't accept
absolute paths or + characters.  This can result in false positives as in
the following (out-of-tree) example:

  ...
  /home/jerome/work/optee_repo_qemu/build/../toolchains/aarch32/bin/arm-linux-gnueabihf-ld.bfd: /home/jerome/work/toolchains-gcc10.2/aarch32/bin/../lib/gcc/arm-none-linux-gnueabihf/10.2.1/../../../../arm-none-linux-gnueabihf/lib/libstdc++.a(eh_alloc.o): in function `__cxa_allocate_exception':
  /tmp/dgboter/bbs/build03--cen7x86_64/buildbot/cen7x86_64--arm-none-linux-gnueabihf/build/src/gcc/libstdc++-v3/libsupc++/eh_alloc.cc:284: undefined reference to `malloc'
  ...

Update the regular expression to match the above paths.

Link: https://lkml.kernel.org/r/20210923143842.2837983-1-jerome@forissier.org
Signed-off-by: Jerome Forissier <jerome@forissier.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-relax-regexp-for-commit_log_long_line
+++ a/scripts/checkpatch.pl
@@ -3172,7 +3172,7 @@ sub process {
 		    length($line) > 75 &&
 		    !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
 					# file delta changes
-		      $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
+		      $line =~ /^\s*(?:[\w\.\-\+]*\/)++[\w\.\-\+]+:/ ||
 					# filename then :
 		      $line =~ /^\s*(?:Fixes:|Link:|$signature_tags)/i ||
 					# A Fixes: or Link: line or signature tag line
_

Patches currently in -mm which might be from jerome@forissier.org are



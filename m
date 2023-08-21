Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB19EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjHUUrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjHUUrH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D383A126
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7248E649F4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9622C433C7;
        Mon, 21 Aug 2023 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650815;
        bh=a7JLN9gXBqULi0ejkUcmUAHVwDniuAA+/j5x2ZkKp2k=;
        h=Date:To:From:Subject:From;
        b=hlhwRf3uWmERxqs6uGPyN3HBR+ifSGX4ME9RvegzhtLm3ktHyMfmCeLKWivtce6XJ
         LqpbDhETcYmD0TxtfHvY7kTbAfcRmW3gpISZ6Ut6eVNMiB0+TlUw2eqqU6bcn7KI4N
         ja1sT4b8N4ZLZq7JnvZ0aG1TGhWKUb8CsnKe9X5A=
Date:   Mon, 21 Aug 2023 13:46:55 -0700
To:     mm-commits@vger.kernel.org, jim.cromie@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-reword-long-line-warning-about-commit-msg.patch removed from -mm tree
Message-Id: <20230821204655.C9622C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: reword long-line warning about commit-msg
has been removed from the -mm tree.  Its filename was
     checkpatch-reword-long-line-warning-about-commit-msg.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: checkpatch: reword long-line warning about commit-msg
Date: Mon, 7 Aug 2023 21:30:19 -0600

Reword the warning to complain about line length 1st, since thats
whats actually tested.

Link: https://lkml.kernel.org/r/20230808033019.21911-3-jim.cromie@gmail.com
Cc: apw@canonical.com
Cc: joe@perches.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-reword-long-line-warning-about-commit-msg
+++ a/scripts/checkpatch.pl
@@ -3272,7 +3272,7 @@ sub process {
 					# A Fixes:, link or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
-			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
+			     "Prefer a maximum 75 chars per line (possible unwrapped commit description?)\n" . $herecurr);
 			$commit_log_long_line = 1;
 		}
 
_

Patches currently in -mm which might be from jim.cromie@gmail.com are



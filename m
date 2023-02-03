Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F44DC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBCGwP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBCGva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF604B49E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9D8B8298B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8AFC433EF;
        Fri,  3 Feb 2023 06:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407079;
        bh=P/Bqy/i1gHmchSB3R1YU22UFZlhDVu0ADPAPGVPhcfc=;
        h=Date:To:From:Subject:From;
        b=A53DhDrtMUXxDwk7uP/FX24QwoxRTtPWI+hQg6dmEC444vhewZAEr/yk7YbEKfxyV
         qra0sBKahm+ZqaodHqD12zy8B8lyGJ/2LEq63siqnj8sA01ExiE0ByNG6Sc8N33YBA
         nXwJx/bBtwwOsOr+7lPlLeTz0J7P9NC3N9Hxk+wQ=
Date:   Thu, 02 Feb 2023 22:51:18 -0800
To:     mm-commits@vger.kernel.org, heinzm@redhat.com, joe@perches.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-improve-embedded_filename-test.patch removed from -mm tree
Message-Id: <20230203065119.0B8AFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: improve EMBEDDED_FILENAME test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-embedded_filename-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve EMBEDDED_FILENAME test
Date: Tue, 24 Jan 2023 15:16:55 -0800

Privately, Heinz Mauelshagen showed that the embedded filename test is not
specific enough.

> WARNING: It's generally not useful to have the filename in the file
> #113: FILE: errors.c:113:
> +            block < registered_errors.blocks + registered_errors.count;

Extend the test to use the appropriate word boundary tests.

Link: https://lkml.kernel.org/r/36069dac5d07509dab1c7f1238f8cbb08db80ac6.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-improve-embedded_filename-test
+++ a/scripts/checkpatch.pl
@@ -3751,7 +3751,7 @@ sub process {
 		}
 
 # check for embedded filenames
-		if ($rawline =~ /^\+.*\Q$realfile\E/) {
+		if ($rawline =~ /^\+.*\b\Q$realfile\E\b/) {
 			WARN("EMBEDDED_FILENAME",
 			     "It's generally not useful to have the filename in the file\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are



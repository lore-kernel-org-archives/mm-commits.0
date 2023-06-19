Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839AFEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjFSX13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjFSXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47310D9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B74760FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C651CC433C8;
        Mon, 19 Jun 2023 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217011;
        bh=rEz1lSQNFwLStU9C5uK8OzUOu2C5kJlECCUNlIs8y2k=;
        h=Date:To:From:Subject:From;
        b=gTJT3sN51rTTTFLyw4ODulGPCRTpx2TMJEGmK6P6/0xzt5kg5L/gtkpBUf3lTaDjI
         Jm6pApIFhjT6uLkO+K9pXuQtD54i+JfVTEqqZWPvSfURJBm4M34+emUwqaBnbMo5RS
         m5/v+XZpnffMl7f91luKYzQETJs0V1LHqMlticFI=
Date:   Mon, 19 Jun 2023 16:23:31 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-start-update-damos-example-command.patch removed from -mm tree
Message-Id: <20230619232331.C651CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/start: update DAMOS example command
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-update-damos-example-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: update DAMOS example command
Date: Fri, 16 Jun 2023 19:17:37 +0000

DAMON user-space tool, damo, has deprecated[1] its old DAMOS schemes
specification format.  However, an example of DAMON documentation is still
using it.  Update the example to use one of the alternative options.

[1] https://github.com/awslabs/damo/commit/e9950ae68f6c

Link: https://lkml.kernel.org/r/20230616191742.87531-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-update-damos-example-command
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -119,9 +119,9 @@ set size has chronologically changed.::
 Data Access Pattern Aware Memory Management
 ===========================================
 
-Below three commands make every memory region of size >=4K that doesn't
-accessed for >=60 seconds in your workload to be swapped out. ::
+Below command makes every memory region of size >=4K that has not accessed for
+>=60 seconds in your workload to be swapped out. ::
 
-    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > test_scheme
-    $ echo "4K        max      0       0       60s     max     pageout" >> test_scheme
-    $ damo schemes -c test_scheme <pid of your workload>
+    $ sudo damo schemes --damos_access_rate 0 0 --damos_sz_region 4K max \
+                        --damos_age 60s max --damos_action pageout \
+                        <pid of your workload>
_

Patches currently in -mm which might be from sj@kernel.org are



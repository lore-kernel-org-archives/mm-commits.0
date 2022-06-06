Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45E4C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiFFTRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiFFTRv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39777A810
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314256140F
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEB6C34115;
        Mon,  6 Jun 2022 19:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654543069;
        bh=zL7uQiy2EaNZPjwKwqNOU1AAyhk8+gq5U4kHuA31bgo=;
        h=Date:To:From:Subject:From;
        b=VKsJjdZqvyi/PCfzzTH2exwi9b2LNbi+36XJqBuh2/JM/uI29jmIIGcl00fH8RPMp
         5jvd5A//IitVYIKd1jt84kHGG30xHwNvHOrxxW6U2y3WXfWVHlklAwrwsozNnCeHqA
         GSdIKPBGDq/+6iNnuaPA4s3O+hAnRMPQ4MihhDpk=
Date:   Mon, 06 Jun 2022 12:17:48 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch added to mm-unstable branch
Message-Id: <20220606191749.7CEB6C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
Date: Mon, 6 Jun 2022 18:23:05 +0000

Patch series "mm/damon: trivial cleanups".

This patchset contains trivial cleansups for DAMON code.


This patch (of 6):

Commit 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document
'commit_inputs' parameter") has documented the 'commit_inputs' parameter
which allows online parameter update, but it didn't remove a paragraph
saying the online parameter update is impossible.  This commit removes the
obsolete paragraph.

Link: https://lkml.kernel.org/r/20220606182310.48781-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220606182310.48781-2-sj@kernel.org
Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -48,12 +48,6 @@ DAMON_RECLAIM utilizes module parameters
 ``damon_reclaim.<parameter>=<value>`` on the kernel boot command line or write
 proper values to ``/sys/modules/damon_reclaim/parameters/<parameter>`` files.
 
-Note that the parameter values except ``enabled`` are applied only when
-DAMON_RECLAIM starts.  Therefore, if you want to apply new parameter values in
-runtime and DAMON_RECLAIM is already enabled, you should disable and re-enable
-it via ``enabled`` parameter file.  Writing of the new values to proper
-parameter values should be done before the re-enablement.
-
 Below are the description of each parameter.
 
 enabled
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch


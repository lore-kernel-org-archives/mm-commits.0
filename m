Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA62C001DF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 17:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjHBRIf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjHBRId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 13:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D9E1A5
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 10:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F0F61A4E
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 17:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7889CC433C7;
        Wed,  2 Aug 2023 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690996111;
        bh=raBxjJHA/iuJb7tRjAQZVI3xakQ9tTcdxpOK9JoM0l0=;
        h=Date:To:From:Subject:From;
        b=Pm65JbW6pARjmxM0eids7gkbGt1o4nZxZRb+mEALSgbzAdJct2YllD/+cv+PvropD
         LboKVS1oy10PlWNtDdCbrY87/flKknRjkIg8Xln4dBpemvj4pnsc7OUKJ+p8Mk+5js
         8BVXXHYahkyteqOcedxyrlPch2jKGvPT/m1prkVA=
Date:   Wed, 02 Aug 2023 10:08:30 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, corbet@lwn.net,
        mawupeng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-update-params-of-memhp_default_state=.patch added to mm-unstable branch
Message-Id: <20230802170831.7889CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: update params of memhp_default_state=
has been added to the -mm mm-unstable branch.  Its filename is
     doc-update-params-of-memhp_default_state=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-update-params-of-memhp_default_state=.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: doc: update params of memhp_default_state=
Date: Wed, 2 Aug 2023 15:43:12 +0800

Commit 5f47adf762b7 ("mm/memory_hotplug: allow to specify a default
online_type") allows to specify a default online_type which make online
memory to kernel or movable zone possible but fail to update to doc. 
Update doc to fit this change.

Link: https://lkml.kernel.org/r/20230802074312.2111074-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~doc-update-params-of-memhp_default_state=
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3105,7 +3105,7 @@
 			[KNL,SH] Allow user to override the default size for
 			per-device physically contiguous DMA buffers.
 
-	memhp_default_state=online/offline
+	memhp_default_state=online/offline/online_kernel/online_movable
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
 			set according to the
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch
doc-update-params-of-memhp_default_state=.patch


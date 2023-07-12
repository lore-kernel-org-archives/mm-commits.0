Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87D9EB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjGLSR3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGLSR2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168D173C
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 11:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560B8618BB
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 18:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6130C433C7;
        Wed, 12 Jul 2023 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689185846;
        bh=ES9QboxYuriX1G2RwRhXVfXzy5WLa++K9D7PidhwIpg=;
        h=Date:To:From:Subject:From;
        b=MdmL/C14NeJppCPN/TuNFWsfvooltu4K7b9KV3uOsDYSchKzt+NX6KHU+y23EuFpY
         LMmvRLk+YdA7dBAvpW0x6jp4XK1keVkp4xAi7Z6ISWavAW3dPibqaoQWa0N3rEqOtW
         JGmILqyn+ApmipABJkKjRk6lYWCjbDENLvGVmgLk=
Date:   Wed, 12 Jul 2023 11:17:25 -0700
To:     mm-commits@vger.kernel.org, quic_charante@quicinc.com,
        mhocko@suse.com, david@redhat.com, xueshi.hu@smartx.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-clear_page_idle.patch added to mm-unstable branch
Message-Id: <20230712181726.A6130C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove clear_page_idle()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-clear_page_idle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-clear_page_idle.patch

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
From: Xueshi Hu <xueshi.hu@smartx.com>
Subject: mm: remove clear_page_idle()
Date: Wed, 12 Jul 2023 21:49:59 +0800

All callers have now been converted to call folio_clear_idle().

Link: https://lkml.kernel.org/r/20230712134959.145373-1-xueshi.hu@smartx.com
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/page_idle.h~mm-remove-clear_page_idle
+++ a/include/linux/page_idle.h
@@ -144,9 +144,4 @@ static inline void set_page_idle(struct
 {
 	folio_set_idle(page_folio(page));
 }
-
-static inline void clear_page_idle(struct page *page)
-{
-	folio_clear_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
_

Patches currently in -mm which might be from xueshi.hu@smartx.com are

mm-remove-clear_page_idle.patch


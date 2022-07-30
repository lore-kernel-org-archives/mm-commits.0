Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D449C04A68
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 03:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiG3DpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 23:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbiG3Do7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 23:44:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B70376478
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 20:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545D6B82305
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 03:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C2C433C1;
        Sat, 30 Jul 2022 03:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659152695;
        bh=jJGf7tvMSzDoweoVxbvqdWf96OCMMWQ13UTXw7sWdeU=;
        h=Date:From:To:Cc:Subject:From;
        b=0VRpTjURuk/WmaNOsjlBMmaOo8Jy5Xl+F8JgnIfhQX69CYfZYHY8MRs/xgd6Danfo
         hki8WV2dCCwMNIq+qoXQbtZQumT/iId7MtBHPONUYAqBd3rfcOAo1pX/o90nibzYaD
         exrln8EDfGRKljze5kXqlhI7tXBoUMFwmP7OSwjQ=
Date:   Fri, 29 Jul 2022 20:44:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: [GIT PULL] final hotfixes for 5.19
Message-Id: <20220729204454.b38fba22290c5b54733cedb5@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus, please merge these two hotfixes for 5.19.

The following changes since commit 1f7ea54727caaa6701a15af0cbeddfdb015b2869:

  mailmap: update Gao Xiang's email addresses (2022-07-26 18:25:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-29

for you to fetch changes up to 8a295dbbaf7292c582a40ce469c326f472d51f66:

  mm/hmm: fault non-owner device private entries (2022-07-29 11:33:37 -0700)

----------------------------------------------------------------
Two hotfixes, both cc:stable.

----------------------------------------------------------------
Jaewon Kim (1):
      page_alloc: fix invalid watermark check on a negative value

Ralph Campbell (1):
      mm/hmm: fault non-owner device private entries

 mm/hmm.c        | 19 ++++++++-----------
 mm/page_alloc.c | 12 ++++++++----
 2 files changed, 16 insertions(+), 15 deletions(-)


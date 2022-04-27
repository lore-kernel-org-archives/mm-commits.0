Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B48C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 19:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiD0Tq5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbiD0Tqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 15:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C2A4AE01
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 12:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9523DB8298A
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E2BC385A7;
        Wed, 27 Apr 2022 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651088494;
        bh=ZcPpqyn530SIcrlZgLZiGM3NvRYrXDeBHNR87NeFbVs=;
        h=Date:From:To:Cc:Subject:From;
        b=ic8oIYIvUzxWufIKh1/6dyEM+XbxPLA/I4TJF00gZTd02iO3XpDGD85R92cFlJ2jp
         rRJ29vrcjsxdm1LrgdDbp1LCdixoCz1mAghV9HNSNZMDqK99kFbuCchx1SVXpUZd5s
         WLRsE089k9+Hw4AYf5MHxtMAE8IWGO8iWwca0xy0=
Date:   Wed, 27 Apr 2022 12:41:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

2 patches, based on d615b5416f8a1afeb82d13b238f8152c572d59c0.

Subsystems affected by this patch series:

  mm/kasan
  mm/debug

Subsystem: mm/kasan

    Zqiang <qiang1.zhang@intel.com>:
      kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

Subsystem: mm/debug

    Akira Yokosawa <akiyks@gmail.com>:
      docs: vm/page_owner: use literal blocks for param description

 Documentation/vm/page_owner.rst |    5 +++--
 mm/kasan/quarantine.c           |    7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)


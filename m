Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4E9C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 23:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiCPXPy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiCPXPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 19:15:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97E425D8
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 16:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9C33CE1EBF
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 23:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29501C340EC;
        Wed, 16 Mar 2022 23:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647472474;
        bh=vfzFNnNUfK6bRNCQnfj3XCkOhyHZU1wQdQXCAcJPUJM=;
        h=Date:From:To:Cc:Subject:From;
        b=Vz8um3sT+5iTj7/yUsVdugHcgOtN7isDJPiJKmLszBDqjTHmep9I/ggIdUKSx8cQx
         yvxviGBTrO3bqMRU6+V3NjxGmAIkF0ao58msFn99K8gg/CTfnCWp1V+xL1sxA92BEO
         PG3QrS0bWympeaB/X+SsNFjexaHfjpmZR5e02ujI=
Date:   Wed, 16 Mar 2022 16:14:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220316161433.5c2e137a69eaee50d2249a27@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

4 patches, based on 56e337f2cf1326323844927a04e9dbce9a244835.

Subsystems affected by this patch series:

  mm/swap
  kconfig
  ocfs2
  selftests

Subsystem: mm/swap

    Guo Ziliang <guo.ziliang@zte.com.cn>:
      mm: swap: get rid of deadloop in swapin readahead

Subsystem: kconfig

    Qian Cai <quic_qiancai@quicinc.com>:
      configs/debug: restore DEBUG_INFO=y for overriding

Subsystem: ocfs2

    Joseph Qi <joseph.qi@linux.alibaba.com>:
      ocfs2: fix crash when initialize filecheck kobj fails

Subsystem: selftests

    Yosry Ahmed <yosryahmed@google.com>:
      selftests: vm: fix clang build error multiple output files

 fs/ocfs2/super.c                    |   22 +++++++++++-----------
 kernel/configs/debug.config         |    1 +
 mm/swap_state.c                     |    2 +-
 tools/testing/selftests/vm/Makefile |    6 ++----
 4 files changed, 15 insertions(+), 16 deletions(-)


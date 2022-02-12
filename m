Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACA5C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354397AbiBLA2B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:28:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354417AbiBLA2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:28:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F20CE6
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D7061B59
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01571C340E9;
        Sat, 12 Feb 2022 00:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625677;
        bh=U02EXqB0acs/7+GSj9r6GCfbLswYmkOwVuP9SYslxXw=;
        h=Date:From:To:Cc:Subject:From;
        b=u1VkPY3myDbqMqb7Ag1AjEFEVzoBSx0pNJF1wSGEVNR+O8NzzuTucRqWnHs32Pqm/
         LoFPOwfIcK90ud/J9Fe2wx+i5mNbcYiFmg0WccecZr/2gC+T/ODkre4Zc0OeUFrvRh
         cFNVDtGG5Xu1024NA87Uu7RFwQcgtvbw4unrEh10=
Date:   Fri, 11 Feb 2022 16:27:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.

Subsystems affected by this patch series:

  binfmt
  procfs
  mm/vmscan
  mm/memcg
  mm/kfence

Subsystem: binfmt

    Mike Rapoport <rppt@linux.ibm.com>:
      fs/binfmt_elf: fix PT_LOAD p_align values for loaders

Subsystem: procfs

    Yang Shi <shy828301@gmail.com>:
      fs/proc: task_mmu.c: don't read mapcount for migration entry

Subsystem: mm/vmscan

    Mel Gorman <mgorman@suse.de>:
      mm: vmscan: remove deadlock due to throttling failing to make progress

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg: synchronize objcg lists with a dedicated spinlock

Subsystem: mm/kfence

    Peng Liu <liupeng256@huawei.com>:
      kfence: make test case compatible with run time set sample interval

 fs/binfmt_elf.c            |    2 +-
 fs/proc/task_mmu.c         |   40 +++++++++++++++++++++++++++++++---------
 include/linux/kfence.h     |    2 ++
 include/linux/memcontrol.h |    5 +++--
 mm/kfence/core.c           |    3 ++-
 mm/kfence/kfence_test.c    |    8 ++++----
 mm/memcontrol.c            |   10 +++++-----
 mm/vmscan.c                |    4 +++-
 8 files changed, 51 insertions(+), 23 deletions(-)


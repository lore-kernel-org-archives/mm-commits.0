Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4B4C43334
	for <mm-commits@archiver.kernel.org>; Sun,  5 Jun 2022 18:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiFESiI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 5 Jun 2022 14:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344968AbiFESiG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jun 2022 14:38:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C68A1834F;
        Sun,  5 Jun 2022 11:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35DCCB80DAF;
        Sun,  5 Jun 2022 18:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58C8C385A5;
        Sun,  5 Jun 2022 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654454280;
        bh=w/08vWmFbh5Wa5bCruMNGIeJtx/rdsrKAvGRB+0NjF0=;
        h=Date:From:To:Cc:Subject:From;
        b=iIWMJkbKcE+1JnyEhFjmyW05EX7nKpCG4LA/Z8SOOWntgHxP/iQgPQ2ZLv98RvabD
         H2Nzw2LR6iu1KDVzenZb7v9MnOv8VYWAr4Wrm62lNVz038mRBB1lWUWOMfoeggjGtQ
         shPih9+/8RPv4UOcCiYhl7dF0SAuwQoedJPhwAVU=
Date:   Sun, 5 Jun 2022 11:38:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] final non-MM work for 5.19-rc1
Message-Id: <20220605113800.83dfb5ac57ba1f0f64552d9f@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus,

just a single patch here - to add an arguably missing feature in the
delay accounting code.

The following changes since commit 54eb8462f21fb170a05ad64620f0d8d0cf2b7fb5:

  Merge tag 'rtc-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux (2022-06-01 14:48:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2022-06-05

for you to fetch changes up to 662ce1dc9caf493c309200edbe38d186f1ea20d0:

  delayacct: track delays from write-protect copy (2022-06-01 15:55:25 -0700)

----------------------------------------------------------------
A single featurelet for delay accounting.  Delayed a bit
because, unusually, it had dependencies on both the mm-stable and
mm-nonmm-stable queues.

----------------------------------------------------------------
Yang Yang (1):
      delayacct: track delays from write-protect copy

 Documentation/accounting/delay-accounting.rst |  5 ++++-
 include/linux/delayacct.h                     | 28 +++++++++++++++++++++++++++
 include/uapi/linux/taskstats.h                |  6 +++++-
 kernel/delayacct.c                            | 16 +++++++++++++++
 mm/hugetlb.c                                  |  8 ++++++++
 mm/memory.c                                   |  8 ++++++++
 tools/accounting/getdelays.c                  |  8 +++++++-
 7 files changed, 76 insertions(+), 3 deletions(-)


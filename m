Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD80C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 04:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbhLaEMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Dec 2021 23:12:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35182 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242664AbhLaEMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Dec 2021 23:12:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F285761742
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 04:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214E5C36AE9;
        Fri, 31 Dec 2021 04:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640923925;
        bh=7RmNPq5tiZveF2ILzFR0O0xBclpexu/gUBh7lttr44U=;
        h=Date:From:To:Cc:Subject:From;
        b=WS03yXSFb4ZMLD8ZxHuj5h+jhVgcvwAX1S3zM6hJ/yD5MQWIW8Fz3pULvhrRJr6TE
         JUta7SyLxg42ULbvTuenlaGOjgzO/m6naVJhHbItXwy6SyyJs8lb0WLoU6gH/Lf9Qb
         GJvYvVrVRFigXN+qXI9+IIVE0rmOyc6gNCQOgbOM=
Date:   Thu, 30 Dec 2021 20:12:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20211230201202.d9bcb24678cc3d9d503579a0@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

2 patches, based on 4f3d93c6eaff6b84e43b63e0d7a119c5920e1020.

Subsystems affected by this patch series:

  mm/userfaultfd
  mm/damon

Subsystem: mm/userfaultfd

    Mike Kravetz <mike.kravetz@oracle.com>:
      userfaultfd/selftests: fix hugetlb area allocations

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
      mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'

 mm/damon/dbgfs.c                         |    9 +++++++--
 tools/testing/selftests/vm/userfaultfd.c |   16 ++++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)


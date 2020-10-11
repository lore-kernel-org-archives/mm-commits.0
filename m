Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E7AC433DF
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850D32083B
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602396960;
	bh=Vq4cyero5ROGgh18KvHXhR/u/zjxRuUwPfjhG/w+7a0=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=ePi2pQI/kgUhXun93EmzcgRYDxnMILzoITFbmD+BMnqYp+1FKsZgxhT8w8fuWGWRJ
	 aLGdkCY/h/USVdA97gFQWia2oYKipSkuxGlKiYy8DLh0V3w4xn9ftmS3QxynioJRZw
	 moSIoZcSJOsdO8oxT/bRbMtdBSrAHBq+7Wov55Bg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgJKGQA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Oct 2020 02:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgJKGQA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Oct 2020 02:16:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B5A20795;
        Sun, 11 Oct 2020 06:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602396959;
        bh=Vq4cyero5ROGgh18KvHXhR/u/zjxRuUwPfjhG/w+7a0=;
        h=Date:From:To:Cc:Subject:From;
        b=nvAtDLA9uGp6ZBU9fc4FfcFHTDJQiErU3m/+QNLPVgLqydJ8Oc1sArQWgR6zFLia9
         hSZGw5VRsOVThpoIJtfa5PER+iRQnNPU8Ri2iqXPH7Ld/eQJrkuAD+dDejmVjxuQgn
         zWIdlsE6GPKhnQttF6WJVLtHZeR9wWYmBzGCgEIo=
Date:   Sat, 10 Oct 2020 23:15:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

5 patches, based on da690031a5d6d50a361e3f19f3eeabd086a6f20d.

Subsystems affected by this patch series:

  MAINTAINERS
  mm/pagemap
  mm/swap
  mm/hugetlb

Subsystem: MAINTAINERS

    Kees Cook <keescook@chromium.org>:
      MAINTAINERS: change hardening mailing list

    Antoine Tenart <atenart@kernel.org>:
      MAINTAINERS: Antoine Tenart's email address

Subsystem: mm/pagemap

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: mmap: Fix general protection fault in unlink_file_vma()

Subsystem: mm/swap

    Minchan Kim <minchan@kernel.org>:
      mm: validate inode in mapping_set_error()

Subsystem: mm/hugetlb

    Vijay Balakrishna <vijayb@linux.microsoft.com>:
      mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

 .mailmap                   |    4 +++-
 MAINTAINERS                |    8 ++++----
 include/linux/khugepaged.h |    5 +++++
 include/linux/pagemap.h    |    3 ++-
 mm/khugepaged.c            |   13 +++++++++++--
 mm/mmap.c                  |    6 +++++-
 mm/page_alloc.c            |    3 +++
 7 files changed, 33 insertions(+), 9 deletions(-)


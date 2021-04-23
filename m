Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0665AC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A6961474
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhDWV2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhDWV2n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Apr 2021 17:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1664F611F1;
        Fri, 23 Apr 2021 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213286;
        bh=5XMyWmPObm2Db2rJLK2SkblzsKhD+iSf4uLNQ62wixU=;
        h=Date:From:To:Cc:Subject:From;
        b=D/6TFHbzI5ldxkpeozPQ0SxNTgKkOjINEBL3+JhNlQjEMmjJZoEfsWzki6esYndbx
         P5jwKxW9lSBgMcFfGJ1H9qpih79Er1A2YsOtoKYoL92DynQ3Eh0a/XhDsjn+zYHkDl
         bZeh1GYlN4FEE98syvEAId3v6J5OzoDwI1qiP154=
Date:   Fri, 23 Apr 2021 14:28:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


5 patches, based on 5bfc75d92efd494db37f5c4c173d3639d4772966.

Subsystems affected by this patch series:

  coda
  overlayfs
  mm/pagecache
  mm/memcg

Subsystem: coda

    Christian K=F6nig <christian.koenig@amd.com>:
      coda: fix reference counting in coda_file_mmap error path

Subsystem: overlayfs

    Christian K=F6nig <christian.koenig@amd.com>:
      ovl: fix reference counting in ovl_mmap error path

Subsystem: mm/pagecache

    Hugh Dickins <hughd@google.com>:
      mm/filemap: fix find_lock_entries hang on 32-bit THP
      mm/filemap: fix mapping_seek_hole_data on THP & 32-bit

Subsystem: mm/memcg

    Vasily Averin <vvs@virtuozzo.com>:
      tools/cgroup/slabinfo.py: updated to work on current kernel

 fs/coda/file.c                 |    6 +++---
 fs/overlayfs/file.c            |   11 +----------
 mm/filemap.c                   |   31 +++++++++++++++++++------------
 tools/cgroup/memcg_slabinfo.py |    8 ++++----
 4 files changed, 27 insertions(+), 29 deletions(-)


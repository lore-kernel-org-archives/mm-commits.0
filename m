Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30001C19F28
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jul 2022 01:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiG0BmM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 21:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiG0BmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 21:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B938B5
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06CC561756
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 01:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B234C433D6;
        Wed, 27 Jul 2022 01:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658886129;
        bh=iIMQvRxqzpMB7+rYYZOFWgvsABc4bsIIXbW/UL2QPJk=;
        h=Date:From:To:Cc:Subject:From;
        b=1S/BFJHjCRYN5xA7ZxspUTaqJjA1n8gCd0omhhoEfytpUgs08VrdXmMhccoXq7hy5
         4xevsESW71hYT5ryB45pEd7nVlsLGS40Ulel95dTOt1KJLX4bpmsLNF1FKEEgTUrYG
         JIzIzn2xu/0MQhNt6yyfGBaq1u7wkRs8dk9FW530=
Date:   Tue, 26 Jul 2022 18:42:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 5.19
Message-Id: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus,  please merge this bunch of hotfixes for the 5.19 release.


The following changes since commit 14c99d65941538aa33edd8dc7b1bbbb593c324a2:

  mm: split huge PUD on wp_huge_pud fallback (2022-07-03 15:42:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-26

for you to fetch changes up to 1f7ea54727caaa6701a15af0cbeddfdb015b2869:

  mailmap: update Gao Xiang's email addresses (2022-07-26 18:25:01 -0700)

----------------------------------------------------------------
Thirteen hotfixes, Eight are cc:stable and the remainder are for post-5.18
issues or are too minor to warrant backporting

----------------------------------------------------------------
Andrei Vagin (1):
      fs: sendfile handles O_NONBLOCK of out_fd

ChenXiaoSong (1):
      ntfs: fix use-after-free in ntfs_ucsncmp()

Gao Xiang (1):
      mailmap: update Gao Xiang's email addresses

Josef Bacik (1):
      mm: fix page leak with multiple threads mapping the same page

Junxiao Bi (1):
      Revert "ocfs2: mount shared volume without ha stack"

Miaohe Lin (1):
      hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte

Mike Rapoport (1):
      secretmem: fix unhandled fault in truncate

Muchun Song (1):
      mm: fix missing wake-up event for FSDAX pages

Nadav Amit (1):
      userfaultfd: provide properly masked address for huge-pages

Naoya Horiguchi (1):
      mm/hugetlb: separate path for hwpoison entry in copy_hugetlb_page_range()

Seth Forshee (1):
      mailmap: update Seth Forshee's email address

Yee Lee (1):
      mm: kfence: apply kmemleak_ignore_phys on early allocated pool

ZhaoLong Wang (1):
      tmpfs: fix the issue that the mount and remount results are inconsistent.

 .mailmap            |  3 +++
 fs/ntfs/attrib.c    |  8 ++++++--
 fs/ocfs2/ocfs2.h    |  4 +---
 fs/ocfs2/slot_map.c | 46 +++++++++++++++++++---------------------------
 fs/ocfs2/super.c    | 21 ---------------------
 fs/read_write.c     |  3 +++
 fs/userfaultfd.c    | 12 +++++++-----
 include/linux/mm.h  | 14 +++++++++-----
 mm/gup.c            |  6 ++++--
 mm/hugetlb.c        | 10 ++++++++--
 mm/kfence/core.c    | 18 +++++++++---------
 mm/memory.c         |  7 +++++--
 mm/memremap.c       |  6 +++---
 mm/secretmem.c      | 33 ++++++++++++++++++++++++++-------
 mm/shmem.c          |  7 ++-----
 15 files changed, 105 insertions(+), 93 deletions(-)


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E6EC636D6
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 23:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBQXSZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Feb 2023 18:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjBQXSY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2023 18:18:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FB26180;
        Fri, 17 Feb 2023 15:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 220D5B82EB1;
        Fri, 17 Feb 2023 23:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B156BC433D2;
        Fri, 17 Feb 2023 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676675900;
        bh=oq+uagmvKxZaMe7WRfPkQe5SJzixvODnA5FXwdYQHws=;
        h=Date:From:To:Cc:Subject:From;
        b=H5RqU7EKFrcaCmK8lHa+Ewv1xXU04c5n9R0AGlYVTAM46LqzLWeLlzrlODD9SRsYA
         +t0abmYbVPRvmq8RtIvxDqhsI/vHSIyW9N8danwzGUd8+e2GeOQYuekFrN+gYChnF+
         lVJCRwajZzYfegGYAndXXL6mzooHYp3O2hrI8e/o=
Date:   Fri, 17 Feb 2023 15:18:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.2
Message-Id: <20230217151820.e1fa2d36179e44069a77040c@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus, please merge this final set of hotfixes, thanks.


The following changes since commit ce4d9a1ea35ac5429e822c4106cb2859d5c71f3e:

  of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem (2023-02-09 15:56:51 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-02-17-15-16-2

for you to fetch changes up to 99b9402a36f0799f25feee4465bfa4b8dfa74b4d:

  nilfs2: fix underflow in second superblock position calculations (2023-02-17 15:07:05 -0800)

----------------------------------------------------------------
Six hotfixes.  Five are cc:stable: four for MM, one for nilfs2.  Also a
MAINTAINERS update.

----------------------------------------------------------------
Mike Kravetz (1):
      hugetlb: check for undefined shift on 32 bit architectures

Peter Xu (1):
      mm/migrate: fix wrongly apply write bit after mkdirty on sparc64

Qian Yingjin (1):
      mm/filemap: fix page end in filemap_get_read_batch

Randy Dunlap (1):
      MAINTAINERS: update FPU EMULATOR web page

Ryusuke Konishi (1):
      nilfs2: fix underflow in second superblock position calculations

Zach O'Keefe (1):
      mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount

 MAINTAINERS             | 2 +-
 fs/nilfs2/ioctl.c       | 7 +++++++
 fs/nilfs2/super.c       | 9 +++++++++
 fs/nilfs2/the_nilfs.c   | 8 +++++++-
 include/linux/hugetlb.h | 5 ++++-
 mm/filemap.c            | 5 +++--
 mm/huge_memory.c        | 6 ++++--
 mm/khugepaged.c         | 1 +
 mm/migrate.c            | 2 ++
 9 files changed, 38 insertions(+), 7 deletions(-)


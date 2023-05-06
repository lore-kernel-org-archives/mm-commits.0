Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB4BC77B7F
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 17:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjEFRsz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 May 2023 13:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEFRsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 May 2023 13:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17F417FF7;
        Sat,  6 May 2023 10:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E010601BD;
        Sat,  6 May 2023 17:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D415C433D2;
        Sat,  6 May 2023 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683395332;
        bh=WqD9VP0EqZpeU9/yL8PMxkoRPSau18tLteD5bA+cTes=;
        h=Date:From:To:Cc:Subject:From;
        b=GrSqnp8vlqqYuzHEjSKJj33ghZ0qWob6EsZalK11l44yBp78UArfNZRNuCtnt0UVf
         neD8wHHkFRZbD+tpHZoQ1YaDtX97xleU5k23oCqSxD+pSEZgz3mtYCS9vy6VgkiFZj
         KB/tpIV3PdhcM2t0Mm6SuZTKqgS1oPOOeECB3UVY=
Date:   Sat, 6 May 2023 10:48:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] more hotfixes for 6.4-rc1
Message-Id: <20230506104851.21c6a2846f208820e75e7559@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 418d5c98319f67b9ae651babea031b5394425c18:

  Merge tag 'devicetree-fixes-for-6.4-1' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2023-05-05 13:27:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-05-06-10-45

for you to fetch changes up to 58f5f6698a72a8af5d7bfc5f49b6df60f378f167:

  afs: fix the afs_dir_get_folio return value (2023-05-06 10:10:08 -0700)

----------------------------------------------------------------
Five hotfixes.  Three are cc:stable, two pertain to post-6.3 merge window
changes.

----------------------------------------------------------------
Christoph Hellwig (1):
      afs: fix the afs_dir_get_folio return value

Jan Kara (1):
      mm: do not reclaim private data from pinned page

Lorenzo Stoakes (1):
      mm/mmap/vma_merge: always check invariants

Ryusuke Konishi (2):
      nilfs2: fix infinite loop in nilfs_mdt_get_block()
      nilfs2: do not write dirty data after degenerating to read-only

 fs/afs/dir_edit.c   |  7 ++++---
 fs/nilfs2/bmap.c    | 16 ++++++++++++----
 fs/nilfs2/segment.c |  5 ++++-
 mm/mmap.c           | 10 +++++-----
 mm/vmscan.c         | 10 ++++++++++
 5 files changed, 35 insertions(+), 13 deletions(-)


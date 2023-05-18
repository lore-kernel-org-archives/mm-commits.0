Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03452C77B73
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 22:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjERW4L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 18:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjERW4K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 18:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77252103;
        Thu, 18 May 2023 15:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F98652C4;
        Thu, 18 May 2023 22:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538ACC433EF;
        Thu, 18 May 2023 22:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684450567;
        bh=FHBM36HNTBWfLZlm5M6pnG5/CJVnIGftIXamVfU0P4Q=;
        h=Date:From:To:Cc:Subject:From;
        b=PpCSwtKXNBgBwWCLTLEP7f+nrYEO9Erz8gJPzPDF67JVx6iyJBZ7sUZ6W/dZ34F3M
         YwkKZnXmFiDHbiFJRMt5hDqp8Tm4OgPy8HOYtcJeAhpFz4Gq3CRkdPM671V2gv0lUD
         iin2pV8Jfuxc1ItdeptDalyzpeDvttBPTMgUZ/6M=
Date:   Thu, 18 May 2023 15:56:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.4-rc2
Message-Id: <20230518155606.326cc8a860382d3a08cf5e21@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus, please merge this small batch of hotfixes.

There is a minor conflict in MAINTAINERS.

Thanks.



The following changes since commit ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2023-05-18-15-52

for you to fetch changes up to c7394fa9aa4ccd4e477626c4f7aef0b360c92efb:

  MAINTAINERS: Cleanup Arm Display IP maintainers (2023-05-17 15:24:34 -070=
0)

----------------------------------------------------------------
Eight hotfixes.  Four are cc:stable, the other four are for post-6.4
issues, or aren't considered suitable for backporting.

----------------------------------------------------------------
Domenico Cerasuolo (1):
      mm: fix zswap writeback race condition

Joan Bruguera Mic=F3 (1):
      mm: shrinkers: fix race condition on debugfs cleanup

Liviu Dudau (1):
      MAINTAINERS: Cleanup Arm Display IP maintainers

Lukas Bulwahn (1):
      MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS

Michael Ellerman (1):
      mm: kfence: fix false positives on big endian

Nhat Pham (1):
      zsmalloc: move LRU update from zs_map_object() to zs_malloc()

Peng Zhang (1):
      maple_tree: make maple state reusable after mas_empty_area()

Ryusuke Konishi (1):
      nilfs2: fix use-after-free bug of nilfs_root in nilfs_evict_inode()

 MAINTAINERS              |  7 +------
 fs/nilfs2/inode.c        | 18 ++++++++++++++++++
 include/linux/shrinker.h | 13 +++++++++++--
 lib/maple_tree.c         | 12 +++---------
 mm/kfence/kfence.h       |  2 +-
 mm/shrinker_debug.c      | 15 ++++++++++-----
 mm/vmscan.c              |  5 +++--
 mm/zsmalloc.c            | 36 +++++++++---------------------------
 mm/zswap.c               | 16 ++++++++++++++++
 9 files changed, 72 insertions(+), 52 deletions(-)


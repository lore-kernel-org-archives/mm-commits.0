Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF70DC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C110F60F5C
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhG2VxD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhG2VxD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9933560F23;
        Thu, 29 Jul 2021 21:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595579;
        bh=RxridwPM5IS+0BxOlATdq+bHi7KqfO6IIbdYPnDyNWk=;
        h=Date:From:To:Cc:Subject:From;
        b=MtP0euptf4GG6GKOf1YmrBp6q6e7KWPYvv75vfoxS3kJnyMbU3MDT0fJ0Jz73bRZx
         /3+bO0r/cCpvoRAonIdN8t9m1Pp44AeU1Gy/gaUHaf87VG2ixUHUVmNH10aX3SnXo5
         E9BwK1VU65iz1Gva6E3LuCxu+OJxx1erskdKmbfU=
Date:   Thu, 29 Jul 2021 14:52:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

7 patches, based on 7e96bf476270aecea66740a083e51b38c1371cd2.

Subsystems affected by this patch series:

  lib
  ocfs2
  mm/memcg
  mm/migration
  mm/slub
  mm/memcg

Subsystem: lib

    Matteo Croce <mcroce@microsoft.com>:
      lib/test_string.c: move string selftest in the Runtime Testing menu

Subsystem: ocfs2

    Junxiao Bi <junxiao.bi@oracle.com>:
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Subsystem: mm/memcg

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code

Subsystem: mm/migration

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/migrate: fix NR_ISOLATED corruption on 64-bit

Subsystem: mm/slub

    Shakeel Butt <shakeelb@google.com>:
      slub: fix unreclaimable slab stat for bulk free

Subsystem: mm/memcg

    Wang Hai <wanghai38@huawei.com>:
      mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()

 fs/ocfs2/file.c   |  103 ++++++++++++++++++++++++++++++++----------------------
 lib/Kconfig       |    3 -
 lib/Kconfig.debug |    3 +
 mm/memcontrol.c   |    3 +
 mm/migrate.c      |    2 -
 mm/slab.h         |    2 -
 mm/slub.c         |   22 ++++++-----
 7 files changed, 81 insertions(+), 57 deletions(-)


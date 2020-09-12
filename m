Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF282C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B2721531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599939140;
	bh=uVJBX/baGr6EWRZwxwhRCBVCLw7Ah6K9o88ObiOVMEg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tXp4JicQJDplOuH/eOY7ZhCnVSt4cvmoSJbWT2rvvrO5TIih4+XQnzvIsFrGdZ/cl
	 Di5Xh9hHwXbDGZk5XYfCOqxZ7U13AjsnBPDS8nkG4h38nMPgYfYigMoxDqNZVpIy4e
	 PNCIEcRx56hq51oHOoGtGkb9IFcjf8oEpec+nYGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILTcT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTcS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:32:18 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06C27207C3;
        Sat, 12 Sep 2020 19:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599939138;
        bh=uVJBX/baGr6EWRZwxwhRCBVCLw7Ah6K9o88ObiOVMEg=;
        h=Date:From:To:Subject:From;
        b=xYINwlMIuFUDcEcf4IhO3P4hpOl3nM5tK1rtngEBrxMGg+KkV9qTcUHsK5aFeTNdk
         v9QFjSWxO55ZMC1EZ/Zzx6LAbnH3dd2aC+k7WFL5hcQgJkjL33LzthyyCC6OnfPqtE
         RWYSYbw6MIB0D37k5nDDHdLbFdPoUVXU1D86c1XE=
Date:   Sat, 12 Sep 2020 12:32:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songmuchun@bytedance.com, chris@chrisdown.name,
        zangchunxin@bytedance.com
Subject:  + mm-vmscan-fix-infinite-loop-in-drop_slab_node.patch added
 to -mm tree
Message-ID: <20200912193217.2uMto%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix infinite loop in drop_slab_node
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-infinite-loop-in-drop_slab_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-infinite-loop-i=
n-drop_slab_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-infinite-loop-i=
n-drop_slab_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chunxin Zang <zangchunxin@bytedance.com>
Subject: mm/vmscan: fix infinite loop in drop_slab_node

On our server, there are about 10k memcg in one machine.  They use memory
very frequently.  When I tigger drop caches=EF=BC=8Cthe process will infini=
te
loop in drop_slab_node.

There are two reasons:

1. We have too many memcgs, even though one object freed in one memcg,
   the sum of object is bigger than 10.

2. We spend a lot of time in traverse memcg once.  So, the memcg who
   traversed at the first have been freed many objects.  Traverse memcg
   next time, the freed count bigger than 10 again.

We can get the following info through 'ps':

  root:~# ps -aux | grep drop
  root  357956 ... R    Aug25 21119854:55 echo 3 > /proc/sys/vm/drop_caches
  root 1771385 ... R    Aug16 21146421:17 echo 3 > /proc/sys/vm/drop_caches
  root 1986319 ... R    18:56 117:27 echo 3 > /proc/sys/vm/drop_caches
  root 2002148 ... R    Aug24 5720:39 echo 3 > /proc/sys/vm/drop_caches
  root 2564666 ... R    18:59 113:58 echo 3 > /proc/sys/vm/drop_caches
  root 2639347 ... R    Sep03 2383:39 echo 3 > /proc/sys/vm/drop_caches
  root 3904747 ... R    03:35 993:31 echo 3 > /proc/sys/vm/drop_caches
  root 4016780 ... R    Aug21 7882:18 echo 3 > /proc/sys/vm/drop_caches

Use bpftrace follow 'freed' value in drop_slab_node:

  root:~# bpftrace -e 'kprobe:drop_slab_node+70 {@ret=3Dhist(reg("bp")); }'
  Attaching 1 probe...
  ^B^C

  @ret:
  [64, 128)        1 |                                                    |
  [128, 256)      28 |                                                    |
  [256, 512)     107 |@                                                   |
  [512, 1K)      298 |@@@                                                 |
  [1K, 2K)       613 |@@@@@@@                                             |
  [2K, 4K)      4435 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [4K, 8K)       442 |@@@@@                                               |
  [8K, 16K)      299 |@@@                                                 |
  [16K, 32K)     100 |@                                                   |
  [32K, 64K)     139 |@                                                   |
  [64K, 128K)     56 |                                                    |
  [128K, 256K)    26 |                                                    |
  [256K, 512K)     2 |                                                    |

In the while loop, we can check whether the TASK_KILLABLE signal is set,
if so, we should break the loop.

Link: https://lkml.kernel.org/r/20200909152047.27905-1-zangchunxin@bytedanc=
e.com
Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-infinite-loop-in-drop_slab_node
+++ a/mm/vmscan.c
@@ -699,6 +699,9 @@ void drop_slab_node(int nid)
 	do {
 		struct mem_cgroup *memcg =3D NULL;
=20
+		if (fatal_signal_pending(current))
+			return;
+
 		freed =3D 0;
 		memcg =3D mem_cgroup_iter(NULL, NULL, NULL);
 		do {
_

Patches currently in -mm which might be from zangchunxin@bytedance.com are

mm-vmscan-fix-infinite-loop-in-drop_slab_node.patch


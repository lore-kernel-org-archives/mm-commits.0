Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730C4C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C8E722244
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633408;
	bh=XmIVWjJHnpo9RWteM6+P180+MeyHMi8nluOtkviaNvc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jKcJc415qwufCpfCSXuCdS+ym5ypqRPppHz540fcRo2nkuZOqGkCYKOgsFdkcKXy2
	 Y5cPJueH2xcBcg+fu0tHRMeu3R9An+6NpGCLfCJew3vVfEo9aSxANiVMLUIjJes/Me
	 3+TKLQjZqYsHg4zC/dzdXyR2kVukx81+WSVZZ1Tg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgJMX4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704752222F;
        Tue, 13 Oct 2020 23:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633406;
        bh=XmIVWjJHnpo9RWteM6+P180+MeyHMi8nluOtkviaNvc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r79imOq0QY/WRIsZWfj3+twDUS5lDXW9ur89d2Oi29NECnqklsrjUxmVohPZ627gL
         Z1LQVaOjXG8ZhvS6COZtLkgMBu9eTStHwGfoj/U0lf2OJw6BKnnaSZxOkp3P7qQqRy
         HrVjXvXT91MfivjtmV42fYo+zn+voSmkkeeBit0E=
Date:   Tue, 13 Oct 2020 16:56:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, willy@infradead.org, zangchunxin@bytedance.com
Subject:  [patch 152/181] mm/vmscan: fix infinite loop in
 drop_slab_node
Message-ID: <20201013235646.7AcfvZxnm%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chunxin Zang <zangchunxin@bytedance.com>
Subject: mm/vmscan: fix infinite loop in drop_slab_node

We have observed that drop_caches can take a considerable amount of
time (<put data here>).  Especially when there are many memcgs involved
because they are adding an additional overhead.

It is quite unfortunate that the operation cannot be interrupted by a
signal currently.  Add a check for fatal signals into the main loop so
that userspace can control early bailout.

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

  root:~# bpftrace -e 'kprobe:drop_slab_node+70 {@ret=hist(reg("bp")); }'
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

Link: https://lkml.kernel.org/r/20200909152047.27905-1-zangchunxin@bytedance.com
Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
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
 		struct mem_cgroup *memcg = NULL;
 
+		if (fatal_signal_pending(current))
+			return;
+
 		freed = 0;
 		memcg = mem_cgroup_iter(NULL, NULL, NULL);
 		do {
_

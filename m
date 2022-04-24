Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C16C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbiDXUhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239580AbiDXUhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:37:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B6156E2B
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA294B80EB6
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93351C385A9;
        Sun, 24 Apr 2022 20:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832441;
        bh=yhkk09AOGda22dF8x2wNhCpsZp4jo9Ti22kBSMvx6OE=;
        h=Date:To:From:Subject:From;
        b=tytphPIFNEhOi+kFLnDby7+o30JDIO6B3qaOJGogZfC5Q4FP3so0roBJdri7F25x/
         Rozv5qAzoS9F9d+4Sv/sDnOoEzzgOfH3b51+3mN4tUPptDPyeWQHREMoByGBOeu0MJ
         PodRFS+fTxANPM6VhzJvzzeIM6kHhlXXys1Gy/os=
Date:   Sun, 24 Apr 2022 13:34:00 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-removing-racy-check-in-test_memcg_sock.patch added to -mm tree
Message-Id: <20220424203401.93351C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove racy check in test_memcg_sock()
has been added to the -mm tree.  Its filename is
     cgroup-removing-racy-check-in-test_memcg_sock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-removing-racy-check-in-test_memcg_sock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-removing-racy-check-in-test_memcg_sock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Vernet <void@manifault.com>
Subject: cgroup: remove racy check in test_memcg_sock()

test_memcg_sock() in the cgroup memcg tests, verifies expected memory
accounting for sockets.  The test forks a process which functions as a TCP
server, and sends large buffers back and forth between itself (as the TCP
client) and the forked TCP server.  While doing so, it verifies that
memory.current and memory.stat.sock look correct.

There is currently a check in tcp_client() which asserts memory.current >=
memory.stat.sock.  This check is racy, as between memory.current and
memory.stat.sock being queried, a packet could come in which causes
mem_cgroup_charge_skmem() to be invoked.  This could cause
memory.stat.sock to exceed memory.current.  Reversing the order of
querying doesn't address the problem either, as memory may be reclaimed
between the two calls.  Instead, this patch just removes that assertion
altogether, and instead relies on the values_close() check that follows to
validate the expected accounting.

Link: https://lkml.kernel.org/r/20220423155619.3669555-5-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-removing-racy-check-in-test_memcg_sock
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1082,9 +1082,6 @@ static int tcp_client(const char *cgroup
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		if (current < sock)
-			goto close_sk;
-
 		if (values_close(current, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
_

Patches currently in -mm which might be from void@manifault.com are

cgroups-refactor-children-cgroups-in-memcg-tests.patch
cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch
cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch
cgroup-removing-racy-check-in-test_memcg_sock.patch
cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C3BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383815AbiEMTVu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383868AbiEMTVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD926F1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1DB96225C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CBCC34100;
        Fri, 13 May 2022 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469680;
        bh=wcaWrBk8gGd8TrAAgwJ2pgs3nxELFH9X1D4Aa041b1c=;
        h=Date:To:From:Subject:From;
        b=ZM5vEde+TuIeL3QDIt8pS+xeg7pi46iLsI8/ank8+jw0eB/V1+Zvd2F45mBDEGrb+
         hsPBHhKOMBi5GV4Jg9IpbeZ31YcNNf65rGML+MRZt8lX5Plb3l/T/jDLO9gJUlwwaU
         hp6KBpZSWfNF+O0a06gg2R7PtFXafvfBEVPrDi64=
Date:   Fri, 13 May 2022 12:21:19 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-removing-racy-check-in-test_memcg_sock.patch removed from -mm tree
Message-Id: <20220513192120.10CBCC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: remove racy check in test_memcg_sock()
has been removed from the -mm tree.  Its filename was
     cgroup-removing-racy-check-in-test_memcg_sock.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1102,9 +1102,6 @@ static int tcp_client(const char *cgroup
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



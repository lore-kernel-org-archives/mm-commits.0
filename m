Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6B0EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 18:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjFSSfL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 14:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjFSSfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 14:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0DD13D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 11:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F7660E16
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA035C433C0;
        Mon, 19 Jun 2023 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687199709;
        bh=cVzcO1HwPjGM47MKMY4B2DkIIZKhJyvBP8OFQEWKu70=;
        h=Date:To:From:Subject:From;
        b=BMvBJK6ipFfuaq0K9enixDyvkVe3JdpnDUxPLikbfIQ3B+prq4SRnwqMIUp90SZ0R
         lpeMfnJmGpXwRJKTDnUc6YJxqtB+0o4SdrKntxOS9HVa6FSzQ+YHRXUwomxT0W507I
         5VG67HuiTKjCo+CwfSlkypEMuyfryg8HZsKvD56A=
Date:   Mon, 19 Jun 2023 11:35:08 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        hannes@cmpxchg.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch added to mm-unstable branch
Message-Id: <20230619183508.DA035C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix unexpected failure on test_memcg_sock
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: selftests: cgroup: fix unexpected failure on test_memcg_sock
Date: Mon, 19 Jun 2023 12:47:35 +0000

Before server got a client connection, there were some memory allocations
in the test memcg, such as user stack.  So do not count those allocations
which are not related to socket when checking socket memory accounting.

Link: https://lkml.kernel.org/r/20230619124735.2124-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -989,7 +989,9 @@ static int tcp_client(const char *cgroup
 	char servport[6];
 	int retries = 0x10; /* nice round number */
 	int sk, ret;
+	long allocated;
 
+	allocated = cg_read_long(cgroup, "memory.current");
 	snprintf(servport, sizeof(servport), "%hd", port);
 	ret = getaddrinfo(server, servport, NULL, &ai);
 	if (ret)
@@ -1017,7 +1019,8 @@ static int tcp_client(const char *cgroup
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		if (values_close(current, sock, 10)) {
+		/* exclude the memory not related to socket connection */
+		if (values_close(current - allocated, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch


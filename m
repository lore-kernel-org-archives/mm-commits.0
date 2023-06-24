Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDE0EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjFXAAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjFXAAK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C102705
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93929615E3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F8C433C0;
        Sat, 24 Jun 2023 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564809;
        bh=tlDh/GqOQ3yPaN45+fM8EXjj5RtW/XZEVZmsU6zdhzw=;
        h=Date:To:From:Subject:From;
        b=wq4sQpc/dzsObhN0PuFcVTUZ03r1s+3xwB94KrdIaT+e1tAFdhDQhqhecFOmjd8y0
         a3zuWXELLqjFN6kmyYmGkig1lD5qP3opcs/dxU9uNQodTjYeGdHHDSyZjy2PA5U961
         BBd8mjLmGlq/dNBjo1VrCVOVKts43uuOAl3Ryh60=
Date:   Fri, 23 Jun 2023 17:00:08 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        hannes@cmpxchg.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch removed from -mm tree
Message-Id: <20230624000008.E73F8C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix unexpected failure on test_memcg_sock
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



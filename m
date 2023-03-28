Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C3CC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjC1XVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjC1XV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5833C2D52
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA84A619F3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7ADC433EF;
        Tue, 28 Mar 2023 23:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045678;
        bh=C9XFgwrWl+5qne21Jci7PlLY+CUOQBCvsQGVxvyjTTQ=;
        h=Date:To:From:Subject:From;
        b=bYt1AMTjGriHe2mt7GI+g/f07rM6xgyvp5a4WYQWZT0ZjHtJgU2XXZE+ZpECNC55q
         xuzRTN9gJXNIC47px/b/Qx+n5KsNG9g7XSKRh9vebckg5ORqadcWwYARbeRX/+q4bG
         vMcbPeoNaJdRkh0DO+vCfYNVfeKqMNcPZlW6QlY0=
Date:   Tue, 28 Mar 2023 16:21:17 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org,
        songmuchun@bytedance.com, shuah@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        ivan.orlov0322@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch removed from -mm tree
Message-Id: <20230328232118.4E7ADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: add 'malloc' failures checks in test_memcontrol
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: selftests: cgroup: add 'malloc' failures checks in test_memcontrol
Date: Sun, 26 Feb 2023 16:16:33 +0300

There are several 'malloc' calls in test_memcontrol, which can be
unsuccessful.  This patch will add 'malloc' failures checking to give more
details about test's fail reasons and avoid possible undefined behavior
during the future null dereference (like the one in
alloc_anon_50M_check_swap function).

Link: https://lkml.kernel.org/r/20230226131634.34366-1-ivan.orlov0322@gmail.com
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   15 +++++++++++++
 1 file changed, 15 insertions(+)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -98,6 +98,11 @@ static int alloc_anon_50M_check(const ch
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -211,6 +216,11 @@ static int alloc_anon_noexit(const char
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -778,6 +788,11 @@ static int alloc_anon_50M_check_swap(con
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
_

Patches currently in -mm which might be from ivan.orlov0322@gmail.com are



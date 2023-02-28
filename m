Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0772C7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 01:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjB1B7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1B7l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 20:59:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D7D2D55
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 17:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA74C60CF2
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 01:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFABC433D2;
        Tue, 28 Feb 2023 01:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677549579;
        bh=DLXymiz9gM8vF/FtD4XDyvhAdD30UTlcnobLmbaV70U=;
        h=Date:To:From:Subject:From;
        b=aaIQU33Tsp3jOxT1MGVWdqHaemR/ccwHI1V9J0rTH0bstFurcNLWnVvrMcVK7jUE2
         qVgR7SEeEYw40ud+efG42NijjeYsc3qpb0KjSTOFpQH6cx1QZtq5M+NthX1bEMzpyD
         IE17viz0oUf/5I3xB1dV0t/oRRf9YHIDA0EjBDNg=
Date:   Mon, 27 Feb 2023 17:59:38 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org,
        songmuchun@bytedance.com, shuah@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        ivan.orlov0322@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch added to mm-unstable branch
Message-Id: <20230228015939.0DFABC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: add 'malloc' failures checks in test_memcontrol
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch

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

selftests-cgroup-add-malloc-failures-checks-in-test_memcontrol.patch


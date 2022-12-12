Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDE5C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiLLCRg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiLLCQ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02FDFD1
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4764F60EC6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E69FC433EF;
        Mon, 12 Dec 2022 02:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811301;
        bh=dX8cIkIuDeHC5JnRhfhl2TTPIKzQkQI4ZUE1RXj22aw=;
        h=Date:To:From:Subject:From;
        b=R+zrYgfLnO2K2m93VpH3L9r6lrzPxAhyFeb2IjtHbOGq0Og7T0dnJWQolc+/F8j/d
         jIi+YNrZt8sieLYJ9LyynAO///lXcwtNxv3ZcCpe3z4nDJoiBj8Z1qVzGGcSBDECuX
         4YIX7y82gSYZmStSwIJXYTbKnZt3wH8rMKeYYkgk=
Date:   Sun, 11 Dec 2022 18:15:00 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch removed from -mm tree
Message-Id: <20221212021501.9E69FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
has been removed from the -mm tree.  Its filename was
     selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
Date: Mon, 5 Dec 2022 20:37:14 +0100

The tests fail to compile in some environments (e.g., Debian 11.5 on x86).
Let's simply conditionally define MADV_POPULATE_(READ|WRITE) if not
already defined, similar to how the khugepaged.c test handles it.

Link: https://lkml.kernel.org/r/20221205193716.276024-3-david@redhat.com
Fixes: 39b2e5cae43d ("selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/madv_populate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -20,6 +20,13 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ	22
+#endif /* MADV_POPULATE_READ */
+#ifndef MADV_POPULATE_WRITE
+#define MADV_POPULATE_WRITE	23
+#endif /* MADV_POPULATE_WRITE */
+
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
  */
_

Patches currently in -mm which might be from david@redhat.com are



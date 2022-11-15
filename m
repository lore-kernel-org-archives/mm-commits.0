Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF86C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbiKOWdD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiKOWcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868BA6260
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D47DB81A1C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1482C433D7;
        Tue, 15 Nov 2022 22:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551541;
        bh=o9JJo+GYc746y6hcFhImJUjd/Z3H9uPAsE4r7H7VzLo=;
        h=Date:To:From:Subject:From;
        b=C2BwlrzytOHN5LqzSPv1Kd0632CSTND6NpjfvlmrHzwLNe1wxK04dGuCPDakCsWXl
         YIJsyfXvZ/o2fU5N+Ur4D99M9DCMvTofleWx8asURMyxzmdbU4veDndTcmznG7GFUb
         ZgIVBurG16GVPz0pUqxJJYRCrCH2FsYIi3DpCCX8=
Date:   Tue, 15 Nov 2022 14:32:21 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-fixup-uptime-test.patch removed from -mm tree
Message-Id: <20221115223221.D1482C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: fixup uptime selftest
has been removed from the -mm tree.  Its filename was
     proc-fixup-uptime-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fixup uptime selftest
Date: Mon, 24 Oct 2022 21:08:09 +0300

syscall(3) returns -1 and sets errno on error, unlike "syscall"
instruction.

Systems which have <= 32/64 CPUs are unaffected. Test won't bounce
to all CPUs before completing if there are more of them.

Link: https://lkml.kernel.org/r/Y1bUiT7VRXlXPQa1@p183
Fixes: 1f5bd0547654 ("proc: selftests: test /proc/uptime")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-uptime-002.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/proc-uptime-002.c~proc-fixup-uptime-test
+++ a/tools/testing/selftests/proc/proc-uptime-002.c
@@ -17,6 +17,7 @@
 // while shifting across CPUs.
 #undef NDEBUG
 #include <assert.h>
+#include <errno.h>
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <stdlib.h>
@@ -54,7 +55,7 @@ int main(void)
 		len += sizeof(unsigned long);
 		free(m);
 		m = malloc(len);
-	} while (sys_sched_getaffinity(0, len, m) == -EINVAL);
+	} while (sys_sched_getaffinity(0, len, m) == -1 && errno == EINVAL);
 
 	fd = open("/proc/uptime", O_RDONLY);
 	assert(fd >= 0);
_

Patches currently in -mm which might be from adobriyan@gmail.com are



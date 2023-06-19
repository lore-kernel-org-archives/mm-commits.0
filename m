Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD375EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjFSXU3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjFSXU1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5DEF9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3B860F56
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0587C433C8;
        Mon, 19 Jun 2023 23:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216825;
        bh=BiZ60iy/tkxBAUkqraMD5sfD5YIjalUwisokHAipVUk=;
        h=Date:To:From:Subject:From;
        b=DoV0le9cQOzn6VREYZZWXoAa4SfwYPFJtBJOpzffuCZimi2MpxS5Hc2yAL8SnQ0Jm
         LCnYKXkNifDDt1NvLN5XmgUUbp/f8hiQcz47RvciD9CS+qxAe03xB6XOhOYSBN1UgQ
         WOpBGCdtiTZL6E3HIoh+XronBUzPd2W9nv/NInJc=
Date:   Mon, 19 Jun 2023 16:20:25 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch removed from -mm tree
Message-Id: <20230619232025.C0587C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix "warning: expression which evaluates to zero..." in mlock2-tests.c
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix "warning: expression which evaluates to zero..." in mlock2-tests.c
Date: Tue, 6 Jun 2023 00:16:29 -0700

The stop variable is a char*, and the code was assigning a char value to
it. This was generating a warning when compiling with clang.

However, as both David and Peter pointed out, stop is not even used
after the problematic assignment to a char type. So just delete that
line entirely.

Link: https://lkml.kernel.org/r/20230606071637.267103-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -50,7 +50,6 @@ static int get_vm_area(unsigned long add
 			printf("cannot parse /proc/self/maps\n");
 			goto out;
 		}
-		stop = '\0';
 
 		sscanf(line, "%lx", &start);
 		sscanf(end_addr, "%lx", &end);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BC6EE498D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Aug 2023 18:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbjHRSbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Aug 2023 14:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379446AbjHRSbJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2023 14:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E83BF
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 11:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3039619D7
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 18:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D8C433C8;
        Fri, 18 Aug 2023 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692383467;
        bh=7Pk0YS8SDeSRJOJ1o/DfWXFtBthdQzjKpNDVwbKhNSQ=;
        h=Date:To:From:Subject:From;
        b=WSXnKncuLVJh5IRMG+ELa7wNEBCFZNRCX4jmNVkp7K6ypW1N/p0YThBXg5z+q2Lqw
         ymhLLOYY7HwlRqwqgaZ1cm6q87TjbWf/xXd/TBYn4L/30HSiR3WViIgJl+uCQeqwlB
         DqN8XxXC5WDOLNonWczHGNAWRLt/Xl+uGyhJPp+8=
Date:   Fri, 18 Aug 2023 11:31:06 -0700
To:     mm-commits@vger.kernel.org, tuananhlfc@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-warning-comparing-pointer-to-0.patch added to mm-unstable branch
Message-Id: <20230818183107.553D8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix WARNING comparing pointer to 0
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-warning-comparing-pointer-to-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-warning-comparing-pointer-to-0.patch

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
From: Anh Tuan Phan <tuananhlfc@gmail.com>
Subject: selftests/mm: fix WARNING comparing pointer to 0
Date: Thu, 17 Aug 2023 23:00:33 +0700

Remove comparing pointer to 0 to avoid this warning from coccinelle:

./tools/testing/selftests/mm/map_populate.c:80:16-17: WARNING comparing pointer to 0, suggest !E
./tools/testing/selftests/mm/map_populate.c:80:16-17: WARNING comparing pointer to 0

Link: https://lkml.kernel.org/r/20230817160033.90079-1-tuananhlfc@gmail.com
Signed-off-by: Anh Tuan Phan <tuananhlfc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_populate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-fix-warning-comparing-pointer-to-0
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -77,7 +77,7 @@ int main(int argc, char **argv)
 	unsigned long *smap;
 
 	ftmp = tmpfile();
-	BUG_ON(ftmp == 0, "tmpfile()");
+	BUG_ON(!ftmp, "tmpfile()");
 
 	ret = ftruncate(fileno(ftmp), MMAP_SZ);
 	BUG_ON(ret, "ftruncate()");
_

Patches currently in -mm which might be from tuananhlfc@gmail.com are

selftests-mm-fix-warning-comparing-pointer-to-0.patch


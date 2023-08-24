Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F3EC727BB
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbjHXXWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244108AbjHXXWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91806FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2760A64B19
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7CAC433C7;
        Thu, 24 Aug 2023 23:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919321;
        bh=9GudH6Q2MnhEuD0KKIl7b2ZDCTwBqR424XJB6OpFd04=;
        h=Date:To:From:Subject:From;
        b=0smNW7ZkvAkmrYVcGq/Q4rwLhSQ+//JXW1mptGw7LxvPtbrya4TUNCatfmNwImhqo
         dBbPEpmyAYXu4copsoq9SYH8mmXRznRVXdWkdWwXQyDDM8PWsPSFS+EGHEhSA/2Ong
         rA3ymlzxrUyW+Kh7uIM7PE38MZw+KC2+qbTmjOSY=
Date:   Thu, 24 Aug 2023 16:22:01 -0700
To:     mm-commits@vger.kernel.org, tuananhlfc@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-warning-comparing-pointer-to-0.patch removed from -mm tree
Message-Id: <20230824232201.7F7CAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix WARNING comparing pointer to 0
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-warning-comparing-pointer-to-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



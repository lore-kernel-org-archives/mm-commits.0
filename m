Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAF7C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 16:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjK3QV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 11:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjK3QVp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 11:21:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86C61708
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 08:21:45 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C38C433C8;
        Thu, 30 Nov 2023 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701361305;
        bh=IsuLchkisKCPf06Sg0rfn3RYSKEA5YkLuf8JE4yI1GI=;
        h=Date:To:From:Subject:From;
        b=udS59MvWueh/ZspF5T720u06AT3JfXMpkzItIyS2Kx1qRYmW+qLzh5Twu3vMb4rPa
         8oVWA3QGjzYJcwvvpnJWKo+KDqt838WYVQ9NGWtkVoMdJDROuAukkd8ad52kIBqt8i
         kSPa6n62J7OZBNfRrtwW7wxXlR9EYvLjnUlOzyuk=
Date:   Thu, 30 Nov 2023 08:21:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, trix@redhat.com,
        tony.luck@intel.com, stable@vger.kernel.org, pcc@google.com,
        ndesaulniers@google.com, nathan@kernel.org, jiaqiyan@google.com,
        ira.weiny@intel.com, suhui@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-fix-a-memory-copy-problem-in-memcpy_from_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231130162145.87C38C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: fix a memory copy problem in memcpy_from_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     highmem-fix-a-memory-copy-problem-in-memcpy_from_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-fix-a-memory-copy-problem-in-memcpy_from_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Su Hui <suhui@nfschina.com>
Subject: highmem: fix a memory copy problem in memcpy_from_folio
Date: Thu, 30 Nov 2023 11:40:18 +0800

Clang static checker complains that value stored to 'from' is never read. 
And memcpy_from_folio() only copy the last chunk memory from folio to
destination.  Use 'to += chunk' to replace 'from += chunk' to fix this
typo problem.

Link: https://lkml.kernel.org/r/20231130034017.1210429-1-suhui@nfschina.com
Fixes: b23d03ef7af5 ("highmem: add memcpy_to_folio() and memcpy_from_folio()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-fix-a-memory-copy-problem-in-memcpy_from_folio
+++ a/include/linux/highmem.h
@@ -454,7 +454,7 @@ static inline void memcpy_from_folio(cha
 		memcpy(to, from, chunk);
 		kunmap_local(from);
 
-		from += chunk;
+		to += chunk;
 		offset += chunk;
 		len -= chunk;
 	} while (len > 0);
_

Patches currently in -mm which might be from suhui@nfschina.com are

highmem-fix-a-memory-copy-problem-in-memcpy_from_folio.patch


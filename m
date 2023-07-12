Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34EAC001DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjGLSQL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjGLSQK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0B7E4F;
        Wed, 12 Jul 2023 11:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A79C6182C;
        Wed, 12 Jul 2023 18:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E522C433C8;
        Wed, 12 Jul 2023 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689185768;
        bh=BJce494qO8YB0jo/RpNOnMxKk91N2i3DRKGfIxO7ars=;
        h=Date:To:From:Subject:From;
        b=TvWcePxD0bFhbnEUV8m0wy0a2N/bQtJBa90/Bb2ceYKHpjPeTKKaIrAREMRzuldY7
         cUTmb8l93z0tSjARqNyHfQTGxLfzFcDDqo7ZGluCAg+Yy/URtvsLmfg0MIxMSI3Ci7
         E6X2YIQFNwDNxdUNfCy4GIb1ERREiSS0DcPmaVcA=
Date:   Wed, 12 Jul 2023 11:16:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, david@redhat.com, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mkdirty-fix-incorrect-position-of-endif.patch added to mm-hotfixes-unstable branch
Message-Id: <20230712181608.7E522C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: mkdirty: Fix incorrect position of #endif
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-mkdirty-fix-incorrect-position-of-endif.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mkdirty-fix-incorrect-position-of-endif.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests/mm: mkdirty: Fix incorrect position of #endif
Date: Wed, 12 Jul 2023 14:46:48 +0100

The #endif is the wrong side of a } causing a build failure when
__NR_userfaultfd is not defined.  Fix this by moving the #end to enclose
the }

Link: https://lkml.kernel.org/r/20230712134648.456349-1-colin.i.king@gmail.com
Fixes: 9eac40fc0cc7 ("selftests/mm: mkdirty: test behavior of (pte|pmd)_mkdirty on VMAs without write permissions")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mkdirty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mkdirty.c~selftests-mm-mkdirty-fix-incorrect-position-of-endif
+++ a/tools/testing/selftests/mm/mkdirty.c
@@ -321,8 +321,8 @@ close_uffd:
 munmap:
 	munmap(dst, pagesize);
 	free(src);
-#endif /* __NR_userfaultfd */
 }
+#endif /* __NR_userfaultfd */
 
 int main(void)
 {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-mkdirty-fix-incorrect-position-of-endif.patch


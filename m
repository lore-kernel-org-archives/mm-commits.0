Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE4CC001B0
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jul 2023 15:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjGEPi4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjGEPiz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 11:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA25171D
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 08:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201FC615E9
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 15:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DDFC433C7;
        Wed,  5 Jul 2023 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688571531;
        bh=gOfILxZeSNcZesR5PiGEDRKdceIJCwXTsfjN7C+lT9w=;
        h=Date:To:From:Subject:From;
        b=kQU1JV1Vpy/X5P1ScwC83tA87TkH1B/xqHCe63wRIoM2T4tqrDKY/ycpZr1sjTZ5g
         QqEnPAjhxI7g3QOdIDRI5aAU/gaR87OXyYg6P2EAx9w4FRu/ylHkzowabebsMao+9x
         TamaYutLXT3zqHRamXtiTEUHlnSQQQC79vnqGOUA=
Date:   Wed, 05 Jul 2023 08:38:50 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        mike.kravetz@oracle.com, lkp@intel.com, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        asmadeus@codewreck.org, jeffxu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch added to mm-unstable branch
Message-Id: <20230705153851.75DDFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

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
From: Jeff Xu <jeffxu@google.com>
Subject: selftests/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
Date: Wed, 5 Jul 2023 06:33:15 +0000

Add selftest for sysctl vm.memfd_noexec is 2
(MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED)

memfd_create(.., MFD_EXEC) should fail in this case.

Link: https://lkml.kernel.org/r/20230705063315.3680666-3-jeffxu@google.com
Reported-by: Dominique Martinet <asmadeus@codewreck.org>
Closes: https://lore.kernel.org/linux-mm/CABi2SkXUX_QqTQ10Yx9bBUGpN1wByOi_=gZU6WEy5a8MaQY3Jw@mail.gmail.com/T/
Signed-off-by: Jeff Xu <jeffxu@google.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -1147,6 +1147,11 @@ static void test_sysctl_child(void)
 	sysctl_assert_write("2");
 	mfd_fail_new("kern_memfd_sysctl_2",
 		MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_fail_new("kern_memfd_sysctl_2_MFD_EXEC",
+		MFD_CLOEXEC | MFD_EXEC);
+	fd = mfd_assert_new("", 0, MFD_NOEXEC_SEAL);
+	close(fd);
+
 	sysctl_fail_write("0");
 	sysctl_fail_write("1");
 }
_

Patches currently in -mm which might be from jeffxu@google.com are

mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch
selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F7FC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbjHKXAN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbjHKW7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE01D3A92
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BB5467657
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B659CC433C8;
        Fri, 11 Aug 2023 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794765;
        bh=RuC1a5svnplHa7tGwDNU13ThadWFdN6GEO1/gtdNai0=;
        h=Date:To:From:Subject:From;
        b=kQYUPf/DIypAQL4yPIfsSQ4wM9ALMvNyN9V3i2quySaErJJ7BlTHFcZqhWhIg6Y7t
         BMnzLhRqTf1bxvvVq26e/4dhifmRQD/CXdGlt094l6kZ7xS4dlcLHMrk3bpiaoNLAu
         NRr4ixxQW9RfW5OD+XodyY6U48xe/QT8PQzROWW8=
Date:   Fri, 11 Aug 2023 15:59:25 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        mike.kravetz@oracle.com, lkp@intel.com, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        asmadeus@codewreck.org, jeffxu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch removed from -mm tree
Message-Id: <20230811225925.B659CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
has been removed from the -mm tree.  Its filename was
     selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



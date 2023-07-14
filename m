Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C144EB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 16:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbjGNQX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbjGNQX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 12:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F592726
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 09:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4BFB61D6D
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 16:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA1EC433C8;
        Fri, 14 Jul 2023 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689351805;
        bh=d02yO7RIsp7gm/PZzVA3OHPTTxjMYvWzJHj68el9oTE=;
        h=Date:To:From:Subject:From;
        b=gyTGQCQnV4ZVWnPIp/JBoj+bdyvlkWgciA0vZEmstaysoMusr67LE1JNnUHZmZF3d
         9QPpjwOD5ihiJu4KOFIv/BhHPBqytRKNN9uqy1sC6Cth8xW5HvFZxt2XQneR9EwhN3
         uslG2Qmv//PxqMBaZNAlgSMLTplJrLuoKI/Vcdps=
Date:   Fri, 14 Jul 2023 09:23:24 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        revest@chromium.org, Liam.Howlett@oracle.com, jhubbard@nvidia.com,
        jglisse@redhat.com, david@redhat.com, broonie@kernel.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-give-scripts-execute-permission.patch added to mm-hotfixes-unstable branch
Message-Id: <20230714162325.0DA1EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: give scripts execute permission
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-give-scripts-execute-permission.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-give-scripts-execute-permission.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: give scripts execute permission
Date: Thu, 13 Jul 2023 14:54:33 +0100

When run under run_vmtests.sh, test scripts were failing to run with
"permission denied" due to the scripts not being executable.

It is also annoying not to be able to directly invoke run_vmtests.sh,
which is solved by giving also it the execute permission.

Link: https://lkml.kernel.org/r/20230713135440.3651409-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/test_hmm.sh b/tools/testing/selftests/mm/test_hmm.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/test_vmalloc.sh b/tools/testing/selftests/mm/test_vmalloc.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mm/write_hugetlb_memory.sh b/tools/testing/selftests/mm/write_hugetlb_memory.sh
old mode 100644
new mode 100755
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-give-scripts-execute-permission.patch


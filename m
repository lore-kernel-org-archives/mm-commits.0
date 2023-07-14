Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00E3C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 16:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbjGNQZ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbjGNQZY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 12:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952C3E5C
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 09:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3076961D67
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 16:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73307C433C8;
        Fri, 14 Jul 2023 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689351922;
        bh=PBvsCG52UCeGO8hNq4A7RA4kZ6RIarT0G8B+gzxlnFw=;
        h=Date:To:From:Subject:From;
        b=kJcfBairOmjgQwg0TTb4HkNckKJX+CKa5zUd7x4hgtCuZWCzu5nJBpGdpa8BTZiTw
         aziGhSS++U9TII78uqcXue0E02rXLCNF2JcsC/RjNEmYN7bgeKTUrGy1LLuG9tCxgS
         2L2eAtjxPxt2ciUJ9HMPJ6NEzOhER8PPI/3UTMC0=
Date:   Fri, 14 Jul 2023 09:25:21 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        revest@chromium.org, Liam.Howlett@oracle.com, jhubbard@nvidia.com,
        jglisse@redhat.com, david@redhat.com, broonie@kernel.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-give-scripts-execute-permission.patch removed from -mm tree
Message-Id: <20230714162522.73307C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: give scripts execute permission
has been removed from the -mm tree.  Its filename was
     selftests-mm-give-scripts-execute-permission.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



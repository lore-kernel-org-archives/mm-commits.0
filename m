Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE665CA1009
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 20:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbjIEUQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 16:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbjIEUQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 16:16:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64211AD
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 13:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3AC0ECE10AF
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D524C433C8;
        Tue,  5 Sep 2023 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929764;
        bh=5Dtn5stnbJGsdzNUhVs3G23DdPBUf/9A8g5g8hSjpEc=;
        h=Date:To:From:Subject:From;
        b=djiPWAsMb5jGK14k7XavSZkqCbW9O/i2Xohuy/9Iuvns5bHi89Gw7Wz4Tcn4JJBVn
         JTgsgkJ9P5tI86j2lAC/OtyKhQSpt1dvtqKQvGVWTXU+RwNoT34PdUKJcEFmS+s1EF
         2dhBNmUIwKlfALasKWUxTHQd2VO+SBVXVpxuJi1E=
Date:   Tue, 05 Sep 2023 09:02:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch added to mm-unstable branch
Message-Id: <20230905160244.8D524C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: fix failure case when new remap region was not found
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch

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
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: selftests: mm: fix failure case when new remap region was not found
Date: Sun, 3 Sep 2023 15:13:24 +0000

When a valid remap region could not be found, the source mapping is not
cleaned up.  Fix the goto statement such that the clean up happens.

Link: https://lkml.kernel.org/r/20230903151328.2981432-4-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-failure-case-when-new-remap-region-was-not-found
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -316,7 +316,7 @@ static long long remap_region(struct con
 		if (addr + c.dest_alignment < addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
-			goto out;
+			goto clean_up_src;
 		}
 		addr += c.dest_alignment;
 	}
_

Patches currently in -mm which might be from joel@joelfernandes.org are

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch
mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch
mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch
selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch
selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch
selftests-mm-add-a-test-for-remapping-to-area-immediately-after-existing-mapping.patch
selftests-mm-add-a-test-for-remapping-within-a-range.patch
selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch


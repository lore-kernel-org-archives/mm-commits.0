Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250FCC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjDFCtO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjDFCsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC9D7EF0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C26E6421F
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DEBC433D2;
        Thu,  6 Apr 2023 02:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749146;
        bh=ZIkwab7oKrnIQBBssRMrXwPWN2k/axhCHk5mwjGrrII=;
        h=Date:To:From:Subject:From;
        b=vOugdhQtAaNcrEW/3QkQtX2tkzZ8rAoZz2CXXzhjSYIk59bYbjNkr/SX9cT2oSg0c
         q3Pvgjt7IcH6uM65r/YRIsjZ8wxdnWCmKKglPL8T8ugW7GnClmPP10teNDmviB6qFp
         vaatm49CL7vxApehunG7OBbn7hLHYSHNe3tsMpb0=
Date:   Wed, 05 Apr 2023 19:45:46 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-set-overcommit_policy-as-overcommit_always.patch removed from -mm tree
Message-Id: <20230406024546.97DEBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: set overcommit_policy as OVERCOMMIT_ALWAYS
has been removed from the -mm tree.  Its filename was
     selftests-mm-set-overcommit_policy-as-overcommit_always.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests/mm: set overcommit_policy as OVERCOMMIT_ALWAYS
Date: Thu, 23 Mar 2023 11:31:21 +0530

The kernel's default behaviour is to obstruct the allocation of high
virtual address as it handles memory overcommit in a heuristic manner. 
Setting the parameter as OVERCOMMIT_ALWAYS, ensures kernel isn't
susceptible to the availability of a platform's physical memory when
denying a memory allocation request.

Link: https://lkml.kernel.org/r/20230323060121.1175830-4-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-set-overcommit_policy-as-overcommit_always
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -220,7 +220,15 @@ CATEGORY="mremap" run_test ./mremap_test
 CATEGORY="hugetlb" run_test ./thuge-gen
 
 if [ $VADDR64 -ne 0 ]; then
+
+	# set overcommit_policy as OVERCOMMIT_ALWAYS so that kernel
+	# allows high virtual address allocation requests independent
+	# of platform's physical memory.
+
+	prev_policy=$(cat /proc/sys/vm/overcommit_memory)
+	echo 1 > /proc/sys/vm/overcommit_memory
 	CATEGORY="hugevm" run_test ./virtual_address_range
+	echo $prev_policy > /proc/sys/vm/overcommit_memory
 
 	# virtual address 128TB switch test
 	CATEGORY="hugevm" run_test ./va_128TBswitch.sh
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are



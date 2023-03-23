Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10062C7619A
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 22:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCWWRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 18:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjCWWRg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 18:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF089231F2
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 15:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6248E628E5
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 22:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB092C433EF;
        Thu, 23 Mar 2023 22:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679609854;
        bh=6FVe7EM1TuAdHuJo1NZVUgFDTEfDiot9z1RnCBg9xDc=;
        h=Date:To:From:Subject:From;
        b=iRbDVI7yjwOq4X3NuNAFOxbgH30dH2hkqF0yX0abn4Ti4Z678pSUtbOJAJFQMCgCW
         bA+pBtSe3F8UJ2GZGsfVjykyJxoQpUyyEPazjmBGAiDMERtCLxhvhKASwEoWP9g/NV
         ymlW8DSugRdFjpExEKqvtLqJuTg4EEGnfGWbvOnc=
Date:   Thu, 23 Mar 2023 15:17:34 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-set-overcommit_policy-as-overcommit_always.patch added to mm-unstable branch
Message-Id: <20230323221734.BB092C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: set overcommit_policy as OVERCOMMIT_ALWAYS
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-set-overcommit_policy-as-overcommit_always.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-set-overcommit_policy-as-overcommit_always.patch

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

selftests-mm-change-map_chunk_size.patch
selftests-mm-change-nr_chunks_high-for-aarch64.patch
selftests-mm-set-overcommit_policy-as-overcommit_always.patch


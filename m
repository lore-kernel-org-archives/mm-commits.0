Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DCEC35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2592620754
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601676441;
	bh=VmrtmSeCMMTwOEfHRx0X11n/H6kNTfeNouTYudQ2v8I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DYTvCpPGelMJgeqy88UMZMenxu0HQ34CFOzFh7aR3Nu4eOezwBjiqaYkIkGc8oidk
	 P73KjQC3RR8tyoPdKOeNU4xNoVQg68ScTRsYj3u05R/3aMWl0eJl3V4Oqkjx2dl+lv
	 EpwfN6zU4NDqCd1u8r1AvU5MyO969RTBORM0Uabg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgJBWHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJBWHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 18:07:20 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBDCF20719;
        Fri,  2 Oct 2020 22:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601676440;
        bh=VmrtmSeCMMTwOEfHRx0X11n/H6kNTfeNouTYudQ2v8I=;
        h=Date:From:To:Subject:From;
        b=Dbbr3zkY2Wx0i2JPjdWLWxgREZnJgd8qCIKTNmWCElcr6nH2kjMkMl9nDlc6O+k9o
         qPxq7gwtvq9EPnpM/daCTK8vTbt5/PKskzzvMWK+9ur+Qp007t3SkR92phiLwilct0
         I+Qn4w08FV217DRLfDNNT7O7Ng9Q5hsxtb1kZV7Q=
Date:   Fri, 02 Oct 2020 15:07:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjayaram@akamai.com, shuah@kernel.org,
        mgorman@techsingularity.net, jhubbard@nvidia.com
Subject:  + selftests-vm-8x-compaction_test-speedup.patch added to
 -mm tree
Message-ID: <20201002220719.8cX5r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: 8x compaction_test speedup
has been added to the -mm tree.  Its filename is
     selftests-vm-8x-compaction_test-speedup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-8x-compaction_test-speedup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-8x-compaction_test-speedup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: 8x compaction_test speedup

This patch reduces the running time for compaction_test from about 27 sec,
to 3.3 sec, which is about an 8x speedup.

These numbers are for an Intel x86_64 system with 32 GB of DRAM.

The compaction_test.c program was spending most of its time doing mmap(),
1 MB at a time, on about 25 GB of memory.

Instead, do the mmaps 100 MB at a time.  (Going past 100 MB doesn't make
things go much faster, because other parts of the program are using the
remaining time.)

Link: https://lkml.kernel.org/r/20201002080621.551044-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/compaction_test.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/compaction_test.c~selftests-vm-8x-compaction_test-speedup
+++ a/tools/testing/selftests/vm/compaction_test.c
@@ -18,7 +18,8 @@
 
 #include "../kselftest.h"
 
-#define MAP_SIZE 1048576
+#define MAP_SIZE_MB	100
+#define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
 
 struct map_list {
 	void *map;
@@ -165,7 +166,7 @@ int main(int argc, char **argv)
 	void *map = NULL;
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
-	unsigned long mem_fragmentable = 0;
+	long mem_fragmentable_MB = 0;
 
 	if (prereq() != 0) {
 		printf("Either the sysctl compact_unevictable_allowed is not\n"
@@ -190,9 +191,9 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
-	mem_fragmentable = mem_free * 0.8 / 1024;
+	mem_fragmentable_MB = mem_free * 0.8 / 1024;
 
-	while (mem_fragmentable > 0) {
+	while (mem_fragmentable_MB > 0) {
 		map = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE | MAP_LOCKED, -1, 0);
 		if (map == MAP_FAILED)
@@ -213,7 +214,7 @@ int main(int argc, char **argv)
 		for (i = 0; i < MAP_SIZE; i += page_size)
 			*(unsigned long *)(map + i) = (unsigned long)map + i;
 
-		mem_fragmentable--;
+		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
 	for (entry = list; entry != NULL; entry = entry->next) {
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages==-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
selftests-vm-8x-compaction_test-speedup.patch


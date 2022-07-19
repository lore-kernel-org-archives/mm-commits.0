Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92649C43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 23:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiGSXB4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 19:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiGSXBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 19:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076DC48EBB
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 16:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976EF609FB
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 23:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA27EC341C6;
        Tue, 19 Jul 2022 23:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658271704;
        bh=FE3w+RG0/b+8VOchHVmeO3hmgUZj/vDMjrUlfdhUbLs=;
        h=Date:To:From:Subject:From;
        b=ONkztNTg3XW/0VdzC/YQeDhznLwYB+vwIeoWgioE1JuxR8zwM8QI/NSN0kezvIgft
         aQkCZfHNxfKVATGZHNcQk0c2RXK6YH3yCtIOvGu/bIhggmGMP+oIONM/qUfBmscT4Q
         uFql+HN+ljLX8fsR8CMga4bnK9lsdBFQ8UYXlPWQ=
Date:   Tue, 19 Jul 2022 16:01:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        mike.kravetz@oracle.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-silence-uninitialized-variable-warning.patch added to mm-unstable branch
Message-Id: <20220719230143.DA27EC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-silence-uninitialized-variable-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-silence-uninitialized-variable-warning.patch

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
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning
Date: Tue, 19 Jul 2022 12:42:48 +0300

This code just reads from memory without caring about the data itself. 
However static checkers complain that "tmp" is never properly initialized.
Initialize it to zero and change the name to "dummy" to show that we
don't care about the value stored in it.

Link: https://lkml.kernel.org/r/YtZ8mKJmktA2GaHB@kili
Fixes: c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugetlb-madvise.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-silence-uninitialized-variable-warning
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -89,10 +89,11 @@ void write_fault_pages(void *addr, unsig
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long i, tmp;
+	unsigned long dummy = 0;
+	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++)
-		tmp += *((unsigned long *)(addr + (i * huge_page_size)));
+		dummy += *((unsigned long *)(addr + (i * huge_page_size)));
 }
 
 int main(int argc, char **argv)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

selftests-vm-silence-uninitialized-variable-warning.patch


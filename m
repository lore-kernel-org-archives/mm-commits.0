Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B124C19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiG3BJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6CC863DB
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54860B82925
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DBBC433C1;
        Sat, 30 Jul 2022 01:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143312;
        bh=6nQboMrNVbBVpTSsCjDOFcKAT3YlLPO4iTQ+npWBQWE=;
        h=Date:To:From:Subject:From;
        b=HWKtJ8N2KPD8y8EjneiSe7gq32i2B6W77f03nwPgsjnJSf59dNkJO34L7qirglzst
         ba5kxqNCauJmCxuHrYNpIH6NWjZij7e6M8btfhe7+XhDlBCM1rgUdskoYJ19Asjkbt
         G2PyiRKcGA78ATgm4B1C8wpXk8SILUonVC5RQIsY=
Date:   Fri, 29 Jul 2022 18:08:31 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        mike.kravetz@oracle.com, jrdr.linux@gmail.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-silence-uninitialized-variable-warning.patch removed from -mm tree
Message-Id: <20220730010832.10DBBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     selftests-vm-silence-uninitialized-variable-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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



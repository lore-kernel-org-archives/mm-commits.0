Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CE3C4346A
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37841235F8
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489229;
	bh=uD6xAztbVsrxrxGE5nhe7BWP5qXoKvPMqGnZIlslD3o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=litLWc3b4Ln6OCnqRegvEvVqXSsyndLqmSy66Tm4kSKngKYQSXRZk+l7R+xmfiw/L
	 VoLws3IWSBK2fq7dIGdfmdd5E2NOybv9Le2n0v9pVFrhgpWgdQEPb5ODlIWbCQurOm
	 z8c9ieENeOnaTI0XnFjLWacSH9cVD61gMBPKDc1Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgISEU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEU2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F48122208;
        Sat, 19 Sep 2020 04:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489228;
        bh=uD6xAztbVsrxrxGE5nhe7BWP5qXoKvPMqGnZIlslD3o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fTF4twVG61mzrdWwiLBMPDRNeGh4VU0UXQ7oQzZHdTnYYixVY2H3p4+byNy3+9XbV
         92LAv96Ku38amK4nQiXjghYd/jqnvG0PMHx0w4bLS116tmX8oXh5mVMB3UR1ZwM+cv
         E/lM0HqwoUp2RB217XcVaRgox/YWM4/OLPebJK38=
Date:   Fri, 18 Sep 2020 21:20:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 10/15] selftests/vm: fix display of page size in
 map_hugetlb
Message-ID: <20200919042028.rpQMuOsNE%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: selftests/vm: fix display of page size in map_hugetlb

The displayed size is in bytes while the text says it is in kB.

Shift it by 10 to really display kBytes.

Link: https://lkml.kernel.org/r/e27481224564a93d14106e750de31189deaa8bc8.1598861977.git.christophe.leroy@csgroup.eu
Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/map_hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c~selftests-vm-fix-display-of-page-size-in-map_hugetlb
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << shift);
+		printf("%u kB hugepages\n", 1 << (shift - 10));
 	else
 		printf("Default size hugepages\n");
 	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
_

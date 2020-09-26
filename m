Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C02C4727E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A05521741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085495;
	bh=wq8UT6e9rfiaDQgE1y92zvPCqlwiuxQRE5b+L4MHdBU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eB82ov5N+rtMlYvmADddiK5rc4xmdm69EtpilCz62fCVE4FqzaTj6kDdhLW9MhxMR
	 uZKK7NxaUqHzdrfD2nhhoJDbPFnWhcI7FACTWCLSADzpaVilJu6WV5TvlWGSGtJD+L
	 d10EFfgPsgxfatKtIgXqUVPvzo4V6nxtXBMLt3Wg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgIZB6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E56F20936;
        Sat, 26 Sep 2020 01:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085494;
        bh=wq8UT6e9rfiaDQgE1y92zvPCqlwiuxQRE5b+L4MHdBU=;
        h=Date:From:To:Subject:From;
        b=CaN2iIixNu7hduVZRGAd0kW1Uxgk2d7keiHlhjmAylyip7cFMmYPDewdAKeMEsw46
         X+jLeJvM6q0zBZxa6VZOQTQFKf2z78DWSTjnH8BlWanMAzW3VzycrHrYo6Wo5QSJdR
         MflVPzBOUfYevE+74aUg/v7crgrmkGIDadcCnVpE=
Date:   Fri, 25 Sep 2020 18:58:14 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch removed from -mm
 tree
Message-ID: <20200926015814.whh8e1u2H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix display of page size in map_hugetlb
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are



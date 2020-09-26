Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B67C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510DE21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085508;
	bh=7QpnDWlS3vRktDqfT2OXfBYBb4K3OU9wjXDHtjwK4Ug=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=odchINZHQdaU6oC7IYu8qbJRh5Pa31o6GejRLNlLuevcySFDYutlKqBpuaFwTgPkU
	 JUgsfA9OvlBS7IUfg36naSySlSmMwG7CyWtpDj6FhmcoDT/Nn3NycbkIfJndP8xd/B
	 4juoU7ABcJ5h97ci7lepAQQl8Y4uuzf4O4wl6C5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIZB62 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgIZB61 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75AA321741;
        Sat, 26 Sep 2020 01:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085507;
        bh=7QpnDWlS3vRktDqfT2OXfBYBb4K3OU9wjXDHtjwK4Ug=;
        h=Date:From:To:Subject:From;
        b=FYpiDgAieHGRy8clNgRiTCuozCg6NZuyw2Fc4W8wPIFhty8yYRQSXWfZ3a/8FL3Sf
         OtLumAr2Ef2L7uWuW849RBuqUJm0JG4xd2koX8OY9THV4XzzYEQYt3j6ajOswsgqtK
         10SojWepmp/Isa/Do1rC9rCVoL1rF9WbxIBogT00=
Date:   Fri, 25 Sep 2020 18:58:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tiantao6@hisilicon.com
Subject:  [merged]
 documentation-remove-cmas-dependency-on-architecture.patch removed from -mm
 tree
Message-ID: <20200926015827.mZ-OihbSB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: remove CMA's dependency on architecture
has been removed from the -mm tree.  Its filename was
     documentation-remove-cmas-dependency-on-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: Documentation: remove CMA's dependency on architecture

CMA only depends on MMU.  It doesn't depend on arch too much.  such as
ARM, ARM64, X86, MIPS etc.  so We remove the dependency of cma about the
architecture in kernel-parameters.txt.

Link: https://lkml.kernel.org/r/1600412758-60545-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-remove-cmas-dependency-on-architecture
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -591,7 +591,7 @@
 			some critical bits.
 
 	cma=nn[MG]@[start[MG][-end[MG]]]
-			[ARM,X86,KNL]
+			[KNL,CMA]
 			Sets the size of kernel global memory area for
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-remove-duplicate-include-statement-in-mmuc.patch


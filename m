Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF190C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91472068F
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511450;
	bh=P08Ixel9JIipv/8n34cTW6e6UgUPBub7/UNjmnOF2AA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G3MEGsiDChA523mH3J65sfvojSDyhFpvnReQreTC2RsW2i1PKX3p/nkvXmvBswKXK
	 wZWpGOJ1jNCpNrnOSsddzd+UATmZ7zbZoRHRLqBxAldTsxcVsLC+pU7pPradkGOCC8
	 kLVbAodxuhWjvSrXL+16YrSgG7NFzaFfT6bNnIgI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgHDDYK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgHDDYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:24:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF922068F;
        Tue,  4 Aug 2020 03:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511449;
        bh=P08Ixel9JIipv/8n34cTW6e6UgUPBub7/UNjmnOF2AA=;
        h=Date:From:To:Subject:From;
        b=AAEJkdzwQpL4jmtQJiiE8Im/eVy3FJNwaWi6le7BQzb9CXAtntd6mH+j3d+MlriJU
         mBL7eaNyQLtdrWcyttfialmhQhMHwEPOpq8yTljlru2zPtupGy7FqfqqgFSv+SJiLy
         wwxVufpt145kO57pOrpsVpOz6uI14LrUtjyUy/+w=
Date:   Mon, 03 Aug 2020 20:24:09 -0700
From:   akpm@linux-foundation.org
To:     haowenchao22@gmail.com, mm-commits@vger.kernel.org
Subject:  +
 mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch added to
 -mm tree
Message-ID: <20200804032409.n4q6kkHm1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: check parameters first in kernel_get_mempolicy
has been added to the -mm tree.  Its filename is
     mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wenchao Hao <haowenchao22@gmail.com>
Subject: mm/mempolicy.c: check parameters first in kernel_get_mempolicy

Previous implementatoin calls untagged_addr() before error check, while if
the error check failed and return EINVAL, the untagged_addr() call is just
useless work.

Link: http://lkml.kernel.org/r/20200801090825.5597-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy
+++ a/mm/mempolicy.c
@@ -1632,11 +1632,11 @@ static int kernel_get_mempolicy(int __us
 	int uninitialized_var(pval);
 	nodemask_t nodes;
 
-	addr = untagged_addr(addr);
-
 	if (nmask != NULL && maxnode < nr_node_ids)
 		return -EINVAL;
 
+	addr = untagged_addr(addr);
+
 	err = do_get_mempolicy(&pval, &nodes, addr, flags);
 
 	if (err)
_

Patches currently in -mm which might be from haowenchao22@gmail.com are

mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch


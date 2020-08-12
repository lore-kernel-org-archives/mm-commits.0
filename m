Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58110C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394472076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196013;
	bh=/QplIjiFGGEsQAyH7mRlWRoV+AtFOejf2BpLdOI1feU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cyotm2pVHAGunO+w5zJUQ4YjWnCulpws37ysuHx9Oh52SaksrbJmR05ax7DhZDpeJ
	 TTqsErkhFf/KRUlYTIuxtnBVFih7eHVEZZKT0s3tdaEbyX2lnZzGRMgWONVp/pok89
	 eYUAlFSYrG9TArddDQafMpzsXGwFrkZKVakJN5Fg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHLBdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHLBdc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3144C206B2;
        Wed, 12 Aug 2020 01:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196012;
        bh=/QplIjiFGGEsQAyH7mRlWRoV+AtFOejf2BpLdOI1feU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dzDuUF/QI6JskX4NlMmw/uz9t0XdZDeC65X46K6c8ChPae4llNcvVxqNK5voSJVY0
         N1t/B/QInam0iE9166LvbHpROu6yTYFHjmvxWpVfoFw12paIWxFnL5YXjAMc3rHDXU
         zMOuFMDNWYWNL/WAk1xiFMj42uG3kOppO2OHpCnw=
Date:   Tue, 11 Aug 2020 18:33:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 062/165] mm/zsmalloc.c: fix duplicated words
Message-ID: <20200812013331.gbbjZ0ZPB%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/zsmalloc.c: fix duplicated words

Change "as as" to "as a".

Link: http://lkml.kernel.org/r/20200801173822.14973-16-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-fix-duplicated-words
+++ a/mm/zsmalloc.c
@@ -79,7 +79,7 @@
 
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
- * as single (unsigned long) handle value.
+ * a single (unsigned long) handle value.
  *
  * Note that object index <obj_idx> starts from 0.
  *
_

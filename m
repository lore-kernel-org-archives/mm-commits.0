Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1364C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF871207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195987;
	bh=+y/ZZBVOGFwiasnzNqy9WkvHPGZ8TWHaNWw/LpoEdwk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ekYP2KKbSBShe5LFXjB60AFQHJpMthlfRtZu0ilBeMNlTfIM3rpgYAtPw/mOrQ3al
	 YTEMEfxmLnfQSMAMguNtDa/iguXo1lafcwdttkTQ2tqZtZo632qR80QHBxPoVS6v+Q
	 MuKKpuKnQldxgxudlqSs4Mqj6sUbSrDMFrlws4XE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BBBD207DA;
        Wed, 12 Aug 2020 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195985;
        bh=+y/ZZBVOGFwiasnzNqy9WkvHPGZ8TWHaNWw/LpoEdwk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qcEr+jIqSYq1U1FYtksJOYYSqB5txwKovDl9BJQrPdoxzWxOQRBmJ6iabVfBTIar6
         86KAPqg3C2fAXeG2pOX/yZpUyfTQH1bTxwBXBLYQy7WXlMuG8wamsCjG/KBiiT9w8D
         /o3919kZhiPwe8vAPJUBoFJR6ZFMebuBiwzXm2rM=
Date:   Tue, 11 Aug 2020 18:33:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 053/165] mm/memory.c: delete duplicated words
Message-ID: <20200812013305.XLkPqjlPK%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory.c: delete duplicated words

Drop the repeated word "to" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-7-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memoryc-delete-duplicated-words
+++ a/mm/memory.c
@@ -1800,7 +1800,7 @@ out_unlock:
  * @pfn: source kernel pfn
  * @pgprot: pgprot flags for the inserted page
  *
- * This is exactly like vmf_insert_pfn(), except that it allows drivers to
+ * This is exactly like vmf_insert_pfn(), except that it allows drivers
  * to override pgprot on a per-page basis.
  *
  * This only makes sense for IO mappings, and it makes no sense for
@@ -1936,7 +1936,7 @@ static vm_fault_t __vm_insert_mixed(stru
  * @pfn: source kernel pfn
  * @pgprot: pgprot flags for the inserted page
  *
- * This is exactly like vmf_insert_mixed(), except that it allows drivers to
+ * This is exactly like vmf_insert_mixed(), except that it allows drivers
  * to override pgprot on a per-page basis.
  *
  * Typically this function should be used by drivers to set caching- and
_

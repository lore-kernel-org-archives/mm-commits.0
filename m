Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F344C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB82D2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195880;
	bh=UESKIzc3KFWepQNcFcHFYGtznQXcOQOt7R/DSc2F+5g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YgtJC0/bJiOD8bTcCsJ6BDSViV7OBgFSdosIb39XhWHrD1CCjLrjnE4oqWGczXXlc
	 UT7jOZxI2Q+eFMbCNB1fMuan/o+zLClDzAzpiZOrEeFZcqfEOkEUBeTD5EkBUouXc0
	 Olex4OQBjnLD3k4fwVqfiu/w7pzb3Xdfkqis0bcw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHLBbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AD9206B2;
        Wed, 12 Aug 2020 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195880;
        bh=UESKIzc3KFWepQNcFcHFYGtznQXcOQOt7R/DSc2F+5g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XVkpR0mjGZgsoN4fBfJ6rWm6LqaKdw4vzYTRGf63c+3ZzfSIA3sO/Q8iZwX+poY+U
         ygf0RHs/RshvECtK4NlQV7/5NMB+OQBUzy09VQZxd47Q182kOYEIBtlKMDuBa793io
         9NtDtRvKbiffrW4r7vgQWsJ3RQ6Tta2eK9+YRTRc=
Date:   Tue, 11 Aug 2020 18:31:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  [patch 020/165] include/linux/mempolicy.h: fix typo
Message-ID: <20200812013119.7m9I9l4_4%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: include/linux/mempolicy.h: fix typo

Change "interlave" to "interleave".

Link: http://lkml.kernel.org/r/20200810063454.9357-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mempolicy.h~mempolicyh-fix-typo
+++ a/include/linux/mempolicy.h
@@ -28,7 +28,7 @@ struct mm_struct;
  * the process policy is used. Interrupts ignore the memory policy
  * of the current process.
  *
- * Locking policy for interlave:
+ * Locking policy for interleave:
  * In process context there is no locking because only the process accesses
  * its own state. All vma manipulation is somewhat protected by a down_read on
  * mmap_lock.
_

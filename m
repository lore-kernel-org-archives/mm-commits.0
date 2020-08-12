Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CFFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F32207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196123;
	bh=Jn9suZqjam5EX1HEk7P3MP+4IjtlUJM4KvGDao7SxsU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nz+aWkP2pHrlc4APhAIiIQwvVLgirRZ1xB5ujc2ph1CMM+ecDxvvQUgH42HJLCRvX
	 L93RZIBb49RDiBpqG8Upt+R7vyX9NOzHuIKOyBnXStcDoXbzbf5rILv4P4RTKV+u7H
	 hny3BrYIq19i64BineSmctnln0+lvn2T8g5wys4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBfW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FFA2206B2;
        Wed, 12 Aug 2020 01:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196122;
        bh=Jn9suZqjam5EX1HEk7P3MP+4IjtlUJM4KvGDao7SxsU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E8YdwFtxStniInJakGSbKMYQ+Izgsb1Z5buLMES7SWjY88O1UcL0HtnquMFz0jc3l
         8kGTU9gE/kIKVtxVUAQHibUOJsynTmdh/u6Ll1A4o1Jt8cEny0BROjP5ZCpO32rkjb
         pDiPkcBh3r6fSeDKv+wDtUKlZ/MJ3scpWEf5dR1w=
Date:   Tue, 11 Aug 2020 18:35:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, raven@themaw.net,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 097/165] autofs: fix doubled word
Message-ID: <20200812013521.iVtvW2EP2%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: autofs: fix doubled word

Change doubled word "is" to "it is".

Link: http://lkml.kernel.org/r/5a82befd-40f8-8dc0-3498-cbc0436cad9b@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-fix-doubled-word
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -82,7 +82,7 @@ struct args_ismountpoint {
 /*
  * All the ioctls use this structure.
  * When sending a path size must account for the total length
- * of the chunk of memory otherwise is is the size of the
+ * of the chunk of memory otherwise it is the size of the
  * structure.
  */
 
_

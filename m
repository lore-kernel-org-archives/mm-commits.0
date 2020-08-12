Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F1EC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525B32080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196049;
	bh=XxYbZ55CofPhj+4154ViwMyzPUAGKC6bC15H1R16Jm8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kRmjwXZQmydjgS24r6yL6O91/WxTdtzda4gy76EfFZXbcXE1hFyABnRg/vsZXk4Fz
	 XONd5JL/4GOXlHqqflOs3hBGI8kWVZ1B3Dd+D0CxMRq1N2JjHi6sbOThhVF/AYO2Ji
	 v61SsEaWn5g1G+WDzq95/R/Vju0GTyuwy8gICMbQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBeJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954D220829;
        Wed, 12 Aug 2020 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196047;
        bh=XxYbZ55CofPhj+4154ViwMyzPUAGKC6bC15H1R16Jm8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZYxuvEz3GhtW66KHOS5H6rzkLJBiJsyrV1gocjMIXDC7XoFSvRf3igoyrlZt07TBr
         xSQ+bTVqSkADIkXFLt7UbzWKN2zMtoGtxZBhObjhCB1vJV1AwD1aUaj1XuPmxlHpos
         pCghuT+hewp7BsWClRC7XWVuBkoHaJ2Ly16sD/Ms=
Date:   Tue, 11 Aug 2020 18:34:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, lasse.collin@tukaani.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 073/165] include/linux/xz.h: drop duplicated word
Message-ID: <20200812013407.5O1twL7qX%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/xz.h: drop duplicated word

Drop the doubled word "than" in a comment.

Link: http://lkml.kernel.org/r/05ebba7a-c1e4-01ae-fc7b-15c081b33f3e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xz.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/xz.h~xz-drop-duplicated-word-in-linux-xzh
+++ a/include/linux/xz.h
@@ -28,7 +28,7 @@
  * enum xz_mode - Operation mode
  *
  * @XZ_SINGLE:              Single-call mode. This uses less RAM than
- *                          than multi-call modes, because the LZMA2
+ *                          multi-call modes, because the LZMA2
  *                          dictionary doesn't need to be allocated as
  *                          part of the decoder state. All required data
  *                          structures are allocated at initialization,
_

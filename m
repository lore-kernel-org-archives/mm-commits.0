Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EA8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8E9207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195974;
	bh=NOiAHz45YhlsKq7wUBmOrs7xSM0irlPe4Tb/xkyAbOo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=pYXx5L9k9MIQk6Mp9uzwHiwlZmfOax6uoiP/12RRM7vQfv5wnr3xVoToYyK2tFzQ8
	 ZPfVK/yT6TI7F4d6RcNMbY6LkrtwaZp7mdVozoBes+9AfR+coFpzFpgFxSyXckAIqr
	 namuNTZHL32JF4UN50mI5+nXjv7KcPBLdtnmAnzQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBcy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6124206B2;
        Wed, 12 Aug 2020 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195974;
        bh=NOiAHz45YhlsKq7wUBmOrs7xSM0irlPe4Tb/xkyAbOo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H0/yulE7PUX2Z1ej+aXeX7aaQlDJdW9aV5sklnRnFno0zN6Rjm30c8SEx3DaH6vJ0
         Bwb/u0CGi3hCq++XaE5lOFNvQTueD5s7RR5766k4EaXmP++4wthNI3D52jRN4B3Sv4
         dVA4WYhG4Y736lqI0dsjUdXxjUJSDoSF3/tmJLVg=
Date:   Tue, 11 Aug 2020 18:32:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 049/165] mm/filemap.c: delete duplicated word
Message-ID: <20200812013253.HcNw_AYfZ%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/filemap.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-3-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemapc-delete-duplicated-word
+++ a/mm/filemap.c
@@ -2885,7 +2885,7 @@ filler:
 	 * Case a, the page will be up to date when the page is unlocked.
 	 *    There is no need to serialise on the page lock here as the page
 	 *    is pinned so the lock gives no additional protection. Even if the
-	 *    the page is truncated, the data is still valid if PageUptodate as
+	 *    page is truncated, the data is still valid if PageUptodate as
 	 *    it's a race vs truncate race.
 	 * Case b, the page will not be up to date
 	 * Case c, the page may be truncated but in itself, the data may still
_

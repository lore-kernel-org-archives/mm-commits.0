Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F121C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80638206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196082;
	bh=EIq/hHHU+Lm2hhC15UdcMlC3WsiZLOXuNvlcqBh36O4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0dWyE8OqCGRne36oYiaPPONwKSdXS14hOsUqsN5qljdx8L8gczZ/w8GzaGstUqW0D
	 2/roHf6Q9Md+EdTgrn+tQlju9yGdh9Jk/hhZNuqM1VJI2K9tRwWf83h105+V8itcsp
	 0auWyQ7Pet+epxbBro1YZfNYdsa8o1KPs67uLg5o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLBem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBem (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888612076C;
        Wed, 12 Aug 2020 01:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196081;
        bh=EIq/hHHU+Lm2hhC15UdcMlC3WsiZLOXuNvlcqBh36O4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BeOHaIsfmgjX4S6GypE7+Pm99j3YVvUbkpnxU23pYoUoRg0pj1EuSaBm5BEyUnngm
         3xKV/XP/ekW0T1nHDnsZ4M8/tUCoVhTg10sQr3yOVcbuSjicT3lFmdThrnF2Rw3QJf
         Ir3VwZ5ha+F3IxaA8SjUaSwSZ9fH9X1+MyacH7A0=
Date:   Tue, 11 Aug 2020 18:34:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hulkci@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        weiyongjun1@huawei.com
Subject:  [patch 084/165] lib/test_lockup.c: make symbol
 'test_works' static
Message-ID: <20200812013441.8lKDzA3XI%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: lib/test_lockup.c: make symbol 'test_works' static

Fix sparse build warning:

lib/test_lockup.c:403:1: warning:
 symbol '__pcpu_scope_test_works' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200707112252.9047-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_lockup.c~lib-test_lockupc-make-symbol-test_works-static
+++ a/lib/test_lockup.c
@@ -400,7 +400,7 @@ static void test_lockup(bool master)
 	test_unlock(master, true);
 }
 
-DEFINE_PER_CPU(struct work_struct, test_works);
+static DEFINE_PER_CPU(struct work_struct, test_works);
 
 static void test_work_fn(struct work_struct *work)
 {
_

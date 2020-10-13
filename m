Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B22C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF160221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632918;
	bh=Wd8hEYFXBwyWRcONoR4h0VWb/Hhbcs/YHpUuYCkD2uw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GWfLiQab2gjV51lB6IBgXwWBx2PgEMIqQ2vhmnRWFYewIrRDan+Fw4TwoF0I2Jcgg
	 JN4DIKVG9P/+D5BTg1KVAqEvq/0oq7k4gNfe4jnVmEdONATqDHyhUuaWBdRXPPiGUg
	 Wf6K/yvJLz/44Cj8ZRV1K2Tc0JMrpA1WdKdiBtzk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgJMXsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbgJMXsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3EB821D7A;
        Tue, 13 Oct 2020 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632918;
        bh=Wd8hEYFXBwyWRcONoR4h0VWb/Hhbcs/YHpUuYCkD2uw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kGXBBmZAuwwe6VB7jDXU9xQr2WPK5QLxGgXz8TqkF946kAxYZ7StngDLz6eJqCP/9
         MuYm/7ax949TCvmQL50ObfsUisRHjy0sVCEPEBxI1oTRStK48GriRM/LfukevxqxM/
         mMH4Wki8rqh210gysoQ2h39Skm2hQIU5I9OttGgU=
Date:   Tue, 13 Oct 2020 16:48:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jrdr.linux@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        tangjianqiang@xiaomi.com, torvalds@linux-foundation.org,
        wyqt1985@gmail.com
Subject:  [patch 020/181] include/linux/slab.h: fix a typo error in
 comment
Message-ID: <20201013234837.vmgd3jJ8D%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: tangjianqiang <wyqt1985@gmail.com>
Subject: include/linux/slab.h: fix a typo error in comment

fix a typo error in slab.h
"allocagtor" -> "allocator"

Link: https://lkml.kernel.org/r/1600230053-24303-1-git-send-email-tangjianqiang@xiaomi.com
Signed-off-by: tangjianqiang <tangjianqiang@xiaomi.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~include-linux-slabh-fix-a-typo-error-in-comment
+++ a/include/linux/slab.h
@@ -279,7 +279,7 @@ static inline void __check_heap_object(c
 #define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_MAX)
 /* Maximum size for which we actually use a slab cache */
 #define KMALLOC_MAX_CACHE_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
-/* Maximum order allocatable via the slab allocagtor */
+/* Maximum order allocatable via the slab allocator */
 #define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_MAX - PAGE_SHIFT)
 
 /*
_

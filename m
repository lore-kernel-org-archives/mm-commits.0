Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E45C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7196620E65
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976461;
	bh=GFKyW9Z0KnVTy7xMzO734UShpCWOyDBiv+3IMmcJJug=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=V+L0NOV19F8taszc1DHu1QsDM5b9ldi6e9T47uXvoQxNuBP1bUD2S+purjtTRgKyv
	 8NOybo2QUPCT5tYtKX35ajCNC+IHMtOSlFOGuGoNZVbaEnCqWwjZ/mjdGR4vjp0eIh
	 EsPnNSnutk1HUJd+ifHF8+Dt+uPd2qU5NsYu2aBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439893AbgJQXOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C49621527;
        Sat, 17 Oct 2020 23:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976459;
        bh=GFKyW9Z0KnVTy7xMzO734UShpCWOyDBiv+3IMmcJJug=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A1F2quduP7mKEKwcB4XnHZG1yB6RXN6FSJYAem9l+DGKudmxhbXSfCUZ879XIok1p
         apRdfaV6hZBlos1YW/FHwcRkQ8IVLav6QHZdd+66LdpgeDnV/Sx9xNfxa5Jc0wWpyd
         XPe6bRBw55/pkZC0uax/QBpwQHYP1PUPH+7WQOe8=
Date:   Sat, 17 Oct 2020 16:14:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, jannh@google.com,
        jgg@nvidia.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        sakari.ailus@linux.intel.com, torvalds@linux-foundation.org,
        walken@google.com
Subject:  [patch 14/40] mm/gup: assert that the mmap lock is held
 in __get_user_pages()
Message-ID: <20201017231418.twQriq6_i%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jann Horn <jannh@google.com>
Subject: mm/gup: assert that the mmap lock is held in __get_user_pages()

After having cleaned up all GUP callers (except for the atomisp staging
driver, which currently gets mmap locking completely wrong [1]) to always
ensure that they hold the mmap lock when calling into GUP (unless the mm
is not yet globally visible), add an assertion to make sure it stays that
way going forward.

[1] https://lore.kernel.org/lkml/CAG48ez3tZAb9JVhw4T5e-i=h2_DUZxfNRTDsagSRCVazNXx5qA@mail.gmail.com/

Link: https://lkml.kernel.org/r/CAG48ez1GM==OnHpS=ghqZNJPn02FCDUEHc7GQmGRMXUD_aKudg@mail.gmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages
+++ a/mm/gup.c
@@ -1027,6 +1027,8 @@ static long __get_user_pages(struct mm_s
 	struct vm_area_struct *vma = NULL;
 	struct follow_page_context ctx = { NULL };
 
+	mmap_assert_locked(mm);
+
 	if (!nr_pages)
 		return 0;
 
_

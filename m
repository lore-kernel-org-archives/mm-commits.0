Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40EAC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8151522DBF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgLPRAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgLPRAY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:00:24 -0500
Date:   Wed, 16 Dec 2020 08:59:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608137984;
        bh=TEIXXqwKZvQjR+lB+wUj2nD5le0/U1K2Yz/MwpJmuEQ=;
        h=From:To:Subject:From;
        b=iHblUwE/0D4xKmef6Et5ECVgz6ZdyFQbl1VEaOFSUsXHwR8GaWYKiMQiFSv2ugFL0
         S9zJppfy2BsO0nc0UkTmvauZ7hmTyjJvO03gc2qXKPD15haSHqw15+CtgR1l7jxyQO
         8yag6YVInovBH578ejZ66m5ZMRUWT8JcMlCZkf/4=
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  [to-be-updated]
 mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch removed
 from -mm tree
Message-ID: <20201216165943.J-x3ZO_K6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: assert that the mmap lock is held in __get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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
@@ -996,6 +996,8 @@ static long __get_user_pages(struct mm_s
 	struct vm_area_struct *vma = NULL;
 	struct follow_page_context ctx = { NULL };
 
+	mmap_assert_locked(mm);
+
 	if (!nr_pages)
 		return 0;
 
_

Patches currently in -mm which might be from jannh@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00B0C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F70222201
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUqbOuGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgKMAWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgKMAWC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:22:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5A321D79;
        Fri, 13 Nov 2020 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605226922;
        bh=bytp1Qg7QmhrJArji6StBMO5ozeiGwo3zjAKy+XhmYM=;
        h=Date:From:To:Subject:From;
        b=jUqbOuGkV1pQHuv7cLK/dgsYRejHmeklfXOjJJEg3jg0b/1wvb4hFl1GOOqUnQCwm
         ldqNVXzi3vgh2kPo5/QyFdjEtZ1CHM1E2lP/f9FV/EKttwTBERL72aJnIkCKJeGqYv
         iv3vv75JLiKtSw0nss/UBymANeCX6wJ0FHGAle4w=
Date:   Thu, 12 Nov 2020 16:22:01 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, cai@redhat.com, lstoakes@gmail.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + kasan-simplify-kasan_poison_kfree-temp-fix.patch added
 to -mm tree
Message-ID: <20201113002201.kP8lMg2oO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-simplify-kasan_poison_kfree-temp-fix
has been added to the -mm tree.  Its filename is
     kasan-simplify-kasan_poison_kfree-temp-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-simplify-kasan_poison_kfree-temp-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-simplify-kasan_poison_kfree-temp-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: kasan-simplify-kasan_poison_kfree-temp-fix

temp workaround for a ceph-related oops

Link: https://lkml.kernel.org/r/CAA5enKY8mBicpc7kZKKLG5LeVFhVJtRQ73MYVFM0Az2bbiGv8g@mail.gmail.com
Reported-by: syzbot+2d6f3dad1a42d86a5801@syzkaller.appspotmail.com
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Qian Cai <cai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kasan/common.c~kasan-simplify-kasan_poison_kfree-temp-fix
+++ a/mm/kasan/common.c
@@ -439,6 +439,11 @@ void __kasan_poison_kfree(void *ptr, uns
 	struct page *page;
 
 	page = virt_to_head_page(ptr);
+
+	if (!PageSlab(page)) {
+		return;
+	}
+
 	____kasan_slab_free(page->slab_cache, ptr, ip, false);
 }
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

kasan-simplify-kasan_poison_kfree-temp-fix.patch


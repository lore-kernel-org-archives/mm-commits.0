Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2D1C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 17:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiFZRlp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbiFZRlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 13:41:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527831A3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 10:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3EDECE0FFF
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 17:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC422C34114;
        Sun, 26 Jun 2022 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656265301;
        bh=L80aZ83NbAqdRpvj9UVTcK7nDU1wJdfmCmXt1LI3A5E=;
        h=Date:To:From:Subject:From;
        b=HvxOEVa49EwU61/wQTKeOB9iXN7ApVqFraJVdz4IYmP1dsXEYUTYH1wT/JVkXLn/8
         Us7YDJ+NGSDLarpCobBl1zd4KG/dVCiwbJUmFjQmgm33l1rcCnb5nmtIBid6vAF1fJ
         jMB6lpeItqMRkfUEu+iqsPxlOHiyzj5YlgRcaBDo=
Date:   Sun, 26 Jun 2022 10:41:40 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        skhan@linuxfoundation.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        gautammenghani201@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch added to mm-hotfixes-unstable branch
Message-Id: <20220626174140.EC422C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: fix null pointer dereference warning in qlink_to_cache()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/kasan: fix null pointer dereference warning in qlink_to_cache()
Date: Sun, 26 Jun 2022 22:33:55 +0530

virt_to_slab() declared in slab.h can return NULL if the address does not
belong to a slab.  This case is not handled in qlink_to_cache() in
quarantine.c, which can cause a NULL pointer dereference in
"virt_to_slab(qlink)->slab_cache".  This issue was discovered by fanalyzer
(my gcc version: 12.1.1 20220507)

Link: https://lkml.kernel.org/r/20220626170355.198913-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/kasan/quarantine.c~mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache
+++ a/mm/kasan/quarantine.c
@@ -128,7 +128,13 @@ static unsigned long quarantine_batch_si
 
 static struct kmem_cache *qlink_to_cache(struct qlist_node *qlink)
 {
-	return virt_to_slab(qlink)->slab_cache;
+	struct slab *folio_slab = virt_to_slab(qlink);
+
+	if (!folio_slab) {
+		pr_warn("The address %p does not belong to a slab", qlink);
+		return NULL;
+	}
+	return folio_slab->slab_cache;
 }
 
 static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are

mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch


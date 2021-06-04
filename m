Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD232C47096
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B092C6140A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFDCpW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhFDCpU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 22:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFAC6140A;
        Fri,  4 Jun 2021 02:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622774603;
        bh=0nna7H0UTke1oJls79+/Ss3oHetoV37G+5AJdUpBww8=;
        h=Date:From:To:Subject:From;
        b=GPKLyCKnBFySPMV4GYb8vwIVrTYuBj+DU29pCSRk4iMNNbOImucH5T6UIm/2vBgPP
         gyTYExjidfDcN+MPDUlpqPruftn2JWRXUH5kXpNcX6VHcNRTtyrZh8rjEkOVqJ1r9m
         wduBiFbMsVCilJY0gz9lcRhSm1L5HMtli1yr1o7k=
Date:   Thu, 03 Jun 2021 19:43:22 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        yaoaili@kingsoft.com
Subject:  +
 mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch added to -mm
 tree
Message-ID: <20210604024322.gbhqpEkYG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-send-sigbus-with-error-virutal-address-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mmhwpoison-send-sigbus-with-error-virutal-address-fix

walk_page_range() got to return 1 when it found at least error virtual
address since v5, so this if-condition should be like this.

Link: https://lkml.kernel.org/r/20210603051055.GA244241@hori.linux.bs1.fc.nec.co.jp
Cc: Tony Luck <tony.luck@intel.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jue Wang <juew@google.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-send-sigbus-with-error-virutal-address-fix
+++ a/mm/memory-failure.c
@@ -691,7 +691,7 @@ static int kill_accessing_process(struct
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
 			      (void *)&priv);
-	if (!ret && priv.tk.addr)
+	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
 	mmap_read_unlock(p->mm);
 	return ret ? -EFAULT : -EHWPOISON;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

hugetlb-pass-head-page-to-remove_hugetlb_page.patch
mmhwpoison-fix-race-with-hugetlb-page-allocation.patch
mmhwpoison-send-sigbus-with-error-virutal-address.patch
mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch
mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch


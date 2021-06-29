Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4F9C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C5F561CF9
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhF2AiU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2AiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A71061CE7;
        Tue, 29 Jun 2021 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926953;
        bh=+FqOHosWwzHMK27g62LyTycGkY2+nUjwHLDc88bM29A=;
        h=Date:From:To:Subject:From;
        b=w5583v6qAL0sa5R9UzqEfYqPehZ/R6nfn8nIV2gtMosTCiyd6h1Qq/QxJIk6bhZAu
         FN1iovRnIOxGeuSMSpQ5hyxBpESqwL0PIRtG8CdJMTW9qLNljpTqCZA4Mutv4dEVnc
         IN3dam6fVASGjkEIUkVKf8ITU9U5RF8ntJxVxa+s=
Date:   Mon, 28 Jun 2021 17:35:52 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        yaoaili@kingsoft.com
Subject:  [folded-merged]
 mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch removed from
 -mm tree
Message-ID: <20210629003552.n1ricx_8e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-send-sigbus-with-error-virutal-address-fix
has been removed from the -mm tree.  Its filename was
     mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch

This patch was dropped because it was folded into mmhwpoison-send-sigbus-with-error-virutal-address.patch

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

mmhwpoison-send-sigbus-with-error-virutal-address.patch
mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch
mm-hwpoison-disable-pcp-for-page_handle_poison.patch


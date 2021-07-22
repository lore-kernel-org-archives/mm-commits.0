Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418FBC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 21:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B8760EB6
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 21:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGVUst (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Jul 2021 16:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231824AbhGVUst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Jul 2021 16:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FEC860C41;
        Thu, 22 Jul 2021 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626989363;
        bh=lyQOnWmPSNTTdVd1BZODITCrHNo8+cKE7kSEkQYn+uc=;
        h=Date:From:To:Subject:From;
        b=BZUCDJsRMJa5/jygy8AfJ2MX+hjdBQMit1OVCqrzjZhK0rO0zxx0Nd6CqAl+1x7cg
         1gnFhbAygJYM9mcQfJMJlnW0iwiYG73XBhhLanLdViYs2FE1ctre818TG6OtIbyXVz
         H3IkU30UsojUQMCVp2ExjZXNaSf2e7YwQLYy5MtA=
Date:   Thu, 22 Jul 2021 14:29:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, dennis@kernel.org,
        cl@linux.com, gregkh@linuxfoundation.org
Subject:  + percpu-remove-export-of-pcpu_base_addr.patch added to -mm
 tree
Message-ID: <20210722212922.Q-Ijl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: remove export of pcpu_base_addr
has been added to the -mm tree.  Its filename is
     percpu-remove-export-of-pcpu_base_addr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu-remove-export-of-pcpu_base_addr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu-remove-export-of-pcpu_base_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: percpu: remove export of pcpu_base_addr

This is not needed by any modules, so remove the export.

Link: https://lkml.kernel.org/r/20210722185814.504541-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-export-of-pcpu_base_addr
+++ a/mm/percpu.c
@@ -146,7 +146,6 @@ static unsigned int pcpu_high_unit_cpu _
 
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __ro_after_init;
-EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
 static const int *pcpu_unit_map __ro_after_init;		/* cpu -> unit */
 const unsigned long *pcpu_unit_offsets __ro_after_init;	/* cpu -> unit offset */
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

percpu-remove-export-of-pcpu_base_addr.patch


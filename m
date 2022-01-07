Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D94C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jan 2022 23:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiAGXaG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jan 2022 18:30:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiAGXaG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jan 2022 18:30:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 237CEB80E3E
        for <mm-commits@vger.kernel.org>; Fri,  7 Jan 2022 23:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7954C36AE5;
        Fri,  7 Jan 2022 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641598203;
        bh=R+jkF0TbRnQg08Ep0Iutg/fIIsOn20+osGMAiPcrIag=;
        h=Date:From:To:Subject:From;
        b=A9tKooPp1AToOMizO0hWzS4uKg8gJ/JuwOxCTMYpUIvpfqk7YrFnfXkjBO+2c5yG6
         ZgCQ0pQTdK28GO1pQ1cFkaG2EO7mwqJlYl5oIx0JtGJbcRgFMj0hK5EKpFmvvb9jJr
         wq/S72vdXgR3O/pNzXn9fjAyUvxUAa6fdLt/QTqM=
Date:   Fri, 07 Jan 2022 15:30:03 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tony.luck@intel.com, youquan.song@intel.com
Subject:  +
 mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch added
 to -mm tree
Message-ID: <20220107233003.Pwz5De4n_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix error page recovered but reported "not recovered"
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Youquan Song <youquan.song@intel.com>
Subject: mm/hwpoison: fix error page recovered but reported "not recovered"

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

If the CMCI wins that race, the page is marked poisoned when
uc_decode_notifier() calls memory_failure() and the machine check
processing code finds the page already poisoned.  It calls
kill_accessing_process() to make sure a SIGBUS is sent.  But returns the
wrong error code.

Console log looks like this:

[34775.674296] mce: Uncorrected hardware memory error in user-access at 3710b3400
[34775.675413] Memory failure: 0x3710b3: recovery action for dirty LRU page: Recovered
[34775.690310] Memory failure: 0x3710b3: already hardware poisoned
[34775.696247] Memory failure: 0x3710b3: Sending SIGBUS to einj_mem_uc:361438 due to hardware memory corruption
[34775.706072] mce: Memory error not recovered

Fix kill_accessing_process() to return -EHWPOISON to avoid the noise
message "Memory error not recovered" and skip duplicate SIGBUS.

[Tony: Reworded some parts of commit message]

Link: https://lkml.kernel.org/r/20220107194450.1687264-1-tony.luck@intel.com
Fixes: a3f5d80ea401 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered
+++ a/mm/memory-failure.c
@@ -708,7 +708,8 @@ static int kill_accessing_process(struct
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
 	mmap_read_unlock(p->mm);
-	return ret ? -EFAULT : -EHWPOISON;
+
+	return (ret < 0) ? -EFAULT : -EHWPOISON;
 }
 
 static const char *action_name[] = {
_

Patches currently in -mm which might be from youquan.song@intel.com are

mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch


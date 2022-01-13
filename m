Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD6CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 20:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiAMUwj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:52:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49300 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiAMUwi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 15:52:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA9C61426
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 20:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1978BC36AE3;
        Thu, 13 Jan 2022 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642107157;
        bh=+oEslID8jAglO9208sNto+/olv7wXzTUtA8QgWXf7zQ=;
        h=Date:From:To:Subject:From;
        b=WbH68Ma5/DmVo8Rh87bgi08Zro5iAYa1683nsrCPb0KqJiXcf7iEOOJqwJ1aUCY6S
         VZgEQ54TA3KQSSejLh9+XHNJPWG6VpdgQQaKQKIK2649Q5tKjJ2/jIY1alfyra1pvU
         OUxJ8f8NhfLijdQYK2tTlDXWaeSpgJO0Oqn/RfJc=
Date:   Thu, 13 Jan 2022 12:52:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tony.luck@intel.com, youquan.song@intel.com
Subject:  [alternative-merged]
 mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch
 removed from -mm tree
Message-ID: <20220113205236.jiEQDiJf1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix error page recovered but reported "not recovered"
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch

This patch was dropped because an alternative patch was merged

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



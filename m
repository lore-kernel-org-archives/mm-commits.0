Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D5CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiA0C1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:27:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47386 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiA0C1P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:27:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 836B460C3E
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4131C340E7;
        Thu, 27 Jan 2022 02:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643250435;
        bh=zeeD4yYjyak20fL0FccC1XVpCx6BT4zFn+kUbvfH0Uc=;
        h=Date:From:To:Subject:From;
        b=OJI1PvFRTRegHRGl3/Sd1HgEqMyNeb9Aw/k86ICMXGxpIPJgJTSjwUIGBnoAZfVSX
         PTHYazsTijVlEy0YjDSRbpIp7n/34QXUf/Qlv5+vY42JNoIn2cpiZZHq203bTBz1cv
         auqoVoRLjqIdLaAX2ZwfMRHrrvwDW1gwP6APvDzY=
Date:   Wed, 26 Jan 2022 18:27:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tony.luck@intel.com, youquan.song@intel.com
Subject:  +
 mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch added
 to -mm tree
Message-ID: <20220127022714.M2sOzPDh9%akpm@linux-foundation.org>
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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

kill_accessing_process() is supposed to return -EHWPOISON to notify that
SIGBUS is already set to the process and kill_me_maybe() doesn't have to
send it again.  But current code simply fails to do this, so fix it to
make sure to work as intended.  This change avoids the noise message
"Memory error not recovered" and skips duplicate SIGBUSs.

[tony.luck@intel.com: reword some parts of commit message]
Link: https://lkml.kernel.org/r/20220113231117.1021405-1-naoya.horiguchi@linux.dev
Fixes: a3f5d80ea401 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Youquan Song <youquan.song@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered
+++ a/mm/memory-failure.c
@@ -707,8 +707,10 @@ static int kill_accessing_process(struct
 			      (void *)&priv);
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
+	else
+		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret ? -EFAULT : -EHWPOISON;
+	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
 static const char *action_name[] = {
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-remove-obsolete-comment.patch
mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch


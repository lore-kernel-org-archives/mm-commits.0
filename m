Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ADCC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiCVVpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiCVVpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5352A5F4FE
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E9D6153D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FB7C340F2;
        Tue, 22 Mar 2022 21:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985447;
        bh=HdU0vZFsm6ZQTbOCxFhzrAcCi2PY1UHl6gH2MZTIBHk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=GVy8cKzz1rcCph6Y67vbN1CY1T68/z3LpdLuysVOiSjlT4sI/ykjVRwJ4VWanu7aS
         3alESKRNoXyB5FKef1UzcvHxmQtR3Hv2nvHpANMXrMjg2S30VclJqmftvItK6AvVVF
         PhMhNG5OStYCLxcNlGy4hPFlTT3nNw0+TpbczaFQ=
Date:   Tue, 22 Mar 2022 14:44:06 -0700
To:     youquan.song@intel.com, tony.luck@intel.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 110/227] mm/hwpoison: fix error page recovered but reported "not recovered"
Message-Id: <20220322214407.42FB7C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

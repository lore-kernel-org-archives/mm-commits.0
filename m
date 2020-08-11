Return-Path: <SRS0=Ir1+=BV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A779FC433E3
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 04:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC2C20772
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 04:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597119487;
	bh=SuneYn0rGRKgWDdtE2qUWKvNidGVzjnwwQ/ssmtjAts=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2jLcKShwkxrI/270/YDmExgWmOTPh/Ry+Xb44ltO2Vwv9JJf277xpNlrfkBpr0mq7
	 5ntVFszp1EbOzjHQ0Q8T6YxEAE1NYOZrdZE0DgWPftTjUfTU95Um8macms1ljKpNq1
	 Kcab3yIDP5prqmT+8cW1q8GU1ATzZEp2U4SMlCEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgHKESG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 00:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgHKESG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 00:18:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC08206DA;
        Tue, 11 Aug 2020 04:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597119486;
        bh=SuneYn0rGRKgWDdtE2qUWKvNidGVzjnwwQ/ssmtjAts=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ul2PwCX+brGalftsBEw6bmoStLu3rqgUrV227gb4y3VQWvDwmieV/cGhnY2tZfzBz
         RZAqqv7q2vcifMO08ZfNmidVmcbj0+bayQBydII8fa0GCNit0Taj3fN3pgEaT1pDml
         GtIkWy3eeRyt/4HXXHqM6bZYuCucifMowPj/NQG4=
Date:   Mon, 10 Aug 2020 21:18:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  + mempolicyh-fix-typo.patch added to -mm tree
Message-ID: <20200811041805.vjhMjbc8z%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mempolicy.h: fix typo
has been added to the -mm tree.  Its filename is
     mempolicyh-fix-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicyh-fix-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicyh-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: include/linux/mempolicy.h: fix typo

Change "interlave" to "interleave".

Link: http://lkml.kernel.org/r/20200810063454.9357-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mempolicy.h~mempolicyh-fix-typo
+++ a/include/linux/mempolicy.h
@@ -28,7 +28,7 @@ struct mm_struct;
  * the process policy is used. Interrupts ignore the memory policy
  * of the current process.
  *
- * Locking policy for interlave:
+ * Locking policy for interleave:
  * In process context there is no locking because only the process accesses
  * its own state. All vma manipulation is somewhat protected by a down_read on
  * mmap_lock.
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mempolicyh-fix-typo.patch


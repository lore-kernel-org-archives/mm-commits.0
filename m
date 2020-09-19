Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F47C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C0921D7B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600488295;
	bh=reVU3pFpz5AYha2NbHKT7YJB+f0RqQVp9s2iBIWLF7I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=r2q5NODE0pJCkxVIalpVgAvFOlZBtaoUl3Zzyy5aUmARYx5v0nQwZnFzlTzKySMxi
	 YpHApk185fz8kUqEeMRpxPF8NyDBtoyjPEcm5xNTt3XvKkj7I5x/VqNdiNfnrnqa3/
	 kfNCprt+lmfY+4dXN2BTvDDXM/KccDYniQcf4Q+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgISEEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgISEEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:04:54 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD2421897;
        Sat, 19 Sep 2020 04:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600488294;
        bh=reVU3pFpz5AYha2NbHKT7YJB+f0RqQVp9s2iBIWLF7I=;
        h=Date:From:To:Subject:From;
        b=m3IqNRw2Ml2IzCOAB0nbz1+GRa5SZ0c9G8UfH3hhnJq58BsTTLdxhpsEAamT/bDAd
         WJm8ukw14LAxP6bPXg7nDQJV2EZoQK5UwOEJOS9azrbUEaeRw02BpA/1TmeUkRbX71
         RQrF9eXGaJH1rUSMiHWF3Rki1CHUoRog5rDIxJVc=
Date:   Fri, 18 Sep 2020 21:04:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tanxiaofei@huawei.com
Subject:  + mm-fix-some-doc-warnings-in-workingsetc.patch added to
 -mm tree
Message-ID: <20200919040453.AAdgm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset.c: fix some doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-some-doc-warnings-in-workingsetc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-doc-warnings-in-workingsetc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-doc-warnings-in-workingsetc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: mm/workingset.c: fix some doc warnings

Fix following warnings caused by mismatch bewteen function parameters and
comments.

mm/workingset.c:228: warning: Function parameter or member 'lruvec' not described in 'workingset_age_nonresident'
mm/workingset.c:228: warning: Excess function parameter 'memcg' description in 'workingset_age_nonresident'

Link: https://lkml.kernel.org/r/1600485913-11192-1-git-send-email-tanxiaofei@huawei.com
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-fix-some-doc-warnings-in-workingsetc
+++ a/mm/workingset.c
@@ -216,7 +216,7 @@ static void unpack_shadow(void *shadow,
 
 /**
  * workingset_age_nonresident - age non-resident entries as LRU ages
- * @memcg: the lruvec that was aged
+ * @lruvec: the lruvec that was aged
  * @nr_pages: the number of pages to count
  *
  * As in-memory pages are aged, non-resident pages need to be aged as
_

Patches currently in -mm which might be from tanxiaofei@huawei.com are

mm-fix-some-doc-warnings-in-workingsetc.patch


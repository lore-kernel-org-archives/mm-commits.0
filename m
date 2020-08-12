Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79ADC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F3A2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266247;
	bh=rgzeLZS4Ee9bFG42AWe/Bpm/4LcbKKDrgjDn40bPHB8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yaVKtkuznu6ZB6u8ydk9h7TIjI4S94TKuR2ASAedAkrfNsHipwan9ziSa6uXHuSMq
	 sz1ABh2Qk4J+p/zft1TVL0SwyG80HHzLyo3qJiMkD3YcPOgYnTjQNktlK5oOfA5JzX
	 tR/pSCgCR6x5QXYPbEQM7Wk/sBsRoc8UmJiSpzgk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLVEH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgHLVEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B1820774;
        Wed, 12 Aug 2020 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266246;
        bh=rgzeLZS4Ee9bFG42AWe/Bpm/4LcbKKDrgjDn40bPHB8=;
        h=Date:From:To:Subject:From;
        b=1QHj2i8n4hbAR0u0kUtRf4/JQJAVlI8Dt272riv2xzdCb41uKoDqPbcaenL5LAqZb
         u9bdWAN3fBmu009SLhpoW9Z9fZ0RgQbVE4+IqmPrW2IjB4q+NkhzA7MgTQgS02sabh
         Ml1H+xDGE7S/vmv363zdzhoAdFr4OW+qcK5BXGMw=
Date:   Wed, 12 Aug 2020 14:04:06 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org,
        weiyongjun1@huawei.com
Subject:  [merged]
 lib-test_lockupc-make-symbol-test_works-static.patch removed from -mm tree
Message-ID: <20200812210406.V1zCOiR2k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_lockup.c: make symbol 'test_works' static
has been removed from the -mm tree.  Its filename was
     lib-test_lockupc-make-symbol-test_works-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: lib/test_lockup.c: make symbol 'test_works' static

Fix sparse build warning:

lib/test_lockup.c:403:1: warning:
 symbol '__pcpu_scope_test_works' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200707112252.9047-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_lockup.c~lib-test_lockupc-make-symbol-test_works-static
+++ a/lib/test_lockup.c
@@ -400,7 +400,7 @@ static void test_lockup(bool master)
 	test_unlock(master, true);
 }
 
-DEFINE_PER_CPU(struct work_struct, test_works);
+static DEFINE_PER_CPU(struct work_struct, test_works);
 
 static void test_work_fn(struct work_struct *work)
 {
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are



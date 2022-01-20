Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E78CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiATVZC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377832AbiATVZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E69DC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:25:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A746B81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5A6C340E5;
        Thu, 20 Jan 2022 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713897;
        bh=0ljh8h81xfUrB4PoUU7udwz8VXOCrUsToiOpwrVZssM=;
        h=Date:From:To:Subject:From;
        b=Ou2R8SwAPKvDOu0v3WNWDhxh+USsmMD3mjXZOcC4haSqDgpHAkSo8zZdff9DB6bVG
         zVkzdWZV6Ht1XoEEQ5lyArluSxjZEwOsPDgv9+qCf3SJwElYCQ8wDyIr87ropz2U17
         z5jhO3z1BIJRpZP8RiEjn9jPKEIbvs0/JxtZn+Ms=
Date:   Thu, 20 Jan 2022 13:24:57 -0800
From:   akpm@linux-foundation.org
To:     dqiao@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch
 removed from -mm tree
Message-ID: <20220120212457.J23zbS26R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: remove an incorrect call to propagate_protected_usage()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Donghai Qiao <dqiao@redhat.com>
Subject: mm/page_counter: remove an incorrect call to propagate_protected_usage()

propagate_protected_usage() is called to propagate the usage change in the
page_counter structure.  But there is a call to this function from
page_counter_try_charge() when there is actually no usage change.  Hence
this call should be removed.

Link: https://lkml.kernel.org/r/20211118181125.3918222-1-dqiao@redhat.com
Signed-off-by: Donghai Qiao <dqiao@redhat.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-remove-an-incorrect-call-to-propagate_protected_usage
+++ a/mm/page_counter.c
@@ -120,7 +120,6 @@ bool page_counter_try_charge(struct page
 		new = atomic_long_add_return(nr_pages, &c->usage);
 		if (new > c->max) {
 			atomic_long_sub(nr_pages, &c->usage);
-			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
_

Patches currently in -mm which might be from dqiao@redhat.com are



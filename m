Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6C5C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72B0208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633296;
	bh=33XRFMMp04LQxSAQ0GP9dTswytI4KVRqKj+5EvSkGjk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QAdA+7ni8nK292AJ8LApH6uhcMtm0DAhA+0mgstNx7YPPYbpmgj6aO3kRF2svwiMk
	 gUV+i/L2MU9hzREn9+E+Sq9TA7YTnAgg1tOQOigmPzEibFY/+QxqJQJm4Raerbx2pk
	 TVUQ/ORviJ53IzexhKOn7ldzdKjbY6Ec3UsylyQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388195AbgJMXy4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CC1321D7B;
        Tue, 13 Oct 2020 23:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633295;
        bh=33XRFMMp04LQxSAQ0GP9dTswytI4KVRqKj+5EvSkGjk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QhtdHvcEFm27peG4VBHKa3AhbjTTT3kJHA1YjWbWICfoXgv80OBfMnE+OHWYw/ah0
         f2E1ZWiYpZ5UXgJ8vJHMNtjfKr53d09AxsHwYIuCVRvtnRhdXmefCYrYBMNZG6V623
         CANr4T9uvuaUWO5C0M9+9Xzzu2c45+Q/zusgxpKA=
Date:   Tue, 13 Oct 2020 16:54:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     agordeev@linux.ibm.com, akpm@linux-foundation.org, corbet@lwn.net,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 119/181] docs/vm: fix 'mm_count' vs 'mm_users'
 counter confusion
Message-ID: <20201013235454.wF9oonFdH%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: docs/vm: fix 'mm_count' vs 'mm_users' counter confusion

In the context of the anonymous address space lifespan description the
'mm_users' reference counter is confused with 'mm_count'.  I.e a "zombie"
mm gets released when "mm_count" becomes zero, not "mm_users".

Link: https://lkml.kernel.org/r/1597040695-32633-1-git-send-email-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/active_mm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/vm/active_mm.rst~docs-vm-fix-mm_count-vs-mm_users-counter-confusion
+++ a/Documentation/vm/active_mm.rst
@@ -64,7 +64,7 @@ Active MM
  actually get cases where you have a address space that is _only_ used by
  lazy users. That is often a short-lived state, because once that thread
  gets scheduled away in favour of a real thread, the "zombie" mm gets
- released because "mm_users" becomes zero.
+ released because "mm_count" becomes zero.
 
  Also, a new rule is that _nobody_ ever has "init_mm" as a real MM any
  more. "init_mm" should be considered just a "lazy context when no other
_

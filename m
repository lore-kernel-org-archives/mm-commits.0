Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B333C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350754AbiCYBgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357445AbiCYBfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8490529C80
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 292E1B8272A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5458C340EC;
        Fri, 25 Mar 2022 01:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172002;
        bh=1V5wsSopC68j3YV43QNYKbZhzmt50T/eGhqysd3KMjk=;
        h=Date:To:From:Subject:From;
        b=jM0VZtSbCIZuwl7U2z8MC4XGI7MzunobTpfmdCLPP1snyiGX2e6goIuydFb8gyvH/
         6fta1d/ucyC6V0T8atRAjargeOu4nW1Kw6AotJ0D1bm7Qy0lguCJOXWzM4uvS7D6sy
         ee930pyAGScfJt20HBun9ppyiVudvxn2U/MHw4Bg=
Date:   Thu, 24 Mar 2022 18:33:22 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch removed from -mm tree
Message-Id: <20220325013322.D5458C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling
has been removed from the -mm tree.  Its filename was
     docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling

In DAMON's early development stage before it be merged in the mainline, it
was first designed to work exclusively with Idle page tracking to avoid
any interference between each other.  Later, but still before be merged in
the mainline, because Idle page tracking is fully under the control of
sysadmins, we made the resolving of conflict as the responsibility of
sysadmins.  The document is not updated for the change, though.  This
commit updates the document for that.

Link: https://lkml.kernel.org/r/20220222170100.17068-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/design.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/vm/damon/design.rst~docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling
+++ a/Documentation/vm/damon/design.rst
@@ -84,9 +84,10 @@ table having a mapping to the address.
 and clear the bit(s) for next sampling target address and checks whether the
 bit(s) set again after one sampling period.  This could disturb other kernel
 subsystems using the Accessed bits, namely Idle page tracking and the reclaim
-logic.  To avoid such disturbances, DAMON makes it mutually exclusive with Idle
-page tracking and uses ``PG_idle`` and ``PG_young`` page flags to solve the
-conflict with the reclaim logic, as Idle page tracking does.
+logic.  DAMON does nothing to avoid disturbing Idle page tracking, so handling
+the interference is the responsibility of sysadmins.  However, it solves the
+conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
+as Idle page tracking does.
 
 
 Address Space Independent Core Mechanisms
_

Patches currently in -mm which might be from sj@kernel.org are



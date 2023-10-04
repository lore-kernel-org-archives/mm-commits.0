Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D28FE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbjJDUSe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244026AbjJDUS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D3793
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C038CC433C7;
        Wed,  4 Oct 2023 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450704;
        bh=iKF5lj4hQCilWpU/I7wYM8RS9ImyJ/PNZEv7ugp5O7U=;
        h=Date:To:From:Subject:From;
        b=mxECnBijDIAeIl8d/vrMjc9+1iUet1bwQKWFmwGKcvDYTe3KnpQTA3bZoswtPKJib
         vM1Vys7dBWS3NR8fdD4QmVJAnZ/Y48Jp6UAXVPWWtgXgICDDhP2rKtaZE58xC9h6Ic
         tDGjh5X4y5Bgja5k3da1OqvrYAiEYYgzD3129Fbw=
Date:   Wed, 04 Oct 2023 13:18:22 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch removed from -mm tree
Message-Id: <20231004201823.C038CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add a section for kdamond and DAMON context
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add a section for kdamond and DAMON context
Date: Thu, 7 Sep 2023 02:29:24 +0000

The design document is not explaining about the concept of kdamond and
the DAMON context, while usage document does.  Those concept explanation
should be in the design document, and usage document should link those.
Add a section for those.

Link: https://lkml.kernel.org/r/20230907022929.91361-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context
+++ a/Documentation/mm/damon/design.rst
@@ -476,3 +476,13 @@ modules for proactive reclamation and LR
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
+
+
+Execution Model and Data Structures
+===================================
+
+The monitoring-related information including the monitoring request
+specification and DAMON-based operation schemes are stored in a data structure
+called DAMON ``context``.  DAMON executes each context with a kernel thread
+called ``kdamond``.  Multiple kdamonds could run in parallel, for different
+types of monitoring.
_

Patches currently in -mm which might be from sj@kernel.org are



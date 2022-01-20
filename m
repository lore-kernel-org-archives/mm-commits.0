Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0143DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377894AbiATV2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbiATV2l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526DE6188A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C080C340E0;
        Thu, 20 Jan 2022 21:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714120;
        bh=CCYBepjNQCArJbABDD2RiJjiDE0i2Y2SDGrtOpwa4gI=;
        h=Date:From:To:Subject:From;
        b=rSmLIIoOz19V19ohAmW0HHOw9yCPph5FIF43q6x2z+N92vEfGcTF+OsTW1rURGkUl
         wkOgbJuIqr/lhec9bQVFsKgovsjfGI/Ett8Pkv/VwBTzqJ5aKtM5kSJo7pzYSmdgby
         XRWwbOEQhI3yEwsu7SIxRe86dRJ1pg9UMn3gcTiY=
Date:   Thu, 20 Jan 2022 13:28:40 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
 removed from -mm tree
Message-ID: <20220120212840.ThcrN7pMH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: mention tracepoint at the beginning
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: mention tracepoint at the beginning

To get detailed monitoring results from the user space, users need to use
the damon_aggregated tracepoint.  This commit adds a brief mention of it
at the beginning of the usage document.

Link: https://lkml.kernel.org/r/20211209131806.19317-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -21,7 +21,10 @@ DAMON provides below three interfaces fo
   you can write and use your personalized DAMON debugfs wrapper programs that
   reads/writes the debugfs files instead of you.  The `DAMON user space tool
   <https://github.com/awslabs/damo>`_ is one example of such programs.  It
-  supports both virtual and physical address spaces monitoring.
+  supports both virtual and physical address spaces monitoring.  Note that this
+  interface provides only simple :ref:`statistics <damos_stats>` for the
+  monitoring results.  For detailed monitoring results, DAMON provides a
+  :ref:`tracepoint <tracepoint>`.
 - *Kernel Space Programming Interface.*
   :doc:`This </vm/damon/api>` is for kernel space programmers.  Using this,
   users can utilize every feature of DAMON most flexibly and efficiently by
@@ -215,6 +218,8 @@ If the value is higher than ``<high mark
 scheme is deactivated.  If the value is lower than ``<mid mark>``, the scheme
 is activated.
 
+.. _damos_stats:
+
 Statistics
 ~~~~~~~~~~
 
@@ -268,6 +273,8 @@ the monitoring is turned on.  If you wri
 an error code such as ``-EBUSY`` will be returned.
 
 
+.. _tracepoint:
+
 Tracepoint for Monitoring Results
 =================================
 
_

Patches currently in -mm which might be from sj@kernel.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5368FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiANWKM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiANWKL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B193B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B25C36AE9;
        Fri, 14 Jan 2022 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198209;
        bh=19E+CtDAg/34H9fR7SjNVgJCCYloRDmlLaUNNNmjuM8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1nxwDgsKlTMgT0rqZAUytGHY9Mmru5rUNYw8tLou2DHaG62TfkQ/ofxLsE8cOPYoY
         gG5jvaJCtWhGEIlKw55oJx7fXzYMpdLg9sLPCLdvolxm+CmpNaVnqVj3xd1POOItKP
         Hzcw0t/5it/C0o+Ee9KbsUUWMjrI910yJkLq4vlo=
Date:   Fri, 14 Jan 2022 14:10:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 132/146] Docs/admin-guide/mm/damon/usage: mention
 tracepoint at the beginning
Message-ID: <20220114221008.1h5lucSiN%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

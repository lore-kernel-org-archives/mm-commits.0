Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAA9C8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjFIXdU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjFIXcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C863A9B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1163C65CFE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65179C433EF;
        Fri,  9 Jun 2023 23:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353384;
        bh=wlii+whAWAf+S2N4ab7u5E2Iny5zcJXo1MCz2UCH6fE=;
        h=Date:To:From:Subject:From;
        b=UWNaszZ2mujRnFsdDbGJyVeKwXRWJkFp/m/bFZfRPMPzJQBEpMC+JMmc/tsQtm4Jv
         ngyGosNgQC9ybqzsUKokE2HCVBpmBDPq1fRm3+u+ly/EQlQFuFjdGCV42ugtb+CG3t
         SsF3yP05VDnvSmTD7iZlfuDXz42TDsBpKXYYnHYg=
Date:   Fri, 09 Jun 2023 16:29:43 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-rewrite-configurable-layers.patch removed from -mm tree
Message-Id: <20230609232944.65179C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: rewrite configurable layers
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-rewrite-configurable-layers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: rewrite configurable layers
Date: Thu, 25 May 2023 21:43:09 +0000

The 'Configurable Operations Set' section is a little bit outdated. 
Update the text.

Link: https://lkml.kernel.org/r/20230525214314.5204-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-rewrite-configurable-layers
+++ a/Documentation/mm/damon/design.rst
@@ -22,24 +22,23 @@ DAMON subsystem is configured with three
 Configurable Operations Set
 ---------------------------
 
-DAMON provides data access monitoring functionality while making the accuracy
-and the overhead controllable.  The fundamental access monitorings require
-primitives that dependent on and optimized for the target address space.  On
-the other hand, the accuracy and overhead tradeoff mechanism, which is the core
-of DAMON, is in the pure logic space.  DAMON separates the two parts in
-different layers and defines its interface to allow various low level
-primitives implementations configurable with the core logic.  We call the low
-level primitives implementations monitoring operations.
+For data access monitoring and additional low level work, DAMON needs a set of
+implementations for specific operations that are dependent on and optimized for
+the given target address space.  On the other hand, the accuracy and overhead
+tradeoff mechanism, which is the core logic of DAMON, is in the pure logic
+space.  DAMON separates the two parts in different layers, namely DAMON
+Operations Set and DAMON Core Logics Layers, respectively.  It further defines
+the interface between the layers to allow various operations sets to be
+configured with the core logic.
 
-Due to this separated design and the configurable interface, users can extend
-DAMON for any address space by configuring the core logics with appropriate
-monitoring operations.  If appropriate one is not provided, users can implement
-the operations on their own.
+Due to this design, users can extend DAMON for any address space by configuring
+the core logic to use the appropriate operations set.  If any appropriate set
+is unavailable, users can implement one on their own.
 
 For example, physical memory, virtual memory, swap space, those for specific
 processes, NUMA nodes, files, and backing memory devices would be supportable.
-Also, if some architectures or devices support special optimized access check
-primitives, those will be easily configurable.
+Also, if some architectures or devices supporting special optimized access
+check primitives, those will be easily configurable.
 
 
 Operations Set Layer
_

Patches currently in -mm which might be from sj@kernel.org are



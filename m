Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46127C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiCVVuu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbiCVVum (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBCB574A9
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F54615BD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68633C340EE;
        Tue, 22 Mar 2022 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985753;
        bh=cXpd7DykzEkja9QGRrIaORbf8fpG6oaM+sXBMDgTcsk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=iXLPovVvl4gDmEKbtHq1+ls5jPw4S8x5FGJ2g1LI37mMbUyWg/ZuF5sa6TqHKUw2Z
         lKQKs59qtGtSUmGfLpO99FT60I9Nt4ZS7b3rbTud8cUbg/6GB1sIRgNgd/FtELXa5Y
         t1FuSE8tUFR0MJC5IOIwFA+aBMlBE4138j+ZXdy4=
Date:   Tue, 22 Mar 2022 14:49:12 -0700
To:     corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 211/227] Docs/vm/damon: call low level monitoring primitives the operations
Message-Id: <20220322214913.68633C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/vm/damon: call low level monitoring primitives the operations

Patch series "Docs/damon: Update documents for better consistency".

Some of DAMON document are not properly updated for latest version.  This
patchset updates such parts.


This patch (of 3):

DAMON code calls the low level monitoring primitives implementations the
monitoring operations.  The documentation would have no problem at still
calling those primitives implementation because there is no real
difference in the concepts, but making it more consistent with the code
would make it better.  This commit therefore convert sentences in the doc
specifically pointing the implementations of the primitives to call it
monitoring operations.

Link: https://lkml.kernel.org/r/20220222170100.17068-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220222170100.17068-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/design.rst |   24 ++++++++++++------------
 Documentation/vm/damon/faq.rst    |    2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/Documentation/vm/damon/design.rst~docs-vm-damon-call-low-level-monitoring-primitives-the-operations
+++ a/Documentation/vm/damon/design.rst
@@ -13,12 +13,13 @@ primitives that dependent on and optimiz
 the other hand, the accuracy and overhead tradeoff mechanism, which is the core
 of DAMON, is in the pure logic space.  DAMON separates the two parts in
 different layers and defines its interface to allow various low level
-primitives implementations configurable with the core logic.
+primitives implementations configurable with the core logic.  We call the low
+level primitives implementations monitoring operations.
 
 Due to this separated design and the configurable interface, users can extend
-DAMON for any address space by configuring the core logics with appropriate low
-level primitive implementations.  If appropriate one is not provided, users can
-implement the primitives on their own.
+DAMON for any address space by configuring the core logics with appropriate
+monitoring operations.  If appropriate one is not provided, users can implement
+the operations on their own.
 
 For example, physical memory, virtual memory, swap space, those for specific
 processes, NUMA nodes, files, and backing memory devices would be supportable.
@@ -26,25 +27,24 @@ Also, if some architectures or devices s
 primitives, those will be easily configurable.
 
 
-Reference Implementations of Address Space Specific Primitives
-==============================================================
+Reference Implementations of Address Space Specific Monitoring Operations
+=========================================================================
 
-The low level primitives for the fundamental access monitoring are defined in
-two parts:
+The monitoring operations are defined in two parts:
 
 1. Identification of the monitoring target address range for the address space.
 2. Access check of specific address range in the target space.
 
-DAMON currently provides the implementations of the primitives for the physical
+DAMON currently provides the implementations of the operations for the physical
 and virtual address spaces. Below two subsections describe how those work.
 
 
 VMA-based Target Address Range Construction
 -------------------------------------------
 
-This is only for the virtual address space primitives implementation.  That for
-the physical address space simply asks users to manually set the monitoring
-target address ranges.
+This is only for the virtual address space monitoring operations
+implementation.  That for the physical address space simply asks users to
+manually set the monitoring target address ranges.
 
 Only small parts in the super-huge virtual address space of the processes are
 mapped to the physical memory and accessed.  Thus, tracking the unmapped
--- a/Documentation/vm/damon/faq.rst~docs-vm-damon-call-low-level-monitoring-primitives-the-operations
+++ a/Documentation/vm/damon/faq.rst
@@ -31,7 +31,7 @@ Does DAMON support virtual memory only?
 =======================================
 
 No.  The core of the DAMON is address space independent.  The address space
-specific low level primitive parts including monitoring target regions
+specific monitoring operations including monitoring target regions
 constructions and actual access checks can be implemented and configured on the
 DAMON core by the users.  In this way, DAMON users can monitor any address
 space with any access check technique.
_

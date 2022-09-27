Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48ADC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiI0CvB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiI0Cs6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D10AB4E0
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24D2CB81903
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF962C433D7;
        Tue, 27 Sep 2022 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246910;
        bh=FKv0x5jt/6ywrCsMVkjHNrFVOJbpFQQevHPLXa8sfKY=;
        h=Date:To:From:Subject:From;
        b=s1ltAmk2Z22a6RrIOWsIZ+w0ByU53K+ZQ4BrZpzHCNNXdip7C0M1j10jnUQDUWkOw
         Je7d19kd3g/eJPnMyQ8lCz/z/b3AGoij0bpnZNyKgf3X1vLPmC5DS7+AiEfEvPkOVr
         mVkzXj/KG2P5ZY9fhH41TGTG5aAAVqypPBZp7IFo=
Date:   Mon, 26 Sep 2022 19:48:30 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-add-pr_err-define.patch removed from -mm tree
Message-Id: <20220927024830.BF962C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: add pr_err define
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-pr_err-define.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: radix tree test suite: add pr_err define
Date: Tue, 6 Sep 2022 19:48:39 +0000

define pr_err to printk

Link: https://lkml.kernel.org/r/20220906194824.2110408-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/kernel.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-add-pr_err-define
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -14,6 +14,7 @@
 #include "../../../include/linux/kconfig.h"
 
 #define printk printf
+#define pr_err printk
 #define pr_info printk
 #define pr_debug printk
 #define pr_cont printk
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are



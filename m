Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F90DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345273AbiCYBgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244460AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E07BC1C82
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5B560A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FD2C340EE;
        Fri, 25 Mar 2022 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171980;
        bh=oFUALpVVmFVTcJrt+bqWJjE3it5Gc6WGmBhmt7D01Hg=;
        h=Date:To:From:Subject:From;
        b=Gyzk0hratY9Q2LxkgF/JPKeZxsw/WnirKZRDFNa2meZYW11FgnCz99ye5kSMnU75t
         6anCIc3veG/9+9wQ2YQt746hX89ffpHhhjLr7+UulEImXetLT0kfTRxRZTsfk8DBel
         QVu56ou/tbaLg5i1hn0YvOsEtKYLKtrNOR+1WUH0=
Date:   Thu, 24 Mar 2022 18:32:59 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, tangmeng@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-kfence-remove-unnecessary-config_kfence-option.patch removed from -mm tree
Message-Id: <20220325013300.00FD2C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: remove unnecessary CONFIG_KFENCE option
has been removed from the -mm tree.  Its filename was
     mm-kfence-remove-unnecessary-config_kfence-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: tangmeng <tangmeng@uniontech.com>
Subject: mm/kfence: remove unnecessary CONFIG_KFENCE option

In mm/Makefile has:
obj-$(CONFIG_KFENCE) += kfence/

So that we don't need 'obj-$(CONFIG_KFENCE) :=' in mm/kfence/Makefile,
delete it from mm/kfence/Makefile.

Link: https://lkml.kernel.org/r/20220221065525.21344-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/Makefile~mm-kfence-remove-unnecessary-config_kfence-option
+++ a/mm/kfence/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_KFENCE) := core.o report.o
+obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
_

Patches currently in -mm which might be from tangmeng@uniontech.com are

mm-kasan-remove-unnecessary-config_kasan-option.patch


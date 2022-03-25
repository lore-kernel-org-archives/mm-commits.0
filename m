Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0B4C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356333AbiCYBhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357498AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4933340
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C298660A66
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23401C340EC;
        Fri, 25 Mar 2022 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172029;
        bh=L78C0yK51vae2FFX1vDvL0VX94vuvlT+DwhTJYFtr5o=;
        h=Date:To:From:Subject:From;
        b=cG3CtQscULAOsFZk66Uih+ApL6e9LPIkEt/C4PymV4Y/EmQo+2zefmZB7IAqYAGK8
         GliSvJGc4i9dgw4U6oSOsew18VdeX01szKKfFl8GbZ2lHItnd3cFCioOXZysi569Jx
         zJjSW5Hx6OR63H2V9jH5Lw5RTXI0qlrQCdlYVrCU=
Date:   Thu, 24 Mar 2022 18:33:48 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, jsd@semihalf.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bitfield-add-explicit-inclusions-to-the-example.patch removed from -mm tree
Message-Id: <20220325013349.23401C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitfield: add explicit inclusions to the example
has been removed from the -mm tree.  Its filename was
     bitfield-add-explicit-inclusions-to-the-example.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: bitfield: add explicit inclusions to the example

It's not obvious that bitfield.h doesn't guarantee the bits.h inclusion
and the example in the former is confusing.  Some developers think that
it's okay to just include bitfield.h to get it working.  Change example to
explicitly include necessary headers in order to avoid confusion.

Link: https://lkml.kernel.org/r/20220207123341.47533-1-andriy.shevchenko@linux.intel.com
Fixes: 3e9b3112ec74 ("add basic register-field manipulation macros")
Depends-on: 8bd9cb51daac ("locking/atomics, asm-generic: Move some macros from <linux/bitops.h> to a new <linux/bits.h> file")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Jan Dąbroś <jsd@semihalf.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitfield.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/bitfield.h~bitfield-add-explicit-inclusions-to-the-example
+++ a/include/linux/bitfield.h
@@ -19,6 +19,9 @@
  *
  * Example:
  *
+ *  #include <linux/bitfield.h>
+ *  #include <linux/bits.h>
+ *
  *  #define REG_FIELD_A  GENMASK(6, 0)
  *  #define REG_FIELD_B  BIT(7)
  *  #define REG_FIELD_C  GENMASK(15, 8)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



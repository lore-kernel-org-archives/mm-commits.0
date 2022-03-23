Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77949C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345375AbiCWXHX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345379AbiCWXHV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06189025D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BD6FB82181
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A593C340EE;
        Wed, 23 Mar 2022 23:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076748;
        bh=ZCU7Of7v/lbpEDiuwt7YJBx0glvj//0sL5U6XPWuRm8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=q8+CzY5cObzizqx7MSOf4N3KeqJyEUK7GemzmT7ZHELqvCkn7NluGAvzBCNTr6VDN
         iOlL9cFZmLKVXVlrHbOCu7TeIpuhlCWS33eiYgpEeIwEfQPi3aw7t0gA/qL2bn7g+I
         dgv+Xw3shw93ug06OL/4IaqV5uJGS9ChsAT6wZNM=
Date:   Wed, 23 Mar 2022 16:05:47 -0700
To:     peterz@infradead.org, jsd@semihalf.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 10/41] bitfield: add explicit inclusions to the example
Message-Id: <20220323230548.3A593C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

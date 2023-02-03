Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C0AC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCGvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBCGvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC5410A8
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1F2FB82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7788BC433EF;
        Fri,  3 Feb 2023 06:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407059;
        bh=s6CejnBFAP2biUK5i4k6oAh13gR8F1txcxceTrBFTaI=;
        h=Date:To:From:Subject:From;
        b=ywljw87QuTYR/h7f2PUCagcnBLUZpp60B8qAb/gDxMoDtrs9VGvpMElzHHws+/67O
         pAB2b2z/5fJhc3TYhIZ7Fi4Vd8acPUuiVdL5SHaZ9KjJsQGhH6KqoRhxhLYC2LVMAi
         KnhomQwIbVvU2vGknUvTetRIGy05ZpldUxQ0uQFA=
Date:   Thu, 02 Feb 2023 22:50:58 -0800
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] util_macrosh-add-missing-insclusion.patch removed from -mm tree
Message-Id: <20230203065059.7788BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: util_macros.h: add missing inclusion
has been removed from the -mm tree.  Its filename was
     util_macrosh-add-missing-insclusion.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: util_macros.h: add missing inclusion
Date: Tue, 3 Jan 2023 14:19:37 +0200

The header is the direct user of definitions from the math.h, include it.

Link: https://lkml.kernel.org/r/20230103121937.32085-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/util_macros.h~util_macrosh-add-missing-insclusion
+++ a/include/linux/util_macros.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_HELPER_MACROS_H_
 #define _LINUX_HELPER_MACROS_H_
 
+#include <linux/math.h>
+
 #define __find_closest(x, a, as, op)					\
 ({									\
 	typeof(as) __fc_i, __fc_as = (as) - 1;				\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



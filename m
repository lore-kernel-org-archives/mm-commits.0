Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBF6C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiGRAdR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiGRAdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AA8140AE
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0502B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94089C341C0;
        Mon, 18 Jul 2022 00:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104364;
        bh=F/36xC0YSXqJmx9+RpGPrN7jrNCgD81bPDOYd4SmT3w=;
        h=Date:To:From:Subject:From;
        b=cniSUFmSKxD5+GUoo+xV9FAU0qTD2r0dLez6uWYc1Kh74Du3yj0tfJVLYty+8C+qa
         gkYxvqA3c7aC09UEF0EEo1hHvNwGU8w+WA2HQNQ21zNchqsFKFif2MRvg3mspezc5x
         po3i7putDaa2c7/n7/65bV/bgMXUqImP8Obq6oLA=
Date:   Sun, 17 Jul 2022 17:32:44 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-update-cpumask_next_wrap-signature.patch removed from -mm tree
Message-Id: <20220718003244.94089C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cpumask: update cpumask_next_wrap() signature
has been removed from the -mm tree.  Its filename was
     cpumask-update-cpumask_next_wrap-signature.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sander Vanheule <sander@svanheule.net>
Subject: cpumask: update cpumask_next_wrap() signature
Date: Sat, 2 Jul 2022 18:08:28 +0200

The extern specifier is not needed for this declaration, so drop it.  The
function also depends only on the input parameters, and has no side
effects, so it can be marked __pure like other functions in cpumask.h.

Link: https://lkml.kernel.org/r/72ab755695b74bb5fbaa756ae4c0edd708d172f1.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/cpumask.h~cpumask-update-cpumask_next_wrap-signature
+++ a/include/linux/cpumask.h
@@ -229,7 +229,7 @@ int cpumask_any_distribute(const struct
 		(cpu) = cpumask_next_zero((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
 
-extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
+int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
 
 /**
  * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
_

Patches currently in -mm which might be from sander@svanheule.net are



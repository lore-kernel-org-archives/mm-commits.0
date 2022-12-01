Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5232C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLAARz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLAARD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DA90743
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C81A61977
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D9CC433D7;
        Thu,  1 Dec 2022 00:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853642;
        bh=tK4ARKbZBez/TMnACfhQ0UNhlIDVGHcjSQFhITC5r6E=;
        h=Date:To:From:Subject:From;
        b=0AfSXjHXxFXwHv2iPXvGo2upgXtPkraCC7gCojWGE++mTTIJRD3iefna4NOlgkdP+
         ZmoUJFJCpLgwDZeDm52VDXTxc10h5DDvwrNYk676dvw5CwObqJAdGV82i+R4rcP8RR
         qpYEC0HA7K7QjNd5/NBfKY0WZZKj5hWkNX44wFaI=
Date:   Wed, 30 Nov 2022 16:14:01 -0800
To:     mm-commits@vger.kernel.org, zhangjinhao2@huawei.com,
        vbabka@suse.cz, rdunlap@infradead.org, guohanjun@huawei.com,
        zhengyejian1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch removed from -mm tree
Message-Id: <20221201001402.84D9CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: acct: fix accuracy loss for input value of encode_comp_t()
has been removed from the -mm tree.  Its filename was
     acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zheng Yejian <zhengyejian1@huawei.com>
Subject: acct: fix accuracy loss for input value of encode_comp_t()
Date: Sat, 15 May 2021 22:06:30 +0800

Patch series "Fix encode_comp_t()".

Type conversion in encode_comp_t() may look a bit problematic.


This patch (of 2):

See calculation of ac_{u,s}time in fill_ac():
  > ac->ac_utime = encode_comp_t(nsec_to_AHZ(pacct->ac_utime));
  > ac->ac_stime = encode_comp_t(nsec_to_AHZ(pacct->ac_stime));

Return value of nsec_to_AHZ() is always type of 'u64', but it is handled
as type of 'unsigned long' in encode_comp_t, and accuracy loss would
happen on 32-bit platform when 'unsigned long' value is 32-bit-width.

So 'u64' value of encode_comp_t() may look better.

Link: https://lkml.kernel.org/r/20210515140631.369106-1-zhengyejian1@huawei.com
Link: https://lkml.kernel.org/r/20210515140631.369106-2-zhengyejian1@huawei.com
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/acct.c~acct-fix-accuracy-loss-for-input-value-of-encode_comp_t
+++ a/kernel/acct.c
@@ -320,7 +320,7 @@ void acct_exit_ns(struct pid_namespace *
 }
 
 /*
- *  encode an unsigned long into a comp_t
+ *  encode an u64 into a comp_t
  *
  *  This routine has been adopted from the encode_comp_t() function in
  *  the kern_acct.c file of the FreeBSD operating system. The encoding
@@ -331,7 +331,7 @@ void acct_exit_ns(struct pid_namespace *
 #define	EXPSIZE		3			/* Base 8 (3 bit) exponent. */
 #define	MAXFRACT	((1 << MANTSIZE) - 1)	/* Maximum fractional value. */
 
-static comp_t encode_comp_t(unsigned long value)
+static comp_t encode_comp_t(u64 value)
 {
 	int exp, rnd;
 
_

Patches currently in -mm which might be from zhengyejian1@huawei.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFD2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiGRAca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiGRAc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD5A13CE1
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3A1460F8C
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796AC3411E;
        Mon, 18 Jul 2022 00:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104346;
        bh=CQd+zzB6VLQBO/vnJmQnmxJlldxvf0krPDvUqkJF+u0=;
        h=Date:To:From:Subject:From;
        b=ZPSPOH87cfRqG08Blghq7qk0j/06gwYwDzQtRjvbl9KEyFEDgUAbNUHlGwOH46cP5
         bpPPDKeJQ8jL/V5lsz2qJtuABPmuhne6835ENKx/WuYK6Xl1nERx9lyS/Hdpi9cqkA
         R6fP3yAOFVoPYw8ddYP4CEJ2UBvesuNYeZeE0KSc=
Date:   Sun, 17 Jul 2022 17:32:25 -0700
To:     mm-commits@vger.kernel.org, stefani@seibold.net,
        randy.dunlap@oracle.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kfifo-fix-kfifo_to_user-return-type.patch removed from -mm tree
Message-Id: <20220718003226.4796AC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfifo: fix kfifo_to_user() return type
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kfifo_to_user-return-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: kfifo: fix kfifo_to_user() return type
Date: Fri, 24 Jun 2022 08:30:04 +0300

The kfifo_to_user() macro is supposed to return zero for success or
negative error codes.  Unfortunately, there is a signedness bug so it
returns unsigned int.  This only affects callers which try to save the
result in ssize_t and as far as I can see the only place which does that
is line6_hwdep_read().

TL;DR: s/_uint/_int/.

Link: https://lkml.kernel.org/r/YrVL3OJVLlNhIMFs@kili
Fixes: 144ecf310eb5 ("kfifo: fix kfifo_alloc() to return a signed int value")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kfifo.h~kfifo-fix-kfifo_to_user-return-type
+++ a/include/linux/kfifo.h
@@ -688,7 +688,7 @@ __kfifo_uint_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_to_user(fifo, to, len, copied) \
-__kfifo_uint_must_check_helper( \
+__kfifo_int_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are



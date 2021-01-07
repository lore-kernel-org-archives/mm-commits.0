Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5221C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56EDA20784
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbhAGAVj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbhAGAVj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:21:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC78120784;
        Thu,  7 Jan 2021 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609978859;
        bh=7cjmDBmlXAuIcCgHhm3K3zDeMgfIqmKGGe9LXVbg7Fc=;
        h=Date:From:To:Subject:From;
        b=ksaRTmp5p3k9ku4lPCI5vZuSgOfy0cmxf/7YHyc5UlioGtgdu2FeSlhiYpc0jIo0c
         TYbbkwcD/BJSq0xffB1WnAuT8Rn9nBAuugRK24pgz8Ibr7Vmn/KWeznlKhe/SAFjdo
         E2xrPVCc8LZdfeSgL9VkmoiIEn4Qcvc6pEx3sa7g=
Date:   Wed, 06 Jan 2021 16:20:58 -0800
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, prekageo@amazon.com
Subject:  + scripts-gdb-fix-list_for_each.patch added to -mm tree
Message-ID: <20210107002058.WQUaymko-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix list_for_each
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-list_for_each.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-list_for_each.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-list_for_each.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: George Prekas <prekageo@amazon.com>
Subject: scripts/gdb: fix list_for_each

If the list is uninitialized (next pointer is NULL), list_for_each gets
stuck in an infinite loop. Print a message and treat list as empty.

Link: https://lkml.kernel.org/r/4ae23bb1-c333-f669-da2d-fa35c4f49018@amazon.com
Signed-off-by: George Prekas <prekageo@amazon.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/scripts/gdb/linux/lists.py~scripts-gdb-fix-list_for_each
+++ a/scripts/gdb/linux/lists.py
@@ -27,6 +27,11 @@ def list_for_each(head):
         raise TypeError("Must be struct list_head not {}"
                            .format(head.type))
 
+    if head['next'] == 0:
+        gdb.write("list_for_each: Uninitialized list '{}' treated as empty\n"
+                     .format(head.address))
+        return
+
     node = head['next'].dereference()
     while node.address != head.address:
         yield node.address
_

Patches currently in -mm which might be from prekageo@amazon.com are

scripts-gdb-fix-list_for_each.patch


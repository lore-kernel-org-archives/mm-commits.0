Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C79C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C382864EE1
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhBZBXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhBZBX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F4864F31;
        Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302555;
        bh=xz9opxgThwFT45Sk7LQLdNJWyrpuVqtOy/u3NZiOnhQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kjgOkjhMJcKenyPdnRaWGIZKN75a57+6AcAche4rH98rE0bbDCfN90IiXPGn2aUAz
         UnJFxnd5CA4gIj0QYdZajyO7T0AhVu7GLbr+caLTT4Bd4lg22zqm0BLdyMRQgPdZo9
         uE5paqwa2jy1miqy9iCIsyZwvgaYJszjcuT5DFB4=
Date:   Thu, 25 Feb 2021 17:22:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, prekageo@amazon.com,
        torvalds@linux-foundation.org
Subject:  [patch 114/118] scripts/gdb: fix list_for_each
Message-ID: <20210226012234.Xo_rgwHyK%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

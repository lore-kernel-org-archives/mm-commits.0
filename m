Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E498CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 20:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLOU1I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLOU1F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 15:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24412396C2
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 12:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA98A61F1A
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 20:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D3FC433D2;
        Thu, 15 Dec 2022 20:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671136023;
        bh=7WiSuKeDR3TeL5o2hYANsyYg0qYyCqH/JJdwk6sstz4=;
        h=Date:To:From:Subject:From;
        b=tfMmz0WtY7jm97jiUmx7sfff6bhh4MMwZsVooZXprfK/YJfzN+kL7I83THBhPscia
         B4HzvM8Db3EpVI3jd8QZ/i/9wAalJqexzn69bAwT8yodP8qHMXHkyukQMgpmv7IWA1
         PVN57R/Fb06KqrZq/CUij/ks5MjRmDMeQoYAg5h4=
Date:   Thu, 15 Dec 2022 12:27:02 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        huangzhaoyang@gmail.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch removed from -mm tree
Message-Id: <20221215202703.17D3FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch

This patch was dropped because it was folded into mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
Date: Mon Oct 31 04:23:03 PM PDT 2022

fix v3 layout oddities

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
+++ a/mm/kmemleak.c
@@ -343,7 +343,7 @@ static bool unreferenced_object(struct k
  * print_unreferenced function must be called with the object->lock held.
  */
 static void print_unreferenced(struct seq_file *seq,
-		struct kmemleak_object *object)
+			       struct kmemleak_object *object)
 {
 	int i;
 	unsigned long *entries;
@@ -352,10 +352,10 @@ static void print_unreferenced(struct se
 
 	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
-			object->pointer, object->size);
+			  object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
-			object->comm, object->pid, object->jiffies,
-			msecs_age / 1000, msecs_age % 1000);
+			   object->comm, object->pid, object->jiffies,
+			   msecs_age / 1000, msecs_age % 1000);
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch


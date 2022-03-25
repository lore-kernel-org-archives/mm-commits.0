Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAADC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357489AbiCYBhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357491AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F703153E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75A6E60A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C821FC340ED;
        Fri, 25 Mar 2022 01:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172024;
        bh=5yy7ottMUBSb8ByrFaXmQGJMwrO4Wm8MGvDIVzPuD3s=;
        h=Date:To:From:Subject:From;
        b=kFywNIsrleZ9njRzHSH9eL/FcYW2SJiUplemrUQl5lIR1xeLiDN0zB1/aenvxMC0Y
         iFLzQOJl6e5uKRhJsCsQQPBqOz01Kjsn41/AoDbj/BRdA6Xd/f8viPJsaB//5g9bSO
         mcyRteK6gwGCxIAGxR2wxssiW81CXU2WYACf6Ph0=
Date:   Thu, 24 Mar 2022 18:33:44 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-ksysfsc-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220325013344.C821FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/ksysfs.c: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     kernel-ksysfsc-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: kernel/ksysfs.c: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define kobj_attribute to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112034.48298-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ksysfs.c~kernel-ksysfsc-use-helper-macro-__attr_rw
+++ a/kernel/ksysfs.c
@@ -24,8 +24,7 @@
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
 #define KERNEL_ATTR_RW(_name) \
-static struct kobj_attribute _name##_attr = \
-	__ATTR(_name, 0644, _name##_show, _name##_store)
+static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AA8C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjC1XU6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC1XU5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A06BE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47AA6619BF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2305C433D2;
        Tue, 28 Mar 2023 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045654;
        bh=lp85mvBF9qhqoXBSO1gDCpc6aKWKs4y2tZ+BTMaAXEM=;
        h=Date:To:From:Subject:From;
        b=dDQGHJ8+0esQy5EcjjK+pTdRzbCC9HFdUX0QoQgk7MDpWqbnKWst/2NTuZ0PvifI7
         IfEZHYLQc/DTG8psg0PpVc9GSrH53FF43+0kK5ACKZBxh7Ah51VkzC1Xg+5+E9Bv+P
         Byg5nhfstqhtMSIczbzddSY2Unj5UP7A/D0/FyOc=
Date:   Tue, 28 Mar 2023 16:20:54 -0700
To:     mm-commits@vger.kernel.org, wedsonaf@gmail.com,
        gregkh@linuxfoundation.org, linux@weissschuh.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-make-kobj_type-structure-constant.patch removed from -mm tree
Message-Id: <20230328232054.A2305C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: cma: make kobj_type structure constant
has been removed from the -mm tree.  Its filename was
     mm-cma-make-kobj_type-structure-constant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm: cma: make kobj_type structure constant
Date: Mon, 20 Feb 2023 23:23:31 +0000

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.") the
driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definition to prevent
modification at runtime.

Link: https://lkml.kernel.org/r/20230220-kobj_type-mm-cma-v1-1-45996cff1a81@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma_sysfs.c~mm-cma-make-kobj_type-structure-constant
+++ a/mm/cma_sysfs.c
@@ -64,7 +64,7 @@ static struct attribute *cma_attrs[] = {
 };
 ATTRIBUTE_GROUPS(cma);
 
-static struct kobj_type cma_ktype = {
+static const struct kobj_type cma_ktype = {
 	.release = cma_kobj_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = cma_groups,
_

Patches currently in -mm which might be from linux@weissschuh.net are



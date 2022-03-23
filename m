Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADC0C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiCWXI1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345430AbiCWXIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F40D90CE9
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B82DB8214F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2599BC340E8;
        Wed, 23 Mar 2022 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076806;
        bh=dpebCXcCMZy/nYUwYJF4NBvqp/LWx/U1nCzsUv3INSY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=sLIICAmV2pihPABm58WOUns3Sz/tuniO+drGnHj+HxoC28PGucjSvZGq/4IXWTnxw
         +U0O1XUeBgTAOrwtSY/2Ep+9dYj+rkrHrKpMUMFMXjXZPFqJcj7faAT5KMPC4C8k6r
         /RaasaXAujoZUCvYTixjH/B3X/PLoZwjrctHko4A=
Date:   Wed, 23 Mar 2022 16:06:45 -0700
To:     ryabinin.a.a@gmail.com, lixuefeng@loongson.cn, elver@google.com,
        corbet@lwn.net, bhe@redhat.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 29/41] docs: kdump: update description about sysfs file system support
Message-Id: <20220323230646.2599BC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: kdump: update description about sysfs file system support

Patch series "Update doc and fix some issues about kdump", v2.


This patch (of 5):

After commit 6a108a14fa35 ("kconfig: rename CONFIG_EMBEDDED to
CONFIG_EXPERT"), "Configure standard kernel features (for small systems)"
is not exist, we should use "Configure standard kernel features (expert
users)" now.

Link: https://lkml.kernel.org/r/1644324666-15947-1-git-send-email-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/1644324666-15947-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-update-description-about-sysfs-file-system-support
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -146,9 +146,9 @@ System kernel config options
 	CONFIG_SYSFS=y
 
    Note that "sysfs file system support" might not appear in the "Pseudo
-   filesystems" menu if "Configure standard kernel features (for small
-   systems)" is not enabled in "General Setup." In this case, check the
-   .config file itself to ensure that sysfs is turned on, as follows::
+   filesystems" menu if "Configure standard kernel features (expert users)"
+   is not enabled in "General Setup." In this case, check the .config file
+   itself to ensure that sysfs is turned on, as follows::
 
 	grep 'CONFIG_SYSFS' .config
 
_

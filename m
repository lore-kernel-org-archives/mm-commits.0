Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7816FC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiLAARU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiLAAQ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757FE9951A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20EFEB81D95
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5278C43470;
        Thu,  1 Dec 2022 00:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853628;
        bh=J6dCCJaGCHtN649AXy7m2oN64VqwRF67u9zR//bYUvM=;
        h=Date:To:From:Subject:From;
        b=pgFzyJ0qda5lbf8MVDoJXz0t9icvGqne0TvcKkAWLWhjIHPH57V9+RKljUBvbIavl
         2uXBZeSyj9xd1QrTv2zy8OoXxHAk6D9lEKrHrmQez6YpBmxoPsmtybuTdnWPQgMqQT
         ibwJPGRHqiQYEcwGTwCwzeh8UD/xz0DP1zbx+Vmk=
Date:   Wed, 30 Nov 2022 16:13:48 -0800
To:     mm-commits@vger.kernel.org, zhaogongyi@huawei.com,
        yangyicong@hisilicon.com, weiyongjun1@huawei.com,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rafael@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, david@redhat.com,
        corbet@lwn.net, akinobu.mita@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch removed from -mm tree
Message-Id: <20221201001348.B5278C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/notifier-error-inject: fix error when writing -errno to debugfs file
has been removed from the -mm tree.  Its filename was
     lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lib/notifier-error-inject: fix error when writing -errno to debugfs file
Date: Tue, 20 Sep 2022 02:24:17 +0900

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()").

This restores the previous behaviour by using newly introduced
DEFINE_SIMPLE_ATTRIBUTE_SIGNED instead of DEFINE_SIMPLE_ATTRIBUTE.

Link: https://lkml.kernel.org/r/20220919172418.45257-3-akinobu.mita@gmail.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/notifier-error-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/notifier-error-inject.c~lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file
+++ a/lib/notifier-error-inject.c
@@ -15,7 +15,7 @@ static int debugfs_errno_get(void *data,
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+DEFINE_SIMPLE_ATTRIBUTE_SIGNED(fops_errno, debugfs_errno_get, debugfs_errno_set,
 			"%lld\n");
 
 static struct dentry *debugfs_create_errno(const char *name, umode_t mode,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CE1ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 20:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiISUw5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 16:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiISUw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 16:52:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515CD765E
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 13:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E1461EA9
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 20:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67125C433C1;
        Mon, 19 Sep 2022 20:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663620775;
        bh=IFThZGKCeseJOulYnyZ18iGRxGUhXHO6qUW4+UIe/Gg=;
        h=Date:To:From:Subject:From;
        b=Aexy1vCes6HsXmL2kDOSFGNHF6l2LB+YCSkMmpyjaN6kfsOQ9EZ9FlNPYsiRP1sXQ
         bUForU32AQzEIw3TpsEzpnFPKA6QkkwgZDF7WtTVSf/yZ9AwG0Nne0ReaJgj0xD8Pu
         KcN9EsYdJ6DeexD+1gzkXdg0+qiroSMYvPcd2vqM=
Date:   Mon, 19 Sep 2022 13:52:47 -0700
To:     mm-commits@vger.kernel.org, zhaogongyi@huawei.com,
        yangyicong@hisilicon.com, weiyongjun1@huawei.com,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rafael@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, david@redhat.com,
        corbet@lwn.net, akinobu.mita@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch added to mm-nonmm-unstable branch
Message-Id: <20220919205254.67125C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/notifier-error-inject: fix error when writing -errno to debugfs file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

libfs-add-define_simple_attribute_signed-for-signed-value.patch
lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch
debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch


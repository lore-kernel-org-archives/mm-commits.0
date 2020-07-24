Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BA4C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394CC207FC
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595557231;
	bh=aBaaKnGtlpVLXF6hTKnwkprLRfEuYFmq5Xxu2lpgkxI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MAXXlEkyV+3iYXlMp9cDqgJnq+gVexktySps55H8L2a5pSvaIqVzSpkNzXLB6TuZI
	 pyfWyERKngZK9HewpPLi7AhqmRPhrCaSPLBfOD9bEUChDitmDuweaw0PY0myc0Jgmc
	 WZeJT3vinFEDIsZFnRG136pWoufjfGT7DUlXJ8+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgGXCUa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgGXCUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 22:20:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06390207DF;
        Fri, 24 Jul 2020 02:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595557230;
        bh=aBaaKnGtlpVLXF6hTKnwkprLRfEuYFmq5Xxu2lpgkxI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e3sBjoeR5wo+g+HXSq7btXr+lK5xqTeF9F1mmFKv8CXHirCoK1sL9GU/ZHzqeRuVj
         St5sJOtiazjqMxJbEF4sJahG7n+sQyfz4MJcmnua38YythnkNdMa+4MzZY7WtlMIGz
         r2h7+/J6BleeI8p1XZ7JQlc0KmB2GnvpmyljZ8nU=
Date:   Thu, 23 Jul 2020 19:20:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     keescook@chromium.org, khlebnikov@yandex-team.ru,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        yangtiezhu@loongson.cn
Subject:  +
 lib-test_lockupc-fix-return-value-of-test_lockup_init.patch added to -mm
 tree
Message-ID: <20200724022029.OUaYY9XD7%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_lockup.c: fix return value of test_lockup_init()
has been added to the -mm tree.  Its filename is
     lib-test_lockupc-fix-return-value-of-test_lockup_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_lockupc-fix-return-value-of-test_lockup_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_lockupc-fix-return-value-of-test_lockup_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/test_lockup.c: fix return value of test_lockup_init()

Since filp_open() returns an error pointer, we should use IS_ERR() to
check the return value and then return PTR_ERR() if failed to get the
actual return value instead of always -EINVAL.

E.g. without this patch:

[root@localhost loongson]# ls no_such_file
ls: cannot access no_such_file: No such file or directory
[root@localhost loongson]# modprobe test_lockup file_path=no_such_file lock_sb_umount time_secs=60 state=S
modprobe: ERROR: could not insert 'test_lockup': Invalid argument
[root@localhost loongson]# dmesg | tail -1
[  126.100596] test_lockup: cannot find file_path

With this patch:

[root@localhost loongson]# ls no_such_file
ls: cannot access no_such_file: No such file or directory
[root@localhost loongson]# modprobe test_lockup file_path=no_such_file lock_sb_umount time_secs=60 state=S
modprobe: ERROR: could not insert 'test_lockup': Unknown symbol in module, or unknown parameter (see dmesg)
[root@localhost loongson]# dmesg | tail -1
[   95.134362] test_lockup: failed to open no_such_file: -2

Link: http://lkml.kernel.org/r/1595555407-29875-2-git-send-email-yangtiezhu@loongson.cn
Fixes: aecd42df6d39 ("lib/test_lockup.c: add parameters for locking generic vfs locks")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_lockup.c~lib-test_lockupc-fix-return-value-of-test_lockup_init
+++ a/lib/test_lockup.c
@@ -512,8 +512,8 @@ static int __init test_lockup_init(void)
 	if (test_file_path[0]) {
 		test_file = filp_open(test_file_path, O_RDONLY, 0);
 		if (IS_ERR(test_file)) {
-			pr_err("cannot find file_path\n");
-			return -EINVAL;
+			pr_err("failed to open %s: %ld\n", test_file_path, PTR_ERR(test_file));
+			return PTR_ERR(test_file);
 		}
 		test_inode = file_inode(test_file);
 	} else if (test_lock_inode ||
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

lib-kconfigdebug-make-test_lockup-depend-on-module.patch
lib-test_lockupc-fix-return-value-of-test_lockup_init.patch
selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
kernel-panicc-make-oops_may_print-return-bool.patch
lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch


Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912C2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4462080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266254;
	bh=DBUlGQD7tf9W/pzopaUOkzCnHG7WK1fwBMvD6+pjA2c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Hm12I2/d/ECF/2a9Tdk6+De2m+myjVOQJrvgJhIWY8ID/+HPBcWFlhPfii39oLwMN
	 gy5PEOtPX6txHYxi41OdV4bOIuS59hDX+gGF5fK+Cieogqnp3MgK/+QdjVqJ8w2srA
	 OpbHpZ+TvNqxgurjDvEGqqPMIKmKdcrzhGH89ZHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgHLVEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgHLVEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E830207F7;
        Wed, 12 Aug 2020 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266250;
        bh=DBUlGQD7tf9W/pzopaUOkzCnHG7WK1fwBMvD6+pjA2c=;
        h=Date:From:To:Subject:From;
        b=qW3E41Z7cyUcoGr0+LuPxSWUk8NUeeifqun9t80tbD1BlYTDgpK5GK9Ch+84JpmhG
         DPtnWQ7J+AC8Yrxb2xtD8lYt56IOx67bizCoJOXJrmdIamPDM2GTgZbOHORJTmfenh
         ks4Gvz/kdSxNSTlZ2H4XLLJ5OkqCt3buTtnuUQL8=
Date:   Wed, 12 Aug 2020 14:04:10 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, khlebnikov@yandex-team.ru,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        yangtiezhu@loongson.cn
Subject:  [merged]
 lib-test_lockupc-fix-return-value-of-test_lockup_init.patch removed from
 -mm tree
Message-ID: <20200812210410.OMcIRy873%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_lockup.c: fix return value of test_lockup_init()
has been removed from the -mm tree.  Its filename was
     lib-test_lockupc-fix-return-value-of-test_lockup_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



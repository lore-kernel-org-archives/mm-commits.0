Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89719C678D5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCGWJI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCGWI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:08:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E5ABAE0
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F870B81A8D
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C237FC433A8;
        Tue,  7 Mar 2023 22:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678226925;
        bh=eLewZIqxULUlSADGyKLa7eXHAtvu9t32nKMR1Bifv0Q=;
        h=Date:To:From:Subject:From;
        b=Kib1XWVZnFkrCWApp9zDH0G7wBD1MCXmmzLvoCYRG/II+S/WKry1IptB7XzlcaaSq
         zR16dnKiYfUvX+wUdv64Iui7M9KlAQ3XG746OEfUnFizkYRzfoN1EMIN3q2OnF38Zi
         DiL5TZoNwoYFDIw9pdCLWzYgfIHYe/tnvhEX7eZ4=
Date:   Tue, 07 Mar 2023 14:08:45 -0800
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        kernel@xen0n.name, chenhuacai@kernel.org, arnd@arndb.de,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch added to mm-hotfixes-unstable branch
Message-Id: <20230307220845.C237FC433A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checksyscalls: ignore fstat to silence build warning on LoongArch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: checksyscalls: ignore fstat to silence build warning on LoongArch
Date: Tue, 7 Mar 2023 15:59:00 +0800

fstat is replaced by statx on the new architecture, so an exception is
added to the checksyscalls script to silence the following build warning
on LoongArch:

  CALL    scripts/checksyscalls.sh
<stdin>:569:2: warning: #warning syscall fstat not implemented [-Wcpp]

Link: https://lkml.kernel.org/r/1678175940-20872-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Suggested-by: WANG Xuerui <kernel@xen0n.name>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checksyscalls.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checksyscalls.sh~checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch
+++ a/scripts/checksyscalls.sh
@@ -114,7 +114,6 @@ cat << EOF
 #define __IGNORE_truncate
 #define __IGNORE_stat
 #define __IGNORE_lstat
-#define __IGNORE_fstat
 #define __IGNORE_fcntl
 #define __IGNORE_fadvise64
 #define __IGNORE_newfstatat
@@ -255,6 +254,9 @@ cat << EOF
 /* 64-bit ports never needed these, and new 32-bit ports can use statx */
 #define __IGNORE_fstat64
 #define __IGNORE_fstatat64
+
+/* Newer ports are not required to provide fstat in favor of statx */
+#define __IGNORE_fstat
 EOF
 }
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2639AC7619A
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCWBdO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCWBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C04303F8
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF3B762398
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11058C4339B;
        Thu, 23 Mar 2023 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535131;
        bh=HeE4fTi/JZV/7MQep9e/Aj8/aH1r+yAQLgtXSBAOsug=;
        h=Date:To:From:Subject:From;
        b=FWkuX3GjEpWT3e5X8JVn3/xc3/quPnDrH6qyV2v+Cf/Pv6zqXnnOvHlJViobNMnIF
         pAv8YuzK+thyQHHcYgKAw7vug6exGrRh6F2x6x78IV6plj3DUbQ/Btg8VBVDWc5Dcd
         u//tcsrR9CBq7GnqY9BiVeLytDzEQUn8oxA9ez3A=
Date:   Wed, 22 Mar 2023 18:32:10 -0700
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        kernel@xen0n.name, chenhuacai@kernel.org, arnd@arndb.de,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch removed from -mm tree
Message-Id: <20230323013211.11058C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checksyscalls: ignore fstat to silence build warning on LoongArch
has been removed from the -mm tree.  Its filename was
     checksyscalls-ignore-fstat-to-silence-build-warning-on-loongarch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-kconfigdebug-correct-help-info-of-lockdep_stack_trace_hash_bits.patch


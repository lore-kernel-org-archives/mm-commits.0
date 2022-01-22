Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD509C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiAVBTN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:19:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38814 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBTN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:19:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92DE1CE17BF
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8573CC340E1;
        Sat, 22 Jan 2022 01:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814350;
        bh=Kf7Sydd26Wnrt41YCjFKktdexNrsXTptuCDTwqEq134=;
        h=Date:From:To:Subject:From;
        b=nfq+DvoCuatU/h5Eyw6M0ZU35ISDINXOGo75DjqfEyBmXoC03zHrJjNhCd+v1mLVt
         Pk1+WtP9OirazRuBksqZ7J25XfxCuikICnqBfnnXnPndnt91uCkBBtJP+4bxq5Fgy7
         mV0XVWu4MHE/+lg86d+kzH/Ezayz+4DAI/kwzUlA=
Date:   Fri, 21 Jan 2022 17:19:08 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mic@digikod.net, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [folded-merged]
 sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch removed from -mm
 tree
Message-ID: <20220122011908.D2AQeKo1v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-move-maxolduid-as-a-sysctl-specific-const-fix
has been removed from the -mm tree.  Its filename was
     sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch

This patch was dropped because it was folded into sysctl-move-maxolduid-as-=
a-sysctl-specific-const.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-move-maxolduid-as-a-sysctl-specific-const-fix

fix sysctl_vals[], per Micka=C3=ABl.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~sysctl-move-maxolduid-as-a-sysctl-specific-cons=
t-fix
+++ a/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_sys_dir_operations;
=20
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 65535, INT_M=
AX };
+const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MA=
X, 65535 };
 EXPORT_SYMBOL(sysctl_vals);
=20
 const unsigned long sysctl_long_vals[] =3D { 0, 1, LONG_MAX };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.pa=
tch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


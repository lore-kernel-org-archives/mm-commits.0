Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5559CEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjFSUUX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjFSUUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4632EE71
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDEC560C96
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3580CC433C0;
        Mon, 19 Jun 2023 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206013;
        bh=OATGs6menQH4bhUFL66iH84DPZrFREoGf83RlINEjTM=;
        h=Date:To:From:Subject:From;
        b=gs2Lcx5bfPTg6pIGf7/5Z5UMA0tw8qzS3mm8YMUWecCJxX3Edd0eLI6qIINJ0LINW
         OJSp/COqHzKGr0i5JWIqL/aGSvuaWIPZ2s48AytqngcZqIZIbgtwLohvQBZaAZVCpC
         7wngPipeOc4zd+IE8zOHCCoT1EC0Ihs/J78RUOVw=
Date:   Mon, 19 Jun 2023 13:20:12 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, kbingham@kernel.org, jan.kiszka@siemens.com,
        gehao@kylinos.cn, brauner@kernel.org,
        florian.fainelli@broadcom.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-sb_-constants-parsing.patch removed from -mm tree
Message-Id: <20230619202013.3580CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix SB_* constants parsing
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-sb_-constants-parsing.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix SB_* constants parsing
Date: Wed, 7 Jun 2023 15:13:35 -0700

--0000000000009a0c9905fd9173ad
Content-Transfer-Encoding: 8bit

After f15afbd34d8f ("fs: fix undefined behavior in bit shift for
SB_NOUSER") the constants were changed from plain integers which
LX_VALUE() can parse to constants using the BIT() macro which causes the
following:

Reading symbols from build/linux-custom/vmlinux...done.
Traceback (most recent call last):
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/vmlinux-gdb.py", line 25, in <module>
    import linux.constants
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/scripts/gdb/linux/constants.py", line 5
    LX_SB_RDONLY = ((((1UL))) << (0))

Use LX_GDBPARSED() which does not suffer from that issue.

f15afbd34d8f ("fs: fix undefined behavior in bit shift for SB_NOUSER")
Link: https://lkml.kernel.org/r/20230607221337.2781730-1-florian.fainelli@broadcom.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Cc: Hao Ge <gehao@kylinos.cn>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-fix-sb_-constants-parsing
+++ a/scripts/gdb/linux/constants.py.in
@@ -48,12 +48,12 @@ if IS_BUILTIN(CONFIG_COMMON_CLK):
     LX_GDBPARSED(CLK_GET_RATE_NOCACHE)
 
 /* linux/fs.h */
-LX_VALUE(SB_RDONLY)
-LX_VALUE(SB_SYNCHRONOUS)
-LX_VALUE(SB_MANDLOCK)
-LX_VALUE(SB_DIRSYNC)
-LX_VALUE(SB_NOATIME)
-LX_VALUE(SB_NODIRATIME)
+LX_GDBPARSED(SB_RDONLY)
+LX_GDBPARSED(SB_SYNCHRONOUS)
+LX_GDBPARSED(SB_MANDLOCK)
+LX_GDBPARSED(SB_DIRSYNC)
+LX_GDBPARSED(SB_NOATIME)
+LX_GDBPARSED(SB_NODIRATIME)
 
 /* linux/htimer.h */
 LX_GDBPARSED(hrtimer_resolution)
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are



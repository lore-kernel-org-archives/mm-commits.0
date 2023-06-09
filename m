Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685AAC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 00:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbjFIAo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 20:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjFIAoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 20:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5574A30D6
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 17:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9D36526C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAEEC433EF;
        Fri,  9 Jun 2023 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686271493;
        bh=Mg2hvUyuDegJybyMjRBL/PsptTJQkrsnHTUDCGLw+dQ=;
        h=Date:To:From:Subject:From;
        b=jxTm3FQOlx7W/DGAK0cXfAhOKLtMfhAAo7TBOm/vwR9b32q1SxzmTU4E4G2a7xYC4
         3NfMwHBXlivG5p6oopVfi2dz3ezr6BXti0NvEUMyAKKUEtANx9PCatpfx4Dkb3zZiV
         fgGd5zhc2ays0mcUVTWBvc35xBLoALEmPJcn0GTQ=
Date:   Thu, 08 Jun 2023 17:44:52 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, kbingham@kernel.org, jan.kiszka@siemens.com,
        gehao@kylinos.cn, brauner@kernel.org,
        florian.fainelli@broadcom.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-sb_-constants-parsing.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609004453.2AAEEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix SB_* constants parsing
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-sb_-constants-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-sb_-constants-parsing.patch

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

scripts-gdb-fix-sb_-constants-parsing.patch


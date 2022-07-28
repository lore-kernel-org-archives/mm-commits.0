Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A934C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiG1Sng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiG1Snf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CAF75381
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44AB561DE5
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD51C433D6;
        Thu, 28 Jul 2022 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033813;
        bh=bNBfDZb8NPWg0q+aoF/nPzx4PVGU0klPJHdFDi71Dzc=;
        h=Date:To:From:Subject:From;
        b=zBKdg6TUQSEAStmSUWQqE6ElJJYKaZC/Eaz/cJOy546xvzGZavML3EAsNgRsqzlHi
         zqk3OqdKf32S42c3gRnQlE3T0D/0OoIpix6+gdd5LA8Py0aP/OFopao0JbF08uI2M8
         3pNIQ6skeYLdOyGZ781Es11i//Xy9KDT5/1SajHU=
Date:   Thu, 28 Jul 2022 11:43:30 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, dianders@chromium.org, atomlin@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch added to mm-nonmm-unstable branch
Message-Id: <20220728184333.8CD51C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: ensure the absolute path is generated on initial source
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch

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
From: Aaron Tomlin <atomlin@redhat.com>
Subject: scripts/gdb: ensure the absolute path is generated on initial source
Date: Tue, 12 Jul 2022 12:02:48 +0100

Post 'make scripts_gdb' a symbolic link to scripts/gdb/vmlinux-gdb.py is
created.  Currently 'os.path.dirname(__file__)' does not generate the
absolute path to scripts/gdb resulting in the following:

    (gdb) source vmlinux-gdb.py
    Traceback (most recent call last):
      File "scripts/gdb/vmlinux-gdb.py", line 25, in <module>
	import linux.utils
    ModuleNotFoundError: No module named 'linux'

This patch ensures that the absolute path to scripts/gdb in relation to
the given file is generated so each module can be located accordingly.

Link: https://lkml.kernel.org/r/20220712110248.1404125-1-atomlin@redhat.com
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/vmlinux-gdb.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -13,7 +13,7 @@
 
 import os
 
-sys.path.insert(0, os.path.dirname(__file__) + "/scripts/gdb")
+sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)) + "/scripts/gdb")
 
 try:
     gdb.parse_and_eval("0")
_

Patches currently in -mm which might be from atomlin@redhat.com are

scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch


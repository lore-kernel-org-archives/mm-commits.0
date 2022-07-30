Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD446C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiG3BNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiG3BN1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52C10579
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D9361D3F
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4174C433D6;
        Sat, 30 Jul 2022 01:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143605;
        bh=AbKRPzRgnASd8VfMz5Cz4sN2727Hp19LAEz0/Gl3SXE=;
        h=Date:To:From:Subject:From;
        b=Qtmzh6vCJMDQ0QNxMa7uiQm1wi7Jet7ATL6UYaSad2AWNm0TqfTlalYkTGErElaUE
         usRoHZPQL7wG1VICT9jYfreXJMBegu0EgY2ngXUDo9/pM/ytHnvo212KjIiIa2cKJi
         KAUimqfEpvr2gMkMMYfz4Hnlwv88t3N48cL6inRk=
Date:   Fri, 29 Jul 2022 18:13:24 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, dianders@chromium.org, atomlin@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch removed from -mm tree
Message-Id: <20220730011324.F4174C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: ensure the absolute path is generated on initial source
has been removed from the -mm tree.  Its filename was
     scripts-gdb-ensure-the-absolute-path-is-generated-on-initial-source.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



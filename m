Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E2CC46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjANEGr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjANEGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58AD90
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84254B81AA1
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD07C433D2;
        Sat, 14 Jan 2023 04:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669202;
        bh=hCmxboOQHur2oP5/VERw1YYp+wyWu71majkRoxMptqc=;
        h=Date:To:From:Subject:From;
        b=wtHU8iijQEKgIcmx2maRLa58jTiYo6f8WGR8HgENLBb+OFs9UZ12WZC/KPbrZZhQF
         VYl0Zp17VRTABu0Y2/XFNO+wuRLdJk+t4YALs9Li9shTQzHE890Non+//IVVWgOSKU
         yj60VZ82Ln/Y6YwXBSOBoeMChfRCL6XUwCK0DGfY=
Date:   Fri, 13 Jan 2023 20:06:41 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        mingo@redhat.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, dmitrii.bundin.a@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-mm-introspection-utils-v5.patch added to mm-nonmm-unstable branch
Message-Id: <20230114040642.2AD07C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add mm introspection utils
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-mm-introspection-utils-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-mm-introspection-utils-v5.patch

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
From: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Subject: scripts/gdb: add mm introspection utils
Date: Fri, 13 Jan 2023 20:51:51 +0300

added SPDX line, other tweaks

Link: https://lkml.kernel.org/r/20230113175151.22278-1-dmitrii.bundin.a@gmail.com
Signed-off-by: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/gdb/linux/mm.py~scripts-gdb-add-mm-introspection-utils-v5
+++ a/scripts/gdb/linux/mm.py
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
 #
 # gdb helper commands and functions for Linux kernel debugging
 #
@@ -6,8 +7,6 @@
 # Authors:
 #  Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
 #
-# This work is licensed under the terms of the GNU GPL version 2.
-#
 
 import gdb
 
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-mm-introspection-utils-v5
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -37,3 +37,4 @@ else:
     import linux.clk
     import linux.genpd
     import linux.device
+    import linux.mm
_

Patches currently in -mm which might be from dmitrii.bundin.a@gmail.com are

scripts-gdb-add-mm-introspection-utils.patch
scripts-gdb-add-mm-introspection-utils-v5.patch


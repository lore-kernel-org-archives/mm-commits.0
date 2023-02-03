Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9BDC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjBCGqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjBCGqW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:46:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5612292ED9
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EA3CB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1964C433EF;
        Fri,  3 Feb 2023 06:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406649;
        bh=ltlphLfIdjo72sV/Ys7VptGbBZlR8X6OC5cuRY54bLI=;
        h=Date:To:From:Subject:From;
        b=mFALxVmUaftqqGscGmcgCSRSsud+PZfoWnszrbcMTuGyj0kimION4dJk/ZzJ+qrKn
         rwCJ3/+//hTortAhOtY4XFIOSj1jWX4fLQgV8QWuyXD+c1VUVle7mwrgj5FEIbbp0Z
         N1dPx1/asXykQMHIXJxm+dMBGvW/qd7UJ93JjQeU=
Date:   Thu, 02 Feb 2023 22:44:09 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        mingo@redhat.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, dmitrii.bundin.a@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-add-mm-introspection-utils-v5.patch removed from -mm tree
Message-Id: <20230203064409.B1964C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: add mm introspection utils
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-mm-introspection-utils-v5.patch

This patch was dropped because it was folded into scripts-gdb-add-mm-introspection-utils.patch

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


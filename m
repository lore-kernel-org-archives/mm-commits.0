Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D4EC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E13619E8
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbhKICia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICi3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AD25619A6;
        Tue,  9 Nov 2021 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425344;
        bh=V0S/VvSgzpLFIBPUm2iDO8dWDJVJL5ZbQ+UBuiEVtgM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ry0Wat6sZqjxBYlrDclg+zKj6OGOPl9HCLG19OGTj8p+d+HjnXZ1x8cO8p7I+nF5j
         WkBludeSYiIKVxAQt59JqUsBMMGygDx/x9a3E/YajeFpMsbSHvE/c9Qgrp5WXAWhC6
         6UhWeo6PCcAlrre+ZZLjIDVTfIQ+uZM86UM4Y2pE=
Date:   Mon, 08 Nov 2021 18:35:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dianders@chromium.org,
        jan.kiszka@siemens.com, johannes.berg@intel.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org,
        torvalds@linux-foundation.org
Subject:  [patch 81/87] scripts/gdb: handle split debug for vmlinux
Message-ID: <20211109023543.gtkSlFUiA%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>
Subject: scripts/gdb: handle split debug for vmlinux

This is related to two previous changes.  Commit dfe4529ee4d3
("scripts/gdb: find vmlinux where it was before") and commit da036ae14762
("scripts/gdb: handle split debug").

Although Chrome OS has been using the debug suffix for modules for a
while, it has just recently started using it for vmlinux as well.  That
means we've now got to improve the detection of "vmlinux" to also handle
that it might end with ".debug".

Link: https://lkml.kernel.org/r/20211028151120.v2.1.Ie6bd5a232f770acd8c9ffae487a02170bad3e963@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-handle-split-debug-for-vmlinux
+++ a/scripts/gdb/linux/symbols.py
@@ -148,7 +148,8 @@ lx-symbols command."""
         # drop all current symbols and reload vmlinux
         orig_vmlinux = 'vmlinux'
         for obj in gdb.objfiles():
-            if obj.filename.endswith('vmlinux'):
+            if (obj.filename.endswith('vmlinux') or
+                obj.filename.endswith('vmlinux.debug')):
                 orig_vmlinux = obj.filename
         gdb.execute("symbol-file", to_string=True)
         gdb.execute("symbol-file {0}".format(orig_vmlinux))
_

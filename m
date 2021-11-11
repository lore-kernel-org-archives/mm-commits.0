Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1582DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E686162E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhKKC5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234627AbhKKC47 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A33B61075;
        Thu, 11 Nov 2021 02:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599251;
        bh=srGdhW+DbiXSl7/6I1SFfQ1LhVYrVliwQXWW03jpGu8=;
        h=Date:From:To:Subject:From;
        b=0r4RFKoeai/vQXR8wCtRDkGsUPRkFlIJLtoIoDbT93GtyWEX8ps/874zf6ED+tc2G
         oj8fHgPyxIGifgmL84nHo2ZSx35E77txZjsM2AdHn2x4xhA61ho41NdOrbgu85O0oY
         RNa9EfdRkIYM0iUqkKkzlt7WMmLaaUXL+/24SYks=
Date:   Wed, 10 Nov 2021 18:54:11 -0800
From:   akpm@linux-foundation.org
To:     dianders@chromium.org, jan.kiszka@siemens.com,
        johannes.berg@intel.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org
Subject:  [merged] scripts-gdb-handle-split-debug-for-vmlinux.patch
 removed from -mm tree
Message-ID: <20211111025411.ONrM2bRMf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: handle split debug for vmlinux
has been removed from the -mm tree.  Its filename was
     scripts-gdb-handle-split-debug-for-vmlinux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dianders@chromium.org are



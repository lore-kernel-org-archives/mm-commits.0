Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1B5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 23:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F1D610C7
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhJ2X1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Oct 2021 19:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhJ2X1G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 Oct 2021 19:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CBC60FC0;
        Fri, 29 Oct 2021 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635549877;
        bh=6k/rFBIsbKTjuT/4BuC9RyqdBEIxBYgNKVHvtX+yVmY=;
        h=Date:From:To:Subject:From;
        b=TSsM/pXABKyMszn/x8pNWYZdq2eXIICJLZRuMi0ygYl0pVP8RQ0nnOhFqyvwfwsiG
         /TEWuSE7b0Stan1f0UddPOnYZTjuibVTunggH1044aZdVQImLBWGpfdHAQovLActDl
         JZqNF5uOU/A4mLWraR2vGk2Yll2mWttkFLGjLwC4=
Date:   Fri, 29 Oct 2021 16:24:36 -0700
From:   akpm@linux-foundation.org
To:     dianders@chromium.org, jan.kiszka@siemens.com,
        johannes.berg@intel.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org
Subject:  + scripts-gdb-handle-split-debug-for-vmlinux.patch added
 to -mm tree
Message-ID: <20211029232436.MqFonOKMi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: handle split debug for vmlinux
has been added to the -mm tree.  Its filename is
     scripts-gdb-handle-split-debug-for-vmlinux.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-handle-split-debug-for-vmlinux.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-handle-split-debug-for-vmlinux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-handle-split-debug-for-vmlinux.patch


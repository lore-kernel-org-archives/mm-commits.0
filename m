Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C508CC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 19:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDLTSA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDLTSA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 15:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A664B5FDA
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 12:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40AA76306B
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 19:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C68C433D2;
        Wed, 12 Apr 2023 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681327073;
        bh=WvveszCj/yDmUSp0njV6sD8qTp4Q2pERIvntfNCHEtc=;
        h=Date:To:From:Subject:From;
        b=Kvz0qWJ2BKLdL+vmkrgk5ntnMR1/NOiWKmHrOxGvoiLcx2tmZ7qOiTAdJR9ckbmLO
         Qz33R/5wOjDQGq9KbDj0KkjCZAYtbgloa0W+aYz32bEqR79gr+CBulnNbYEVPS+aAo
         slLzgPkoqvdhgA/qmI5vQ3YaTLR+u0OTA0P3RJ5Q=
Date:   Wed, 12 Apr 2023 12:17:53 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        pmladek@suse.com, kbingham@kernel.org, john.ogness@linutronix.de,
        jan.kiszka@siemens.com, antonio.borneo@foss.st.com,
        development@efficientek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch added to mm-nonmm-unstable branch
Message-Id: <20230412191753.94C68C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add GDB convenience functions $lx_dentry_name() and $lx_i_dentry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch

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
From: Glenn Washburn <development@efficientek.com>
Subject: scripts/gdb: add GDB convenience functions $lx_dentry_name() and $lx_i_dentry()
Date: Tue, 28 Feb 2023 18:53:35 -0600

$lx_dentry_name() generates a full VFS path from a given dentry pointer,
and $lx_i_dentry() returns the dentry pointer associated with the given
inode pointer, if there is one.

Link: https://lkml.kernel.org/r/c9a5ad8efbfbd2cc6559e082734eed7628f43a16.1677631565.git.development@efficientek.com
Signed-off-by: Glenn Washburn <development@efficientek.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/vfs.py |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/scripts/gdb/linux/vfs.py~scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry
+++ a/scripts/gdb/linux/vfs.py
@@ -13,6 +13,9 @@
 # This work is licensed under the terms of the GNU GPL version 2.
 #
 
+import gdb
+from linux import utils
+
 
 def dentry_name(d):
     parent = d['d_parent']
@@ -20,3 +23,37 @@ def dentry_name(d):
         return ""
     p = dentry_name(d['d_parent']) + "/"
     return p + d['d_iname'].string()
+
+class DentryName(gdb.Function):
+    """Return string of the full path of a dentry.
+
+$lx_dentry_name(PTR): Given PTR to a dentry struct, return a string
+of the full path of the dentry."""
+
+    def __init__(self):
+        super(DentryName, self).__init__("lx_dentry_name")
+
+    def invoke(self, dentry_ptr):
+        return dentry_name(dentry_ptr)
+
+DentryName()
+
+
+dentry_type = utils.CachedType("struct dentry")
+
+class InodeDentry(gdb.Function):
+    """Return dentry pointer for inode.
+
+$lx_i_dentry(PTR): Given PTR to an inode struct, return a pointer to
+the associated dentry struct, if there is one."""
+
+    def __init__(self):
+        super(InodeDentry, self).__init__("lx_i_dentry")
+
+    def invoke(self, inode_ptr):
+        d_u = inode_ptr["i_dentry"]["first"]
+        if d_u == 0:
+            return ""
+        return utils.container_of(d_u, dentry_type.get_type().pointer(), "d_u")
+
+InodeDentry()
_

Patches currently in -mm which might be from development@efficientek.com are

scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers.patch
scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch


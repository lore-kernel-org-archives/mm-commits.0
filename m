Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E166C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjDRXmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjDRXl1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799D8C648
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C86630A2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F0C433D2;
        Tue, 18 Apr 2023 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861229;
        bh=hzDSVneOH8Z7jJeejn7sazvQtV29u73wItjQz2tyH3A=;
        h=Date:To:From:Subject:From;
        b=gGglvpofpJFFlWhO4qvrAHGXwZDB+Pi8FVAerbJg0ZvCD24Qr6VB3ABAzE2ykMPg3
         4GbVX1lfDujqBOj8wmNgzoJOaaaKCiRY8JU7MtunfwjUuF7ukCR4FxtXKJk02u6CoA
         4EWpDOJggRviketVpJClFJBigyUymuZvv9TXtbYM=
Date:   Tue, 18 Apr 2023 16:40:28 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        pmladek@suse.com, kbingham@kernel.org, john.ogness@linutronix.de,
        jan.kiszka@siemens.com, antonio.borneo@foss.st.com,
        development@efficientek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch removed from -mm tree
Message-Id: <20230418234029.187F0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: add GDB convenience functions $lx_dentry_name() and $lx_i_dentry()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-gdb-convenience-functions-lx_dentry_name-and-lx_i_dentry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03A13AA45
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248788; cv=none; b=LZEEMwMkUEz30Bov2crWgOA1VxugvDP4ffsbqgHKR/yLNzyAxC6sDI92HBsBuHxFF2E9tqhInvlFElIS3rru3t0IsZykFb4Qa+yugLXnaglzvBMFX0Hg+WZ3PZeiTn+Y+rqAVcyFM6FoLvbpM+h8T4adyZIjx46Vr0BW32g9B/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248788; c=relaxed/simple;
	bh=JLGNYHoBRAivbM4gdyvBYF89Gxij5Ba5u8a8Jk4Q4vg=;
	h=Date:To:From:Subject:Message-Id; b=RGVJWbaaF/EjwZSIZwewoJhHCWFzkmsaBuAKv6qCj3ml9gMw3wTS0Fu39CbRUNcg4z4y2EgUKJxuirnpUXPBKcLYA7iSp8R1DHwUA9nZAlUfFob2QCXzIlBpmG5yLpzsEL7PEZxi5BQz3bUP592Ww03zX4XJsZ1KG9bQRhmzh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eEknQdNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eEknQdNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A68C4CEC2;
	Mon,  2 Sep 2024 03:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248787;
	bh=JLGNYHoBRAivbM4gdyvBYF89Gxij5Ba5u8a8Jk4Q4vg=;
	h=Date:To:From:Subject:From;
	b=eEknQdNgkOyMuBxpT9piNIzzlXgLVzExpIOogXq+YF8iJFuUFVF6CVwzsQhRqZr7C
	 lXLJ1fMHkjadO44/Lf7fE755vLq/c/8JtVYtreeVXMHmIdluEkD/cWCOpzJXXHDQRA
	 iG2PdLvmh7uwigt8UWpvxBlnGTpleD/R2yDB+cl0=
Date: Sun, 01 Sep 2024 20:46:27 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch removed from -mm tree
Message-Id: <20240902034627.B8A68C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: add 'lx-kasan_mem_to_shadow' command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: add 'lx-kasan_mem_to_shadow' command
Date: Tue, 23 Jul 2024 14:49:01 +0800

This command allows users to quickly translate memory address to the kasan
shadow memory address.

Example output:
(gdb) lx-kasan_mem_to_shadow 0xffff000019acc008
shadow addr: 0xffff600003359801

Link: https://lkml.kernel.org/r/20240723064902.124154-6-kuan-ying.lee@canonical.com
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/kasan.py |   44 +++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 
 2 files changed, 45 insertions(+)

diff --git a/scripts/gdb/linux/kasan.py a/scripts/gdb/linux/kasan.py
new file mode 100664
--- /dev/null
+++ a/scripts/gdb/linux/kasan.py
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2024 Canonical Ltd.
+#
+# Authors:
+#  Kuan-Ying Lee <kuan-ying.lee@canonical.com>
+#
+
+import gdb
+from linux import constants, mm
+
+def help():
+    t = """Usage: lx-kasan_mem_to_shadow [Hex memory addr]
+    Example:
+        lx-kasan_mem_to_shadow 0xffff000008eca008\n"""
+    gdb.write("Unrecognized command\n")
+    raise gdb.GdbError(t)
+
+class KasanMemToShadow(gdb.Command):
+    """Translate memory address to kasan shadow address"""
+
+    p_ops = None
+
+    def __init__(self):
+        if constants.LX_CONFIG_KASAN_GENERIC or constants.LX_CONFIG_KASAN_SW_TAGS:
+            super(KasanMemToShadow, self).__init__("lx-kasan_mem_to_shadow", gdb.COMMAND_SUPPORT)
+
+    def invoke(self, args, from_tty):
+        if not constants.LX_CONFIG_KASAN_GENERIC or constants.LX_CONFIG_KASAN_SW_TAGS:
+            raise gdb.GdbError('CONFIG_KASAN_GENERIC or CONFIG_KASAN_SW_TAGS is not set')
+
+        argv = gdb.string_to_argv(args)
+        if len(argv) == 1:
+            if self.p_ops is None:
+                self.p_ops = mm.page_ops().ops
+            addr = int(argv[0], 16)
+            shadow_addr = self.kasan_mem_to_shadow(addr)
+            gdb.write('shadow addr: 0x%x\n' % shadow_addr)
+        else:
+            help()
+    def kasan_mem_to_shadow(self, addr):
+        return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_ops.KASAN_SHADOW_OFFSET
+
+KasanMemToShadow()
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-lx-kasan_mem_to_shadow-command
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -49,3 +49,4 @@ else:
     import linux.page_owner
     import linux.slab
     import linux.vmalloc
+    import linux.kasan
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are



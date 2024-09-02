Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D867214F9D9
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248786; cv=none; b=UXoCq47bHYDXalVsCtm6AhBwyz0hKvtMsNZTgoqKDs90rthwLB94Bhr1oU1FbKWQAe+44L7rn3dS8XQBG+HExcOLD3mT4Gg0c7qnCwUc7geZH3Um2MqLR5QQvaTPqTa1lH3icNpF8/qUgjCEpk4Vw8BCz3ux8R2IygC22dEZB8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248786; c=relaxed/simple;
	bh=lJJXLU7E421zjUfZc3Sn9FQYuhdVqz6LL0V6kMF2qP0=;
	h=Date:To:From:Subject:Message-Id; b=AAZYGYz2Tyzn8pd/z0o5uORJMY9mfpWzNT781c+8fvrnV2/mDpJf94ral73m3XfzAL78P6aBOP9a0V7jZ7JF37VsoLl7U5Ls+E0XDolfG2opO+08UWJEWqZUVq5gSbKa40/GI3qBdsQY0Or77SUqYAupYKIhEF08jy9KZ/ufDqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=080cf6tW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="080cf6tW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0764C4CEC7;
	Mon,  2 Sep 2024 03:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248786;
	bh=lJJXLU7E421zjUfZc3Sn9FQYuhdVqz6LL0V6kMF2qP0=;
	h=Date:To:From:Subject:From;
	b=080cf6tWAGEydkJrJ0IF3a+9TAIC0i0UhTUswfc1K4QLQ9SSG3KKKjRLQLN8QcqVk
	 Hj7eVfRXBqg2ic0t5cT0EKu+fP9z0i4cA2pq7sqJlzaR9iTDLngAoH5FbTxoHMOYQm
	 3hxVTeOdCmgioNkivPSWZMgrW7lSyGSJUQC9kRAI=
Date: Sun, 01 Sep 2024 20:46:26 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-lx-stack_depot_lookup-command.patch removed from -mm tree
Message-Id: <20240902034626.B0764C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: add 'lx-stack_depot_lookup' command.
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx-stack_depot_lookup-command.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: add 'lx-stack_depot_lookup' command.
Date: Tue, 23 Jul 2024 14:49:00 +0800

This command allows users to quickly retrieve a stacktrace using a handle
obtained from a memory coredump.

Example output:
(gdb) lx-stack_depot_lookup 0x00c80300
   0xffff8000807965b4 <kmem_cache_alloc_noprof+660>:    mov     x20, x0
   0xffff800081a077d8 <kmem_cache_oob_alloc+76>:        mov     x1, x0
   0xffff800081a079a0 <test_version_show+100>:  cbnz    w0, 0xffff800081a07968 <test_version_show+44>
   0xffff800082f4a3fc <kobj_attr_show+60>:      ldr     x19, [sp, #16]
   0xffff800080a0fb34 <sysfs_kf_seq_show+460>:  ldp     x3, x4, [sp, #96]
   0xffff800080a0a550 <kernfs_seq_show+296>:    ldp     x19, x20, [sp, #16]
   0xffff8000808e7b40 <seq_read_iter+836>:      mov     w5, w0
   0xffff800080a0b8ac <kernfs_fop_read_iter+804>:       mov     x23, x0
   0xffff800080914a48 <copy_splice_read+972>:   mov     x6, x0
   0xffff8000809151c4 <do_splice_read+348>:     ldr     x21, [sp, #32]

Link: https://lkml.kernel.org/r/20240723064902.124154-5-kuan-ying.lee@canonical.com
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/stackdepot.py |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-add-lx-stack_depot_lookup-command
+++ a/scripts/gdb/linux/stackdepot.py
@@ -13,6 +13,13 @@ if constants.LX_CONFIG_STACKDEPOT:
     stack_record_type = utils.CachedType('struct stack_record')
     DEPOT_STACK_ALIGN = 4
 
+def help():
+    t = """Usage: lx-stack_depot_lookup [Hex handle value]
+    Example:
+        lx-stack_depot_lookup 0x00c80300\n"""
+    gdb.write("Unrecognized command\n")
+    raise gdb.GdbError(t)
+
 def stack_depot_fetch(handle):
     global DEPOT_STACK_ALIGN
     global stack_record_type
@@ -57,3 +64,23 @@ def stack_depot_print(handle):
                 gdb.execute("x /i 0x%x" % (int(entries[i])))
             except Exception as e:
                 gdb.write("%s\n" % e)
+
+class StackDepotLookup(gdb.Command):
+    """Search backtrace by handle"""
+
+    def __init__(self):
+        if constants.LX_CONFIG_STACKDEPOT:
+            super(StackDepotLookup, self).__init__("lx-stack_depot_lookup", gdb.COMMAND_SUPPORT)
+
+    def invoke(self, args, from_tty):
+        if not constants.LX_CONFIG_STACKDEPOT:
+            raise gdb.GdbError('CONFIG_STACKDEPOT is not set')
+
+        argv = gdb.string_to_argv(args)
+        if len(argv) == 1:
+            handle = int(argv[0], 16)
+            stack_depot_print(gdb.Value(handle).cast(utils.get_uint_type()))
+        else:
+            help()
+
+StackDepotLookup()
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are



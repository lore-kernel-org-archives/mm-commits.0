Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E81494D6
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 23:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778046; cv=none; b=SfN6GJK2bfINzTm4pzY6NFte2EYx7MrWyJrVEaS5w0Lv+ojN68VAJsoBoEPuBZVrD2lu6RdnaYEnFWh4shjp6P1YEQAamOXM0t1Ccw5q7BD7Siqnf1xirsGI9iQ14aF5Cg99AU+JynHJEln8IG+whaJ6+Elb5tuoyZoiX0jECGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778046; c=relaxed/simple;
	bh=t4HScLXbtQByScY/Fw9S+7Go0sfSCgT1mGHXF+WWmFo=;
	h=Date:To:From:Subject:Message-Id; b=kz/UpDeTVDrw0OQGgqyc36oSwyzBmGO/7YxME8T+7F0cBvDVSl1ox31QN1V4UDNwwswEcven2Py6Hnkypu/y8UL5T+v6f1u0vCmQhRxJIkPbUp1VyJa+1UZAWgho9ZWrWiwd9yQFeFzxLZn64/5PRTqID1vYXj8Tz7So8C31xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVxvdUAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVxvdUAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA5AC4AF0A;
	Tue, 23 Jul 2024 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778046;
	bh=t4HScLXbtQByScY/Fw9S+7Go0sfSCgT1mGHXF+WWmFo=;
	h=Date:To:From:Subject:From;
	b=qVxvdUAaUw3jtIqQBbcuC8f53ZYejDwSpewbfHAdInKXI8E4lR6464Hz1ecWof1C5
	 cdZiVd8LOr7/wGOhXgQ+PqT1CqtU9w+aWvdvMTwlhzwx+NPuyreLnWETMbHX6FPn2C
	 rGb5Sbrl8l5V8sFMpDR1K3QocmuLvKOvq22/U/MY=
Date: Tue, 23 Jul 2024 16:40:45 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch added to mm-nonmm-unstable branch
Message-Id: <20240723234046.2DA5AC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: add 'lx-kasan_mem_to_shadow' command
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

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

scripts-gdb-fix-timerlist-parsing-issue.patch
scripts-gdb-add-iteration-function-for-rbtree.patch
scripts-gdb-fix-lx-mounts-command-error.patch
scripts-gdb-add-lx-stack_depot_lookup-command.patch
scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch


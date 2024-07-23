Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7271494D6
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778044; cv=none; b=BDpRCb3Dsc/RchviUsKOLuGxtFcsePYxi5nGF+bvygOIer7NwukfzLZzY8UzIpHRlCTboWFpleKk2tGx+rvZCbITG4KZfePxwJyHJYWdFQtjRjT4123FHGva2e3are6afWqyIH4PCH85Js+bgNl2S2j1DBVjnD7PrfNkOcZXpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778044; c=relaxed/simple;
	bh=MS+eyO9Gh5kUTyYa7uOsJbxCQF1twuJcoOAiDVrv68g=;
	h=Date:To:From:Subject:Message-Id; b=i+bVL7seAI/H5RlYv0l5GAyF5XvjKoiRLVudBRTGXoWvCoeg2SgiokIssRj7CrcJH3OgBddvA9vtsDY4G09IXoZjff+U9n/s6BI4N8UBC3dmGz3wMNoDjGiS4DiOgvXklYzu8mFbLSwe+4id4yd7IMMRLfDjRc530jixvFPcX0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3wsR5HB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3wsR5HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8CAC4AF0A;
	Tue, 23 Jul 2024 23:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778044;
	bh=MS+eyO9Gh5kUTyYa7uOsJbxCQF1twuJcoOAiDVrv68g=;
	h=Date:To:From:Subject:From;
	b=t3wsR5HBN5IzEQootnDuE80LX27wO7ZLepAaTkKEtaefhYC1+zT5J/nBm5xcqtvJJ
	 xCKKa9hVsxyYAD0I486LQ1ROBi2faa4MS91baDy8UALYgPFWGtCp4ynh2EhaFWjeUu
	 rRZxBTwh7m/Vr3ev9MyQ81ScgmPpNOMAJMJJG4U8=
Date: Tue, 23 Jul 2024 16:40:43 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-lx-stack_depot_lookup-command.patch added to mm-nonmm-unstable branch
Message-Id: <20240723234044.6D8CAC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: add 'lx-stack_depot_lookup' command.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-lx-stack_depot_lookup-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-lx-stack_depot_lookup-command.patch

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

scripts-gdb-fix-timerlist-parsing-issue.patch
scripts-gdb-add-iteration-function-for-rbtree.patch
scripts-gdb-fix-lx-mounts-command-error.patch
scripts-gdb-add-lx-stack_depot_lookup-command.patch
scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch


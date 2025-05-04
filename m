Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFB7320F
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336996; cv=none; b=u0j4aui3WVBeR1f4MGYXsXHXhBl3MYGJstDQkraLEnJAVgJQRDsuKXpLj7sIXl+rHH8velIQRDYawnUYsejAoQZIwx0wqsQtyjViNcihYrxz1VztTiYNKfLxQTOsGZ05MbjCsdkSKvTui6R1J7vrEDgH0Hy0XvvATSJ/NBk3daM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336996; c=relaxed/simple;
	bh=UEUh1CjV2A6yD7t7mtxTJAeGe0IGGS+YkxInLEpSDV4=;
	h=Date:To:From:Subject:Message-Id; b=KlWPncN6k+QBqs26CJrAhTOBU39db6peQQk/pvva0hIanReas0MNF6WSGthrrauUCDZoiCfL36SNtIH9y7Ubm05V+Bwd7fr40Dq3bXQ9lPdqIztzzxCSScttWtGVAjHvTmaZ9PnKrrAUoJbCQBRj6duL2VmkTAfGkwjnVygGIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pi5gIbrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pi5gIbrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DCBC4CEE9;
	Sun,  4 May 2025 05:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746336994;
	bh=UEUh1CjV2A6yD7t7mtxTJAeGe0IGGS+YkxInLEpSDV4=;
	h=Date:To:From:Subject:From;
	b=pi5gIbrxdfwtMEJ09UUJoV124RP9G17K2t67ygJDOwyUuicoNFl8m6OLB9n+y6poE
	 e4yI3bJPgurIwAvi2iJQxgBr4uY0BKoy+5G5+HONodu9kxQ9ivjAfuclGYa86VvDH4
	 wdFujITbHT+Ls4a44bpaoNsU6EMGj6YSzYDm+H3s=
Date: Sat, 03 May 2025 22:36:33 -0700
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,mail@florommel.de,kbingham@kernel.org,jan.kiszka@siemens.com,jackmanb@google.com,dzm91@hust.edu.cn,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-update-documentation-for-lx_per_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20250504053634.61DCBC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: update documentation for lx_per_cpu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-update-documentation-for-lx_per_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-update-documentation-for-lx_per_cpu.patch

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
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts/gdb: update documentation for lx_per_cpu
Date: Sat, 3 May 2025 14:32:32 +0200

Commit db08c53fdd542bb7f83b ("scripts/gdb: fix parameter handling in
$lx_per_cpu") changed the parameter handling of lx_per_cpu to use GdbValue
instead of parsing the variable name.  Update the documentation to reflect
the new lx_per_cpu usage.  Update the hrtimer_bases example to use rb_tree
instead of the timerqueue_head.next pointer removed in commit
511885d7061eda3eb1fa ("lib/timerqueue: Rely on rbtree semantics for next
timer").

Link: https://lkml.kernel.org/r/20250503123234.2407184-3-illia@yshyn.com
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Florian Rommel <mail@florommel.de>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/debugging/gdb-kernel-debugging.rst            |   34 ++++------
 Documentation/translations/zh_CN/dev-tools/gdb-kernel-debugging.rst |   34 ++++------
 Documentation/translations/zh_TW/dev-tools/gdb-kernel-debugging.rst |   34 ++++------
 scripts/gdb/linux/cpus.py                                           |    4 -
 4 files changed, 47 insertions(+), 59 deletions(-)

--- a/Documentation/process/debugging/gdb-kernel-debugging.rst~scripts-gdb-update-documentation-for-lx_per_cpu
+++ a/Documentation/process/debugging/gdb-kernel-debugging.rst
@@ -127,35 +127,31 @@ Examples of using the Linux-provided gdb
 
 - Make use of the per-cpu function for the current or a specified CPU::
 
-    (gdb) p $lx_per_cpu("runqueues").nr_running
+    (gdb) p $lx_per_cpu(runqueues).nr_running
     $3 = 1
-    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
+    (gdb) p $lx_per_cpu(runqueues, 2).nr_running
     $4 = 0
 
 - Dig into hrtimers using the container_of helper::
 
-    (gdb) set $next = $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
-    (gdb) p *$container_of($next, "struct hrtimer", "node")
+    (gdb) set $leftmost = $lx_per_cpu(hrtimer_bases).clock_base[0].active.rb_root.rb_leftmost
+    (gdb) p *$container_of($leftmost, "struct hrtimer", "node")
     $5 = {
       node = {
         node = {
-          __rb_parent_color = 18446612133355256072,
-          rb_right = 0x0 <irq_stack_union>,
-          rb_left = 0x0 <irq_stack_union>
+          __rb_parent_color = 18446612686384860673,
+          rb_right = 0xffff888231da8b00,
+          rb_left = 0x0
         },
-        expires = {
-          tv64 = 1835268000000
-        }
+        expires = 1228461000000
       },
-      _softexpires = {
-        tv64 = 1835268000000
-      },
-      function = 0xffffffff81078232 <tick_sched_timer>,
-      base = 0xffff88003fd0d6f0,
-      state = 1,
-      start_pid = 0,
-      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
-      start_comm = "swapper/2\000\000\000\000\000\000"
+      _softexpires = 1228461000000,
+      function = 0xffffffff8137ab20 <tick_nohz_handler>,
+      base = 0xffff888231d9b4c0,
+      state = 1 '\001',
+      is_rel = 0 '\000',
+      is_soft = 0 '\000',
+      is_hard = 1 '\001'
     }
 
 
--- a/Documentation/translations/zh_CN/dev-tools/gdb-kernel-debugging.rst~scripts-gdb-update-documentation-for-lx_per_cpu
+++ a/Documentation/translations/zh_CN/dev-tools/gdb-kernel-debugging.rst
@@ -120,35 +120,31 @@ 使用Linux提供的gdb脚本的示例
 
 - 对当前或指定的CPU使用per-cpu函数::
 
-    (gdb) p $lx_per_cpu("runqueues").nr_running
+    (gdb) p $lx_per_cpu(runqueues).nr_running
     $3 = 1
-    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
+    (gdb) p $lx_per_cpu(runqueues, 2).nr_running
     $4 = 0
 
 - 使用container_of查看更多hrtimers信息::
 
-    (gdb) set $next = $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
-    (gdb) p *$container_of($next, "struct hrtimer", "node")
+    (gdb) set $leftmost = $lx_per_cpu(hrtimer_bases).clock_base[0].active.rb_root.rb_leftmost
+    (gdb) p *$container_of($leftmost, "struct hrtimer", "node")
     $5 = {
       node = {
         node = {
-          __rb_parent_color = 18446612133355256072,
-          rb_right = 0x0 <irq_stack_union>,
-          rb_left = 0x0 <irq_stack_union>
+          __rb_parent_color = 18446612686384860673,
+          rb_right = 0xffff888231da8b00,
+          rb_left = 0x0
         },
-        expires = {
-          tv64 = 1835268000000
-        }
+        expires = 1228461000000
       },
-      _softexpires = {
-        tv64 = 1835268000000
-      },
-      function = 0xffffffff81078232 <tick_sched_timer>,
-      base = 0xffff88003fd0d6f0,
-      state = 1,
-      start_pid = 0,
-      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
-      start_comm = "swapper/2\000\000\000\000\000\000"
+      _softexpires = 1228461000000,
+      function = 0xffffffff8137ab20 <tick_nohz_handler>,
+      base = 0xffff888231d9b4c0,
+      state = 1 '\001',
+      is_rel = 0 '\000',
+      is_soft = 0 '\000',
+      is_hard = 1 '\001'
     }
 
 
--- a/Documentation/translations/zh_TW/dev-tools/gdb-kernel-debugging.rst~scripts-gdb-update-documentation-for-lx_per_cpu
+++ a/Documentation/translations/zh_TW/dev-tools/gdb-kernel-debugging.rst
@@ -116,35 +116,31 @@ 使用Linux提供的gdb腳本的示例
 
 - 對當前或指定的CPU使用per-cpu函數::
 
-    (gdb) p $lx_per_cpu("runqueues").nr_running
+    (gdb) p $lx_per_cpu(runqueues).nr_running
     $3 = 1
-    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
+    (gdb) p $lx_per_cpu(runqueues, 2).nr_running
     $4 = 0
 
 - 使用container_of查看更多hrtimers信息::
 
-    (gdb) set $next = $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
-    (gdb) p *$container_of($next, "struct hrtimer", "node")
+    (gdb) set $leftmost = $lx_per_cpu(hrtimer_bases).clock_base[0].active.rb_root.rb_leftmost
+    (gdb) p *$container_of($leftmost, "struct hrtimer", "node")
     $5 = {
       node = {
         node = {
-          __rb_parent_color = 18446612133355256072,
-          rb_right = 0x0 <irq_stack_union>,
-          rb_left = 0x0 <irq_stack_union>
+          __rb_parent_color = 18446612686384860673,
+          rb_right = 0xffff888231da8b00,
+          rb_left = 0x0
         },
-        expires = {
-          tv64 = 1835268000000
-        }
+        expires = 1228461000000
       },
-      _softexpires = {
-        tv64 = 1835268000000
-      },
-      function = 0xffffffff81078232 <tick_sched_timer>,
-      base = 0xffff88003fd0d6f0,
-      state = 1,
-      start_pid = 0,
-      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
-      start_comm = "swapper/2\000\000\000\000\000\000"
+      _softexpires = 1228461000000,
+      function = 0xffffffff8137ab20 <tick_nohz_handler>,
+      base = 0xffff888231d9b4c0,
+      state = 1 '\001',
+      is_rel = 0 '\000',
+      is_soft = 0 '\000',
+      is_hard = 1 '\001'
     }
 
 
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-update-documentation-for-lx_per_cpu
+++ a/scripts/gdb/linux/cpus.py
@@ -141,7 +141,7 @@ LxCpus()
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
 
-$lx_per_cpu("VAR"[, CPU]): Return the per-cpu variable called VAR for the
+$lx_per_cpu(VAR[, CPU]): Return the per-cpu variable called VAR for the
 given CPU number. If CPU is omitted, the CPU of the current context is used.
 Note that VAR has to be quoted as string."""
 
@@ -158,7 +158,7 @@ PerCpu()
 class PerCpuPtr(gdb.Function):
     """Return per-cpu pointer.
 
-$lx_per_cpu_ptr("VAR"[, CPU]): Return the per-cpu pointer called VAR for the
+$lx_per_cpu_ptr(VAR[, CPU]): Return the per-cpu pointer called VAR for the
 given CPU number. If CPU is omitted, the CPU of the current context is used.
 Note that VAR has to be quoted as string."""
 
_

Patches currently in -mm which might be from illia@yshyn.com are

scripts-gdb-fix-kgdb-probing-on-single-core-systems.patch
scripts-gdb-update-documentation-for-lx_per_cpu.patch


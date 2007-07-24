From: akpm@linux-foundation.org
Subject: - fault_inject-silence-a-warning.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:48 -0700
Message-ID: <200707242324.l6ONOmm7006304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757070AbXGXXY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault_inject: silence a warning
has been removed from the -mm tree.  Its filename was
     fault_inject-silence-a-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault_inject: silence a warning
From: Stephen Rothwell <sfr@canb.auug.org.au>

lib/fault-inject.c:168: warning: 'debugfs_create_ul_MAX_STACK_TRACE_DEPTH' defined but not used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN lib/fault-inject.c~fault_inject-silence-a-warning lib/fault-inject.c
--- a/lib/fault-inject.c~fault_inject-silence-a-warning
+++ a/lib/fault-inject.c
@@ -139,12 +139,14 @@ static void debugfs_ul_set(void *data, u
 	*(unsigned long *)data = val;
 }
 
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
 {
 	*(unsigned long *)data =
 		val < MAX_STACK_TRACE_DEPTH ?
 		val : MAX_STACK_TRACE_DEPTH;
 }
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static u64 debugfs_ul_get(void *data)
 {
@@ -159,6 +161,7 @@ static struct dentry *debugfs_create_ul(
 	return debugfs_create_file(name, mode, parent, value, &fops_ul);
 }
 
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 DEFINE_SIMPLE_ATTRIBUTE(fops_ul_MAX_STACK_TRACE_DEPTH, debugfs_ul_get,
 			debugfs_ul_set_MAX_STACK_TRACE_DEPTH, "%llu\n");
 
@@ -169,6 +172,7 @@ static struct dentry *debugfs_create_ul_
 	return debugfs_create_file(name, mode, parent, value,
 				   &fops_ul_MAX_STACK_TRACE_DEPTH);
 }
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static void debugfs_atomic_t_set(void *data, u64 val)
 {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
git-alsa.patch
stradis-and-zoran-depend-on-virt_to_bus.patch
clean-up-duplicate-includes-in-drivers-block.patch

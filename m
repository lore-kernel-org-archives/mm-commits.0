From: akpm@linux-foundation.org
Subject: + fault_inject-silence-a-warning.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:29:41 -0700
Message-ID: <200707232129.l6NLTfl4012772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbXGWVaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, akinobu.mita@gmail.com


The patch titled
     fault_inject: silence a warning
has been added to the -mm tree.  Its filename is
     fault_inject-silence-a-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fault_inject-silence-a-warning.patch
stradis-and-zoran-depend-on-virt_to_bus.patch

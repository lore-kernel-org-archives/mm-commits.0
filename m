Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E7B2F5B
	for <mm-commits@vger.kernel.org>; Sat, 25 Oct 2025 23:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761436658; cv=none; b=koFU2BTI2VHlHcV5fD2EybR16Ksm2xqk7ncqJYIhU/JbrYlOPn0i/05oNCPofOMlswZI9kM5RpmFi5q3Ch+dnZJU41+l5peu7YYa/F4hLGGHrvre/id/ZwfUPKfLlR4KqPYR5r0o0ogTlmG3d0aYBtCFOjMSSH3I8TG8MHnMhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761436658; c=relaxed/simple;
	bh=7Op8zupV9e8X16q5wjhIEfkp1vG5oOTFdSXIR6rZ0tM=;
	h=Date:To:From:Subject:Message-Id; b=P6z5Rxg18T27De1wLAfhFEga+/iRiHtQfckoUIX0lmSeDLAjDSGWC4v6OIbrUF8ssFIeDBJfeVKoyOfgtqLZelOOfSCBv19E33Qq4udg3Y3SD6moYpg/ZEzly1EomzwnqrPW+/M28arZnWisugu1a2usEmuZiGjFB4t5s7+AZFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSRyPMNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSRyPMNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F90C4CEF5;
	Sat, 25 Oct 2025 23:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761436658;
	bh=7Op8zupV9e8X16q5wjhIEfkp1vG5oOTFdSXIR6rZ0tM=;
	h=Date:To:From:Subject:From;
	b=tSRyPMNxM/PECyYRL2nkIFdykZXb372ivqKaBmuxRXVL6q525gcVFJtoiNpLS+SwG
	 m2r05J9rtAY2mWe21DG8l4fgkbi7UhnhlFoBZ/gAhENNPNQkqrYLTuaFneGPuFYN+C
	 dlPid4m3PNzzp1oti58L+DpWLFI5cAoLTp2AQ9gM=
Date: Sat, 25 Oct 2025 16:57:37 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,yebin10@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dynamic_debug-add-support-for-print-stack.patch added to mm-nonmm-unstable branch
Message-Id: <20251025235738.08F90C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dynamic_debug: add support for print stack
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dynamic_debug-add-support-for-print-stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dynamic_debug-add-support-for-print-stack.patch

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
From: Ye Bin <yebin10@huawei.com>
Subject: dynamic_debug: add support for print stack
Date: Sat, 25 Oct 2025 16:00:03 +0800

In practical problem diagnosis, especially during the boot phase, it is
often desirable to know the call sequence.  However, currently, apart from
adding print statements and recompiling the kernel, there seems to be no
good alternative.  If dynamic_debug supported printing the call stack, it
would be very helpful for diagnosing issues.  This patch add support '+d'
for dump stack.

Link: https://lkml.kernel.org/r/20251025080003.312536-1-yebin@huaweicloud.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/dynamic-debug-howto.rst |    5 ++-
 include/linux/dynamic_debug.h                     |   17 +++++++++---
 lib/dynamic_debug.c                               |    1 
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-add-support-for-print-stack
+++ a/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -223,12 +223,13 @@ The flags are::
   f    Include the function name
   s    Include the source file name
   l    Include line number
+  d    Include call trace
 
 For ``print_hex_dump_debug()`` and ``print_hex_dump_bytes()``, only
 the ``p`` flag has meaning, other flags are ignored.
 
-Note the regexp ``^[-+=][fslmpt_]+$`` matches a flags specification.
-To clear all flags at once, use ``=_`` or ``-fslmpt``.
+Note the regexp ``^[-+=][fslmptd_]+$`` matches a flags specification.
+To clear all flags at once, use ``=_`` or ``-fslmptd``.
 
 
 Debug messages during Boot Process
--- a/include/linux/dynamic_debug.h~dynamic_debug-add-support-for-print-stack
+++ a/include/linux/dynamic_debug.h
@@ -38,11 +38,12 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
 #define _DPRINTK_FLAGS_INCL_SOURCENAME	(1<<5)
+#define _DPRINTK_FLAGS_INCL_STACK	(1<<6)
 
 #define _DPRINTK_FLAGS_INCL_ANY		\
 	(_DPRINTK_FLAGS_INCL_MODNAME | _DPRINTK_FLAGS_INCL_FUNCNAME |\
 	 _DPRINTK_FLAGS_INCL_LINENO  | _DPRINTK_FLAGS_INCL_TID |\
-	 _DPRINTK_FLAGS_INCL_SOURCENAME)
+	 _DPRINTK_FLAGS_INCL_SOURCENAME | _DPRINTK_FLAGS_INCL_STACK)
 
 #if defined DEBUG
 #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
@@ -160,6 +161,12 @@ void __dynamic_ibdev_dbg(struct _ddebug
 			 const struct ib_device *ibdev,
 			 const char *fmt, ...);
 
+#define __dynamic_dump_stack(desc)				\
+{								\
+	if (desc.flags & _DPRINTK_FLAGS_INCL_STACK)		\
+		dump_stack();					\
+}
+
 #define DEFINE_DYNAMIC_DEBUG_METADATA_CLS(name, cls, fmt)	\
 	static struct _ddebug  __aligned(8)			\
 	__section("__dyndbg") name = {				\
@@ -220,8 +227,10 @@ void __dynamic_ibdev_dbg(struct _ddebug
  */
 #define __dynamic_func_call_cls(id, cls, fmt, func, ...) do {	\
 	DEFINE_DYNAMIC_DEBUG_METADATA_CLS(id, cls, fmt);	\
-	if (DYNAMIC_DEBUG_BRANCH(id))				\
+	if (DYNAMIC_DEBUG_BRANCH(id)) {				\
 		func(&id, ##__VA_ARGS__);			\
+		__dynamic_dump_stack(id);			\
+	}							\
 } while (0)
 #define __dynamic_func_call(id, fmt, func, ...)				\
 	__dynamic_func_call_cls(id, _DPRINTK_CLASS_DFLT, fmt,		\
@@ -229,8 +238,10 @@ void __dynamic_ibdev_dbg(struct _ddebug
 
 #define __dynamic_func_call_cls_no_desc(id, cls, fmt, func, ...) do {	\
 	DEFINE_DYNAMIC_DEBUG_METADATA_CLS(id, cls, fmt);		\
-	if (DYNAMIC_DEBUG_BRANCH(id))					\
+	if (DYNAMIC_DEBUG_BRANCH(id)) {					\
 		func(__VA_ARGS__);					\
+		__dynamic_dump_stack(id);				\
+	}								\
 } while (0)
 #define __dynamic_func_call_no_desc(id, fmt, func, ...)			\
 	__dynamic_func_call_cls_no_desc(id, _DPRINTK_CLASS_DFLT,	\
--- a/lib/dynamic_debug.c~dynamic_debug-add-support-for-print-stack
+++ a/lib/dynamic_debug.c
@@ -95,6 +95,7 @@ static const struct { unsigned flag:8; c
 	{ _DPRINTK_FLAGS_INCL_SOURCENAME, 's' },
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+	{ _DPRINTK_FLAGS_INCL_STACK, 'd' },
 	{ _DPRINTK_FLAGS_NONE, '_' },
 };
 
_

Patches currently in -mm which might be from yebin10@huawei.com are

dynamic_debug-add-support-for-print-stack.patch


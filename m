Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C46B21D3F0
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908607; cv=none; b=Zw1j43gIThKFgu4F+1UJiPt7fLdhby0jNs6uFmXQHdMDDlushT1+5JJeXy5b7ICNSUivv1M9laC5j/c6x+zEPtWsPQswL+U/wSLMBRHBQoIkLkhZAxtQsKpi4OvT1B83LnwdWkL579jofn1QeSIh/Fvz4GphTtM2Y/UvbryC9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908607; c=relaxed/simple;
	bh=esVRvZKt0iWeRrUJWcsT3PcsedsX3YbhSBfIt1nz2Bg=;
	h=Date:To:From:Subject:Message-Id; b=fusZ4/F84To6Dt++dke0rfxjpYbMJ3cFFLyIn10b/LkO7hqo8WxMwsWbWa7Ud5E8JWET3mSSnZx0JRaq2fe8AASlDExKO+T+RUe9Bd8VADxM8+DC2tTKHBf240yHEykZk+ElAQL57ybqTY0MYXHaiKXGAo8+w8VJC4zJnQGdhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rH1DvAY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rH1DvAY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1AC113D0;
	Wed, 12 Nov 2025 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908606;
	bh=esVRvZKt0iWeRrUJWcsT3PcsedsX3YbhSBfIt1nz2Bg=;
	h=Date:To:From:Subject:From;
	b=rH1DvAY208CX3+hAhfvo5r2jO+mh44F7umhqgwJ+hscIKujkIWxEaEzj0zz7W+/rx
	 C49RHkvEEksFyC94Gy9R+a/YhLjjp4MzRlIiz2voPow4Er8PIlpTN9cwa99ECzOX2K
	 Yk1ssdlFQwUMlnraesnPGLLdK/N8p4cpc9YIr2Qw=
Date: Tue, 11 Nov 2025 16:50:06 -0800
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,yebin10@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dynamic_debug-add-support-for-print-stack.patch removed from -mm tree
Message-Id: <20251112005006.C6A1AC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dynamic_debug: add support for print stack
has been removed from the -mm tree.  Its filename was
     dynamic_debug-add-support-for-print-stack.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



From: akpm@linux-foundation.org
Subject: - mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch removed from -mm tree
Date: Mon, 24 Sep 2007 20:10:41 -0700
Message-ID: <200709250310.l8P3AfaB030475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXIYDLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 23:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: move platform independent CFE code into arch/mips/cfe
has been removed from the -mm tree.  Its filename was
     mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch

This patch was dropped because of zillions of rejects against Ralf's tree

------------------------------------------------------
Subject: mips: move platform independent CFE code into arch/mips/cfe
From: Aurelien Jarno <aurelien@aurel32.net>

Move the platform independent part of the CFE code to arch/mips/cfe from
arch/mips/sibyte/cfe.  This way it can be used on other systems.

The patch looks big but it just because some files are moved, it is actually
almost trivial.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig                  |    3 
 arch/mips/Makefile                 |    1 
 arch/mips/cfe/Makefile             |    5 
 arch/mips/cfe/cfe_api.c            |  502 +++++++++++++++++++++++++++
 arch/mips/cfe/cfe_api_int.h        |  152 ++++++++
 arch/mips/sibyte/Kconfig           |    1 
 arch/mips/sibyte/cfe/Makefile      |    2 
 arch/mips/sibyte/cfe/cfe_api.c     |  502 ---------------------------
 arch/mips/sibyte/cfe/cfe_api.h     |  185 ---------
 arch/mips/sibyte/cfe/cfe_api_int.h |  152 --------
 arch/mips/sibyte/cfe/cfe_error.h   |   85 ----
 arch/mips/sibyte/cfe/console.c     |    4 
 arch/mips/sibyte/cfe/setup.c       |    4 
 arch/mips/sibyte/cfe/smp.c         |    4 
 include/asm-mips/cfe/cfe_api.h     |  185 +++++++++
 include/asm-mips/cfe/cfe_error.h   |   85 ++++
 16 files changed, 941 insertions(+), 931 deletions(-)

diff -puN arch/mips/Kconfig~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/Kconfig
@@ -688,6 +688,9 @@ config ARCH_MAY_HAVE_PC_FDC
 config BOOT_RAW
 	bool
 
+config CFE
+	bool
+
 config DMA_COHERENT
 	bool
 
diff -puN arch/mips/Makefile~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/Makefile
--- a/arch/mips/Makefile~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/Makefile
@@ -152,6 +152,7 @@ endif
 # Firmware support
 #
 libs-$(CONFIG_ARC)		+= arch/mips/arc/
+libs-$(CONFIG_CFE)		+= arch/mips/cfe/
 libs-$(CONFIG_SIBYTE_CFE)	+= arch/mips/sibyte/cfe/
 
 #
diff -puN /dev/null arch/mips/cfe/Makefile
--- /dev/null
+++ a/arch/mips/cfe/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Broadcom Common Firmware Environment support
+#
+
+lib-y += cfe_api.o
diff -puN /dev/null arch/mips/cfe/cfe_api.c
--- /dev/null
+++ a/arch/mips/cfe/cfe_api.c
@@ -0,0 +1,502 @@
+/*
+ * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*  *********************************************************************
+    *
+    *  Broadcom Common Firmware Environment (CFE)
+    *
+    *  Device Function stubs			File: cfe_api.c
+    *
+    *  This module contains device function stubs (small routines to
+    *  call the standard "iocb" interface entry point to CFE).
+    *  There should be one routine here per iocb function call.
+    *
+    *  Authors:  Mitch Lichtenberg, Chris Demetriou
+    *
+    ********************************************************************* */
+
+#include <asm/cfe/cfe_api.h>
+#include "cfe_api_int.h"
+
+/* Cast from a native pointer to a cfe_xptr_t and back.	 */
+#define XPTR_FROM_NATIVE(n)	((cfe_xptr_t) (intptr_t) (n))
+#define NATIVE_FROM_XPTR(x)	((void *) (intptr_t) (x))
+
+#ifdef CFE_API_IMPL_NAMESPACE
+#define cfe_iocb_dispatch(a)		__cfe_iocb_dispatch(a)
+#endif
+int cfe_iocb_dispatch(cfe_xiocb_t * xiocb);
+
+#if defined(CFE_API_common) || defined(CFE_API_ALL)
+/*
+ * Declare the dispatch function with args of "intptr_t".
+ * This makes sure whatever model we're compiling in
+ * puts the pointers in a single register.  For example,
+ * combining -mlong64 and -mips1 or -mips2 would lead to
+ * trouble, since the handle and IOCB pointer will be
+ * passed in two registers each, and CFE expects one.
+ */
+
+static int (*cfe_dispfunc) (intptr_t handle, intptr_t xiocb) = 0;
+static cfe_xuint_t cfe_handle = 0;
+
+int cfe_init(cfe_xuint_t handle, cfe_xuint_t ept)
+{
+	cfe_dispfunc = NATIVE_FROM_XPTR(ept);
+	cfe_handle = handle;
+	return 0;
+}
+
+int cfe_iocb_dispatch(cfe_xiocb_t * xiocb)
+{
+	if (!cfe_dispfunc)
+		return -1;
+	return (*cfe_dispfunc) ((intptr_t) cfe_handle, (intptr_t) xiocb);
+}
+#endif				/* CFE_API_common || CFE_API_ALL */
+
+#if defined(CFE_API_close) || defined(CFE_API_ALL)
+int cfe_close(int handle)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_CLOSE;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = handle;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = 0;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+
+}
+#endif				/* CFE_API_close || CFE_API_ALL */
+
+#if defined(CFE_API_cpu_start) || defined(CFE_API_ALL)
+int cfe_cpu_start(int cpu, void (*fn) (void), long sp, long gp, long a1)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_CPUCTL;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_cpuctl_t);
+	xiocb.plist.xiocb_cpuctl.cpu_number = cpu;
+	xiocb.plist.xiocb_cpuctl.cpu_command = CFE_CPU_CMD_START;
+	xiocb.plist.xiocb_cpuctl.gp_val = gp;
+	xiocb.plist.xiocb_cpuctl.sp_val = sp;
+	xiocb.plist.xiocb_cpuctl.a1_val = a1;
+	xiocb.plist.xiocb_cpuctl.start_addr = (long) fn;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_cpu_start || CFE_API_ALL */
+
+#if defined(CFE_API_cpu_stop) || defined(CFE_API_ALL)
+int cfe_cpu_stop(int cpu)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_CPUCTL;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_cpuctl_t);
+	xiocb.plist.xiocb_cpuctl.cpu_number = cpu;
+	xiocb.plist.xiocb_cpuctl.cpu_command = CFE_CPU_CMD_STOP;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_cpu_stop || CFE_API_ALL */
+
+#if defined(CFE_API_enumenv) || defined(CFE_API_ALL)
+int cfe_enumenv(int idx, char *name, int namelen, char *val, int vallen)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_ENV_SET;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
+	xiocb.plist.xiocb_envbuf.enum_idx = idx;
+	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
+	xiocb.plist.xiocb_envbuf.name_length = namelen;
+	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(val);
+	xiocb.plist.xiocb_envbuf.val_length = vallen;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_enumenv || CFE_API_ALL */
+
+#if defined(CFE_API_enummem) || defined(CFE_API_ALL)
+int
+cfe_enummem(int idx, int flags, cfe_xuint_t * start, cfe_xuint_t * length,
+	    cfe_xuint_t * type)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_MEMENUM;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = flags;
+	xiocb.xiocb_psize = sizeof(xiocb_meminfo_t);
+	xiocb.plist.xiocb_meminfo.mi_idx = idx;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+
+	*start = xiocb.plist.xiocb_meminfo.mi_addr;
+	*length = xiocb.plist.xiocb_meminfo.mi_size;
+	*type = xiocb.plist.xiocb_meminfo.mi_type;
+
+	return 0;
+}
+#endif				/* CFE_API_enummem || CFE_API_ALL */
+
+#if defined(CFE_API_exit) || defined(CFE_API_ALL)
+int cfe_exit(int warm, int status)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_RESTART;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = warm ? CFE_FLG_WARMSTART : 0;
+	xiocb.xiocb_psize = sizeof(xiocb_exitstat_t);
+	xiocb.plist.xiocb_exitstat.status = status;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_exit || CFE_API_ALL */
+
+#if defined(CFE_API_flushcache) || defined(CFE_API_ALL)
+int cfe_flushcache(int flg)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_FLUSHCACHE;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = flg;
+	xiocb.xiocb_psize = 0;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_flushcache || CFE_API_ALL */
+
+#if defined(CFE_API_getdevinfo) || defined(CFE_API_ALL)
+int cfe_getdevinfo(char *name)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_GETINFO;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
+	xiocb.plist.xiocb_buffer.buf_offset = 0;
+	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(name);
+	xiocb.plist.xiocb_buffer.buf_length = cfe_strlen(name);
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.plist.xiocb_buffer.buf_devflags;
+}
+#endif				/* CFE_API_getdevinfo || CFE_API_ALL */
+
+#if defined(CFE_API_getenv) || defined(CFE_API_ALL)
+int cfe_getenv(char *name, char *dest, int destlen)
+{
+	cfe_xiocb_t xiocb;
+
+	*dest = 0;
+
+	xiocb.xiocb_fcode = CFE_CMD_ENV_GET;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
+	xiocb.plist.xiocb_envbuf.enum_idx = 0;
+	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
+	xiocb.plist.xiocb_envbuf.name_length = cfe_strlen(name);
+	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(dest);
+	xiocb.plist.xiocb_envbuf.val_length = destlen;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_getenv || CFE_API_ALL */
+
+#if defined(CFE_API_getfwinfo) || defined(CFE_API_ALL)
+int cfe_getfwinfo(cfe_fwinfo_t * info)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_GETINFO;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_fwinfo_t);
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+
+	info->fwi_version = xiocb.plist.xiocb_fwinfo.fwi_version;
+	info->fwi_totalmem = xiocb.plist.xiocb_fwinfo.fwi_totalmem;
+	info->fwi_flags = xiocb.plist.xiocb_fwinfo.fwi_flags;
+	info->fwi_boardid = xiocb.plist.xiocb_fwinfo.fwi_boardid;
+	info->fwi_bootarea_va = xiocb.plist.xiocb_fwinfo.fwi_bootarea_va;
+	info->fwi_bootarea_pa = xiocb.plist.xiocb_fwinfo.fwi_bootarea_pa;
+	info->fwi_bootarea_size =
+	    xiocb.plist.xiocb_fwinfo.fwi_bootarea_size;
+#if 0
+	info->fwi_reserved1 = xiocb.plist.xiocb_fwinfo.fwi_reserved1;
+	info->fwi_reserved2 = xiocb.plist.xiocb_fwinfo.fwi_reserved2;
+	info->fwi_reserved3 = xiocb.plist.xiocb_fwinfo.fwi_reserved3;
+#endif
+
+	return 0;
+}
+#endif				/* CFE_API_getfwinfo || CFE_API_ALL */
+
+#if defined(CFE_API_getstdhandle) || defined(CFE_API_ALL)
+int cfe_getstdhandle(int flg)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_GETHANDLE;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = flg;
+	xiocb.xiocb_psize = 0;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.xiocb_handle;
+}
+#endif				/* CFE_API_getstdhandle || CFE_API_ALL */
+
+#if defined(CFE_API_getticks) || defined(CFE_API_ALL)
+int64_t
+#ifdef CFE_API_IMPL_NAMESPACE
+__cfe_getticks(void)
+#else
+cfe_getticks(void)
+#endif
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_FW_GETTIME;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_time_t);
+	xiocb.plist.xiocb_time.ticks = 0;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.plist.xiocb_time.ticks;
+
+}
+#endif				/* CFE_API_getticks || CFE_API_ALL */
+
+#if defined(CFE_API_inpstat) || defined(CFE_API_ALL)
+int cfe_inpstat(int handle)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_INPSTAT;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = handle;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_inpstat_t);
+	xiocb.plist.xiocb_inpstat.inp_status = 0;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.plist.xiocb_inpstat.inp_status;
+}
+#endif				/* CFE_API_inpstat || CFE_API_ALL */
+
+#if defined(CFE_API_ioctl) || defined(CFE_API_ALL)
+int
+cfe_ioctl(int handle, unsigned int ioctlnum, unsigned char *buffer,
+	  int length, int *retlen, cfe_xuint_t offset)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_IOCTL;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = handle;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
+	xiocb.plist.xiocb_buffer.buf_offset = offset;
+	xiocb.plist.xiocb_buffer.buf_ioctlcmd = ioctlnum;
+	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
+	xiocb.plist.xiocb_buffer.buf_length = length;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (retlen)
+		*retlen = xiocb.plist.xiocb_buffer.buf_retlen;
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_ioctl || CFE_API_ALL */
+
+#if defined(CFE_API_open) || defined(CFE_API_ALL)
+int cfe_open(char *name)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_OPEN;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
+	xiocb.plist.xiocb_buffer.buf_offset = 0;
+	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(name);
+	xiocb.plist.xiocb_buffer.buf_length = cfe_strlen(name);
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.xiocb_handle;
+}
+#endif				/* CFE_API_open || CFE_API_ALL */
+
+#if defined(CFE_API_read) || defined(CFE_API_ALL)
+int cfe_read(int handle, unsigned char *buffer, int length)
+{
+	return cfe_readblk(handle, 0, buffer, length);
+}
+#endif				/* CFE_API_read || CFE_API_ALL */
+
+#if defined(CFE_API_readblk) || defined(CFE_API_ALL)
+int
+cfe_readblk(int handle, cfe_xint_t offset, unsigned char *buffer,
+	    int length)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_READ;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = handle;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
+	xiocb.plist.xiocb_buffer.buf_offset = offset;
+	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
+	xiocb.plist.xiocb_buffer.buf_length = length;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.plist.xiocb_buffer.buf_retlen;
+}
+#endif				/* CFE_API_readblk || CFE_API_ALL */
+
+#if defined(CFE_API_setenv) || defined(CFE_API_ALL)
+int cfe_setenv(char *name, char *val)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_ENV_SET;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = 0;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
+	xiocb.plist.xiocb_envbuf.enum_idx = 0;
+	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
+	xiocb.plist.xiocb_envbuf.name_length = cfe_strlen(name);
+	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(val);
+	xiocb.plist.xiocb_envbuf.val_length = cfe_strlen(val);
+
+	cfe_iocb_dispatch(&xiocb);
+
+	return xiocb.xiocb_status;
+}
+#endif				/* CFE_API_setenv || CFE_API_ALL */
+
+#if (defined(CFE_API_strlen) || defined(CFE_API_ALL)) \
+    && !defined(CFE_API_STRLEN_CUSTOM)
+int cfe_strlen(char *name)
+{
+	int count = 0;
+
+	while (*name++)
+		count++;
+
+	return count;
+}
+#endif				/* CFE_API_strlen || CFE_API_ALL */
+
+#if defined(CFE_API_write) || defined(CFE_API_ALL)
+int cfe_write(int handle, unsigned char *buffer, int length)
+{
+	return cfe_writeblk(handle, 0, buffer, length);
+}
+#endif				/* CFE_API_write || CFE_API_ALL */
+
+#if defined(CFE_API_writeblk) || defined(CFE_API_ALL)
+int
+cfe_writeblk(int handle, cfe_xint_t offset, unsigned char *buffer,
+	     int length)
+{
+	cfe_xiocb_t xiocb;
+
+	xiocb.xiocb_fcode = CFE_CMD_DEV_WRITE;
+	xiocb.xiocb_status = 0;
+	xiocb.xiocb_handle = handle;
+	xiocb.xiocb_flags = 0;
+	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
+	xiocb.plist.xiocb_buffer.buf_offset = offset;
+	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
+	xiocb.plist.xiocb_buffer.buf_length = length;
+
+	cfe_iocb_dispatch(&xiocb);
+
+	if (xiocb.xiocb_status < 0)
+		return xiocb.xiocb_status;
+	return xiocb.plist.xiocb_buffer.buf_retlen;
+}
+#endif				/* CFE_API_writeblk || CFE_API_ALL */
diff -puN /dev/null arch/mips/cfe/cfe_api_int.h
--- /dev/null
+++ a/arch/mips/cfe/cfe_api_int.h
@@ -0,0 +1,152 @@
+/*
+ * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*  *********************************************************************
+    *
+    *  Broadcom Common Firmware Environment (CFE)
+    *
+    *  Device function prototypes		File: cfe_api_int.h
+    *
+    *  This header defines all internal types and macros for the
+    *  library.  This is stuff that's not exported to an app
+    *  using the library.
+    *
+    *  Authors:  Mitch Lichtenberg, Chris Demetriou
+    *
+    ********************************************************************* */
+
+#ifndef CFE_API_INT_H
+#define CFE_API_INT_H
+
+/*  *********************************************************************
+    *  Constants
+    ********************************************************************* */
+
+#define CFE_CMD_FW_GETINFO	0
+#define CFE_CMD_FW_RESTART	1
+#define CFE_CMD_FW_BOOT		2
+#define CFE_CMD_FW_CPUCTL	3
+#define CFE_CMD_FW_GETTIME      4
+#define CFE_CMD_FW_MEMENUM	5
+#define CFE_CMD_FW_FLUSHCACHE	6
+
+#define CFE_CMD_DEV_GETHANDLE	9
+#define CFE_CMD_DEV_ENUM	10
+#define CFE_CMD_DEV_OPEN	11
+#define CFE_CMD_DEV_INPSTAT	12
+#define CFE_CMD_DEV_READ	13
+#define CFE_CMD_DEV_WRITE	14
+#define CFE_CMD_DEV_IOCTL	15
+#define CFE_CMD_DEV_CLOSE	16
+#define CFE_CMD_DEV_GETINFO	17
+
+#define CFE_CMD_ENV_ENUM	20
+#define CFE_CMD_ENV_GET		22
+#define CFE_CMD_ENV_SET		23
+#define CFE_CMD_ENV_DEL		24
+
+#define CFE_CMD_MAX		32
+
+#define CFE_CMD_VENDOR_USE	0x8000	/* codes above this are for customer use */
+
+/*  *********************************************************************
+    *  Structures
+    ********************************************************************* */
+
+typedef uint64_t cfe_xuint_t;
+typedef int64_t cfe_xint_t;
+typedef int64_t cfe_xptr_t;
+
+typedef struct xiocb_buffer_s {
+	cfe_xuint_t buf_offset;		/* offset on device (bytes) */
+	cfe_xptr_t  buf_ptr;		/* pointer to a buffer */
+	cfe_xuint_t buf_length;		/* length of this buffer */
+	cfe_xuint_t buf_retlen;		/* returned length (for read ops) */
+	cfe_xuint_t buf_ioctlcmd;	/* IOCTL command (used only for IOCTLs) */
+} xiocb_buffer_t;
+
+#define buf_devflags buf_ioctlcmd	/* returned device info flags */
+
+typedef struct xiocb_inpstat_s {
+	cfe_xuint_t inp_status;		/* 1 means input available */
+} xiocb_inpstat_t;
+
+typedef struct xiocb_envbuf_s {
+	cfe_xint_t enum_idx;		/* 0-based enumeration index */
+	cfe_xptr_t name_ptr;		/* name string buffer */
+	cfe_xint_t name_length;		/* size of name buffer */
+	cfe_xptr_t val_ptr;		/* value string buffer */
+	cfe_xint_t val_length;		/* size of value string buffer */
+} xiocb_envbuf_t;
+
+typedef struct xiocb_cpuctl_s {
+	cfe_xuint_t cpu_number;		/* cpu number to control */
+	cfe_xuint_t cpu_command;	/* command to issue to CPU */
+	cfe_xuint_t start_addr;		/* CPU start address */
+	cfe_xuint_t gp_val;		/* starting GP value */
+	cfe_xuint_t sp_val;		/* starting SP value */
+	cfe_xuint_t a1_val;		/* starting A1 value */
+} xiocb_cpuctl_t;
+
+typedef struct xiocb_time_s {
+	cfe_xint_t ticks;		/* current time in ticks */
+} xiocb_time_t;
+
+typedef struct xiocb_exitstat_s {
+	cfe_xint_t status;
+} xiocb_exitstat_t;
+
+typedef struct xiocb_meminfo_s {
+	cfe_xint_t mi_idx;		/* 0-based enumeration index */
+	cfe_xint_t mi_type;		/* type of memory block */
+	cfe_xuint_t mi_addr;		/* physical start address */
+	cfe_xuint_t mi_size;		/* block size */
+} xiocb_meminfo_t;
+
+typedef struct xiocb_fwinfo_s {
+	cfe_xint_t fwi_version;		/* major, minor, eco version */
+	cfe_xint_t fwi_totalmem;	/* total installed mem */
+	cfe_xint_t fwi_flags;		/* various flags */
+	cfe_xint_t fwi_boardid;		/* board ID */
+	cfe_xint_t fwi_bootarea_va;	/* VA of boot area */
+	cfe_xint_t fwi_bootarea_pa;	/* PA of boot area */
+	cfe_xint_t fwi_bootarea_size;	/* size of boot area */
+	cfe_xint_t fwi_reserved1;
+	cfe_xint_t fwi_reserved2;
+	cfe_xint_t fwi_reserved3;
+} xiocb_fwinfo_t;
+
+typedef struct cfe_xiocb_s {
+	cfe_xuint_t xiocb_fcode;	/* IOCB function code */
+	cfe_xint_t xiocb_status;	/* return status */
+	cfe_xint_t xiocb_handle;	/* file/device handle */
+	cfe_xuint_t xiocb_flags;	/* flags for this IOCB */
+	cfe_xuint_t xiocb_psize;	/* size of parameter list */
+	union {
+		xiocb_buffer_t xiocb_buffer;	/* buffer parameters */
+		xiocb_inpstat_t xiocb_inpstat;	/* input status parameters */
+		xiocb_envbuf_t xiocb_envbuf;	/* environment function parameters */
+		xiocb_cpuctl_t xiocb_cpuctl;	/* CPU control parameters */
+		xiocb_time_t xiocb_time;	/* timer parameters */
+		xiocb_meminfo_t xiocb_meminfo;	/* memory arena info parameters */
+		xiocb_fwinfo_t xiocb_fwinfo;	/* firmware information */
+		xiocb_exitstat_t xiocb_exitstat;	/* Exit Status */
+	} plist;
+} cfe_xiocb_t;
+
+#endif				/* CFE_API_INT_H */
diff -puN arch/mips/sibyte/Kconfig~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/sibyte/Kconfig
--- a/arch/mips/sibyte/Kconfig~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/sibyte/Kconfig
@@ -124,6 +124,7 @@ config SB1_CERR_STALL
 config SIBYTE_CFE
 	bool "Booting from CFE"
 	depends on SIBYTE_SB1xxx_SOC
+	select CFE
 	select SYS_HAS_EARLY_PRINTK
 	help
 	  Make use of the CFE API for enumerating available memory,
diff -puN arch/mips/sibyte/cfe/Makefile~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/sibyte/cfe/Makefile
--- a/arch/mips/sibyte/cfe/Makefile~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/sibyte/cfe/Makefile
@@ -1,3 +1,3 @@
-lib-y					= cfe_api.o setup.o
+lib-y					= setup.o
 lib-$(CONFIG_SMP)			+= smp.o
 lib-$(CONFIG_SIBYTE_CFE_CONSOLE)	+= console.o
diff -puN arch/mips/sibyte/cfe/cfe_api.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe /dev/null
--- a/arch/mips/sibyte/cfe/cfe_api.c
+++ /dev/null
@@ -1,502 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- */
-
-/*  *********************************************************************
-    *
-    *  Broadcom Common Firmware Environment (CFE)
-    *
-    *  Device Function stubs			File: cfe_api.c
-    *
-    *  This module contains device function stubs (small routines to
-    *  call the standard "iocb" interface entry point to CFE).
-    *  There should be one routine here per iocb function call.
-    *
-    *  Authors:  Mitch Lichtenberg, Chris Demetriou
-    *
-    ********************************************************************* */
-
-#include "cfe_api.h"
-#include "cfe_api_int.h"
-
-/* Cast from a native pointer to a cfe_xptr_t and back.	 */
-#define XPTR_FROM_NATIVE(n)	((cfe_xptr_t) (intptr_t) (n))
-#define NATIVE_FROM_XPTR(x)	((void *) (intptr_t) (x))
-
-#ifdef CFE_API_IMPL_NAMESPACE
-#define cfe_iocb_dispatch(a)		__cfe_iocb_dispatch(a)
-#endif
-int cfe_iocb_dispatch(cfe_xiocb_t * xiocb);
-
-#if defined(CFE_API_common) || defined(CFE_API_ALL)
-/*
- * Declare the dispatch function with args of "intptr_t".
- * This makes sure whatever model we're compiling in
- * puts the pointers in a single register.  For example,
- * combining -mlong64 and -mips1 or -mips2 would lead to
- * trouble, since the handle and IOCB pointer will be
- * passed in two registers each, and CFE expects one.
- */
-
-static int (*cfe_dispfunc) (intptr_t handle, intptr_t xiocb) = 0;
-static cfe_xuint_t cfe_handle = 0;
-
-int cfe_init(cfe_xuint_t handle, cfe_xuint_t ept)
-{
-	cfe_dispfunc = NATIVE_FROM_XPTR(ept);
-	cfe_handle = handle;
-	return 0;
-}
-
-int cfe_iocb_dispatch(cfe_xiocb_t * xiocb)
-{
-	if (!cfe_dispfunc)
-		return -1;
-	return (*cfe_dispfunc) ((intptr_t) cfe_handle, (intptr_t) xiocb);
-}
-#endif				/* CFE_API_common || CFE_API_ALL */
-
-#if defined(CFE_API_close) || defined(CFE_API_ALL)
-int cfe_close(int handle)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_CLOSE;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = handle;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = 0;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-
-}
-#endif				/* CFE_API_close || CFE_API_ALL */
-
-#if defined(CFE_API_cpu_start) || defined(CFE_API_ALL)
-int cfe_cpu_start(int cpu, void (*fn) (void), long sp, long gp, long a1)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_CPUCTL;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_cpuctl_t);
-	xiocb.plist.xiocb_cpuctl.cpu_number = cpu;
-	xiocb.plist.xiocb_cpuctl.cpu_command = CFE_CPU_CMD_START;
-	xiocb.plist.xiocb_cpuctl.gp_val = gp;
-	xiocb.plist.xiocb_cpuctl.sp_val = sp;
-	xiocb.plist.xiocb_cpuctl.a1_val = a1;
-	xiocb.plist.xiocb_cpuctl.start_addr = (long) fn;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_cpu_start || CFE_API_ALL */
-
-#if defined(CFE_API_cpu_stop) || defined(CFE_API_ALL)
-int cfe_cpu_stop(int cpu)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_CPUCTL;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_cpuctl_t);
-	xiocb.plist.xiocb_cpuctl.cpu_number = cpu;
-	xiocb.plist.xiocb_cpuctl.cpu_command = CFE_CPU_CMD_STOP;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_cpu_stop || CFE_API_ALL */
-
-#if defined(CFE_API_enumenv) || defined(CFE_API_ALL)
-int cfe_enumenv(int idx, char *name, int namelen, char *val, int vallen)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_ENV_SET;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
-	xiocb.plist.xiocb_envbuf.enum_idx = idx;
-	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
-	xiocb.plist.xiocb_envbuf.name_length = namelen;
-	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(val);
-	xiocb.plist.xiocb_envbuf.val_length = vallen;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_enumenv || CFE_API_ALL */
-
-#if defined(CFE_API_enummem) || defined(CFE_API_ALL)
-int
-cfe_enummem(int idx, int flags, cfe_xuint_t * start, cfe_xuint_t * length,
-	    cfe_xuint_t * type)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_MEMENUM;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = flags;
-	xiocb.xiocb_psize = sizeof(xiocb_meminfo_t);
-	xiocb.plist.xiocb_meminfo.mi_idx = idx;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-
-	*start = xiocb.plist.xiocb_meminfo.mi_addr;
-	*length = xiocb.plist.xiocb_meminfo.mi_size;
-	*type = xiocb.plist.xiocb_meminfo.mi_type;
-
-	return 0;
-}
-#endif				/* CFE_API_enummem || CFE_API_ALL */
-
-#if defined(CFE_API_exit) || defined(CFE_API_ALL)
-int cfe_exit(int warm, int status)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_RESTART;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = warm ? CFE_FLG_WARMSTART : 0;
-	xiocb.xiocb_psize = sizeof(xiocb_exitstat_t);
-	xiocb.plist.xiocb_exitstat.status = status;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_exit || CFE_API_ALL */
-
-#if defined(CFE_API_flushcache) || defined(CFE_API_ALL)
-int cfe_flushcache(int flg)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_FLUSHCACHE;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = flg;
-	xiocb.xiocb_psize = 0;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_flushcache || CFE_API_ALL */
-
-#if defined(CFE_API_getdevinfo) || defined(CFE_API_ALL)
-int cfe_getdevinfo(char *name)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_GETINFO;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
-	xiocb.plist.xiocb_buffer.buf_offset = 0;
-	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(name);
-	xiocb.plist.xiocb_buffer.buf_length = cfe_strlen(name);
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.plist.xiocb_buffer.buf_devflags;
-}
-#endif				/* CFE_API_getdevinfo || CFE_API_ALL */
-
-#if defined(CFE_API_getenv) || defined(CFE_API_ALL)
-int cfe_getenv(char *name, char *dest, int destlen)
-{
-	cfe_xiocb_t xiocb;
-
-	*dest = 0;
-
-	xiocb.xiocb_fcode = CFE_CMD_ENV_GET;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
-	xiocb.plist.xiocb_envbuf.enum_idx = 0;
-	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
-	xiocb.plist.xiocb_envbuf.name_length = cfe_strlen(name);
-	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(dest);
-	xiocb.plist.xiocb_envbuf.val_length = destlen;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_getenv || CFE_API_ALL */
-
-#if defined(CFE_API_getfwinfo) || defined(CFE_API_ALL)
-int cfe_getfwinfo(cfe_fwinfo_t * info)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_GETINFO;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_fwinfo_t);
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-
-	info->fwi_version = xiocb.plist.xiocb_fwinfo.fwi_version;
-	info->fwi_totalmem = xiocb.plist.xiocb_fwinfo.fwi_totalmem;
-	info->fwi_flags = xiocb.plist.xiocb_fwinfo.fwi_flags;
-	info->fwi_boardid = xiocb.plist.xiocb_fwinfo.fwi_boardid;
-	info->fwi_bootarea_va = xiocb.plist.xiocb_fwinfo.fwi_bootarea_va;
-	info->fwi_bootarea_pa = xiocb.plist.xiocb_fwinfo.fwi_bootarea_pa;
-	info->fwi_bootarea_size =
-	    xiocb.plist.xiocb_fwinfo.fwi_bootarea_size;
-#if 0
-	info->fwi_reserved1 = xiocb.plist.xiocb_fwinfo.fwi_reserved1;
-	info->fwi_reserved2 = xiocb.plist.xiocb_fwinfo.fwi_reserved2;
-	info->fwi_reserved3 = xiocb.plist.xiocb_fwinfo.fwi_reserved3;
-#endif
-
-	return 0;
-}
-#endif				/* CFE_API_getfwinfo || CFE_API_ALL */
-
-#if defined(CFE_API_getstdhandle) || defined(CFE_API_ALL)
-int cfe_getstdhandle(int flg)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_GETHANDLE;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = flg;
-	xiocb.xiocb_psize = 0;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.xiocb_handle;
-}
-#endif				/* CFE_API_getstdhandle || CFE_API_ALL */
-
-#if defined(CFE_API_getticks) || defined(CFE_API_ALL)
-int64_t
-#ifdef CFE_API_IMPL_NAMESPACE
-__cfe_getticks(void)
-#else
-cfe_getticks(void)
-#endif
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_FW_GETTIME;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_time_t);
-	xiocb.plist.xiocb_time.ticks = 0;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.plist.xiocb_time.ticks;
-
-}
-#endif				/* CFE_API_getticks || CFE_API_ALL */
-
-#if defined(CFE_API_inpstat) || defined(CFE_API_ALL)
-int cfe_inpstat(int handle)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_INPSTAT;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = handle;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_inpstat_t);
-	xiocb.plist.xiocb_inpstat.inp_status = 0;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.plist.xiocb_inpstat.inp_status;
-}
-#endif				/* CFE_API_inpstat || CFE_API_ALL */
-
-#if defined(CFE_API_ioctl) || defined(CFE_API_ALL)
-int
-cfe_ioctl(int handle, unsigned int ioctlnum, unsigned char *buffer,
-	  int length, int *retlen, cfe_xuint_t offset)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_IOCTL;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = handle;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
-	xiocb.plist.xiocb_buffer.buf_offset = offset;
-	xiocb.plist.xiocb_buffer.buf_ioctlcmd = ioctlnum;
-	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
-	xiocb.plist.xiocb_buffer.buf_length = length;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (retlen)
-		*retlen = xiocb.plist.xiocb_buffer.buf_retlen;
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_ioctl || CFE_API_ALL */
-
-#if defined(CFE_API_open) || defined(CFE_API_ALL)
-int cfe_open(char *name)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_OPEN;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
-	xiocb.plist.xiocb_buffer.buf_offset = 0;
-	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(name);
-	xiocb.plist.xiocb_buffer.buf_length = cfe_strlen(name);
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.xiocb_handle;
-}
-#endif				/* CFE_API_open || CFE_API_ALL */
-
-#if defined(CFE_API_read) || defined(CFE_API_ALL)
-int cfe_read(int handle, unsigned char *buffer, int length)
-{
-	return cfe_readblk(handle, 0, buffer, length);
-}
-#endif				/* CFE_API_read || CFE_API_ALL */
-
-#if defined(CFE_API_readblk) || defined(CFE_API_ALL)
-int
-cfe_readblk(int handle, cfe_xint_t offset, unsigned char *buffer,
-	    int length)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_READ;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = handle;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
-	xiocb.plist.xiocb_buffer.buf_offset = offset;
-	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
-	xiocb.plist.xiocb_buffer.buf_length = length;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.plist.xiocb_buffer.buf_retlen;
-}
-#endif				/* CFE_API_readblk || CFE_API_ALL */
-
-#if defined(CFE_API_setenv) || defined(CFE_API_ALL)
-int cfe_setenv(char *name, char *val)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_ENV_SET;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = 0;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_envbuf_t);
-	xiocb.plist.xiocb_envbuf.enum_idx = 0;
-	xiocb.plist.xiocb_envbuf.name_ptr = XPTR_FROM_NATIVE(name);
-	xiocb.plist.xiocb_envbuf.name_length = cfe_strlen(name);
-	xiocb.plist.xiocb_envbuf.val_ptr = XPTR_FROM_NATIVE(val);
-	xiocb.plist.xiocb_envbuf.val_length = cfe_strlen(val);
-
-	cfe_iocb_dispatch(&xiocb);
-
-	return xiocb.xiocb_status;
-}
-#endif				/* CFE_API_setenv || CFE_API_ALL */
-
-#if (defined(CFE_API_strlen) || defined(CFE_API_ALL)) \
-    && !defined(CFE_API_STRLEN_CUSTOM)
-int cfe_strlen(char *name)
-{
-	int count = 0;
-
-	while (*name++)
-		count++;
-
-	return count;
-}
-#endif				/* CFE_API_strlen || CFE_API_ALL */
-
-#if defined(CFE_API_write) || defined(CFE_API_ALL)
-int cfe_write(int handle, unsigned char *buffer, int length)
-{
-	return cfe_writeblk(handle, 0, buffer, length);
-}
-#endif				/* CFE_API_write || CFE_API_ALL */
-
-#if defined(CFE_API_writeblk) || defined(CFE_API_ALL)
-int
-cfe_writeblk(int handle, cfe_xint_t offset, unsigned char *buffer,
-	     int length)
-{
-	cfe_xiocb_t xiocb;
-
-	xiocb.xiocb_fcode = CFE_CMD_DEV_WRITE;
-	xiocb.xiocb_status = 0;
-	xiocb.xiocb_handle = handle;
-	xiocb.xiocb_flags = 0;
-	xiocb.xiocb_psize = sizeof(xiocb_buffer_t);
-	xiocb.plist.xiocb_buffer.buf_offset = offset;
-	xiocb.plist.xiocb_buffer.buf_ptr = XPTR_FROM_NATIVE(buffer);
-	xiocb.plist.xiocb_buffer.buf_length = length;
-
-	cfe_iocb_dispatch(&xiocb);
-
-	if (xiocb.xiocb_status < 0)
-		return xiocb.xiocb_status;
-	return xiocb.plist.xiocb_buffer.buf_retlen;
-}
-#endif				/* CFE_API_writeblk || CFE_API_ALL */
diff -puN arch/mips/sibyte/cfe/cfe_api.h~mips-move-platform-independent-cfe-code-into-arch-mips-cfe /dev/null
--- a/arch/mips/sibyte/cfe/cfe_api.h
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- */
-
-/*  *********************************************************************
-    *
-    *  Broadcom Common Firmware Environment (CFE)
-    *
-    *  Device function prototypes		File: cfe_api.h
-    *
-    *  This file contains declarations for doing callbacks to
-    *  cfe from an application.  It should be the only header
-    *  needed by the application to use this library
-    *
-    *  Authors:  Mitch Lichtenberg, Chris Demetriou
-    *
-    ********************************************************************* */
-
-#ifndef CFE_API_H
-#define CFE_API_H
-
-/*
- * Apply customizations here for different OSes.  These need to:
- *	* typedef uint64_t, int64_t, intptr_t, uintptr_t.
- *	* define cfe_strlen() if use of an existing function is desired.
- *	* define CFE_API_IMPL_NAMESPACE if API functions are to use
- *	  names in the implementation namespace.
- * Also, optionally, if the build environment does not do so automatically,
- * CFE_API_* can be defined here as desired.
- */
-/* Begin customization. */
-#include <linux/types.h>
-#include <linux/string.h>
-
-typedef long intptr_t;
-
-#define cfe_strlen strlen
-
-#define CFE_API_ALL
-#define CFE_API_STRLEN_CUSTOM
-/* End customization. */
-
-
-/*  *********************************************************************
-    *  Constants
-    ********************************************************************* */
-
-/* Seal indicating CFE's presence, passed to user program. */
-#define CFE_EPTSEAL 0x43464531
-
-#define CFE_MI_RESERVED	0	/* memory is reserved, do not use */
-#define CFE_MI_AVAILABLE 1	/* memory is available */
-
-#define CFE_FLG_WARMSTART     0x00000001
-#define CFE_FLG_FULL_ARENA    0x00000001
-#define CFE_FLG_ENV_PERMANENT 0x00000001
-
-#define CFE_CPU_CMD_START 1
-#define CFE_CPU_CMD_STOP 0
-
-#define CFE_STDHANDLE_CONSOLE	0
-
-#define CFE_DEV_NETWORK 	1
-#define CFE_DEV_DISK		2
-#define CFE_DEV_FLASH		3
-#define CFE_DEV_SERIAL		4
-#define CFE_DEV_CPU		5
-#define CFE_DEV_NVRAM		6
-#define CFE_DEV_CLOCK           7
-#define CFE_DEV_OTHER		8
-#define CFE_DEV_MASK		0x0F
-
-#define CFE_CACHE_FLUSH_D	1
-#define CFE_CACHE_INVAL_I	2
-#define CFE_CACHE_INVAL_D	4
-#define CFE_CACHE_INVAL_L2	8
-
-#define CFE_FWI_64BIT		0x00000001
-#define CFE_FWI_32BIT		0x00000002
-#define CFE_FWI_RELOC		0x00000004
-#define CFE_FWI_UNCACHED	0x00000008
-#define CFE_FWI_MULTICPU	0x00000010
-#define CFE_FWI_FUNCSIM		0x00000020
-#define CFE_FWI_RTLSIM		0x00000040
-
-typedef struct {
-	int64_t fwi_version;		/* major, minor, eco version */
-	int64_t fwi_totalmem;		/* total installed mem */
-	int64_t fwi_flags;		/* various flags */
-	int64_t fwi_boardid;		/* board ID */
-	int64_t fwi_bootarea_va;	/* VA of boot area */
-	int64_t fwi_bootarea_pa;	/* PA of boot area */
-	int64_t fwi_bootarea_size;	/* size of boot area */
-} cfe_fwinfo_t;
-
-
-/*
- * cfe_strlen is handled specially: If already defined, it has been
- * overridden in this environment with a standard strlen-like function.
- */
-#ifdef cfe_strlen
-# define CFE_API_STRLEN_CUSTOM
-#else
-# ifdef CFE_API_IMPL_NAMESPACE
-#  define cfe_strlen(a)			__cfe_strlen(a)
-# endif
-int cfe_strlen(char *name);
-#endif
-
-/*
- * Defines and prototypes for functions which take no arguments.
- */
-#ifdef CFE_API_IMPL_NAMESPACE
-int64_t __cfe_getticks(void);
-#define cfe_getticks()			__cfe_getticks()
-#else
-int64_t cfe_getticks(void);
-#endif
-
-/*
- * Defines and prototypes for the rest of the functions.
- */
-#ifdef CFE_API_IMPL_NAMESPACE
-#define cfe_close(a)			__cfe_close(a)
-#define cfe_cpu_start(a,b,c,d,e)	__cfe_cpu_start(a,b,c,d,e)
-#define cfe_cpu_stop(a)			__cfe_cpu_stop(a)
-#define cfe_enumenv(a,b,d,e,f)		__cfe_enumenv(a,b,d,e,f)
-#define cfe_enummem(a,b,c,d,e)		__cfe_enummem(a,b,c,d,e)
-#define cfe_exit(a,b)			__cfe_exit(a,b)
-#define cfe_flushcache(a)		__cfe_cacheflush(a)
-#define cfe_getdevinfo(a)		__cfe_getdevinfo(a)
-#define cfe_getenv(a,b,c)		__cfe_getenv(a,b,c)
-#define cfe_getfwinfo(a)		__cfe_getfwinfo(a)
-#define cfe_getstdhandle(a)		__cfe_getstdhandle(a)
-#define cfe_init(a,b)			__cfe_init(a,b)
-#define cfe_inpstat(a)			__cfe_inpstat(a)
-#define cfe_ioctl(a,b,c,d,e,f)		__cfe_ioctl(a,b,c,d,e,f)
-#define cfe_open(a)			__cfe_open(a)
-#define cfe_read(a,b,c)			__cfe_read(a,b,c)
-#define cfe_readblk(a,b,c,d)		__cfe_readblk(a,b,c,d)
-#define cfe_setenv(a,b)			__cfe_setenv(a,b)
-#define cfe_write(a,b,c)		__cfe_write(a,b,c)
-#define cfe_writeblk(a,b,c,d)		__cfe_writeblk(a,b,c,d)
-#endif				/* CFE_API_IMPL_NAMESPACE */
-
-int cfe_close(int handle);
-int cfe_cpu_start(int cpu, void (*fn) (void), long sp, long gp, long a1);
-int cfe_cpu_stop(int cpu);
-int cfe_enumenv(int idx, char *name, int namelen, char *val, int vallen);
-int cfe_enummem(int idx, int flags, uint64_t * start, uint64_t * length,
-		uint64_t * type);
-int cfe_exit(int warm, int status);
-int cfe_flushcache(int flg);
-int cfe_getdevinfo(char *name);
-int cfe_getenv(char *name, char *dest, int destlen);
-int cfe_getfwinfo(cfe_fwinfo_t * info);
-int cfe_getstdhandle(int flg);
-int cfe_init(uint64_t handle, uint64_t ept);
-int cfe_inpstat(int handle);
-int cfe_ioctl(int handle, unsigned int ioctlnum, unsigned char *buffer,
-	      int length, int *retlen, uint64_t offset);
-int cfe_open(char *name);
-int cfe_read(int handle, unsigned char *buffer, int length);
-int cfe_readblk(int handle, int64_t offset, unsigned char *buffer,
-		int length);
-int cfe_setenv(char *name, char *val);
-int cfe_write(int handle, unsigned char *buffer, int length);
-int cfe_writeblk(int handle, int64_t offset, unsigned char *buffer,
-		 int length);
-
-#endif				/* CFE_API_H */
diff -puN arch/mips/sibyte/cfe/cfe_api_int.h~mips-move-platform-independent-cfe-code-into-arch-mips-cfe /dev/null
--- a/arch/mips/sibyte/cfe/cfe_api_int.h
+++ /dev/null
@@ -1,152 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- */
-
-/*  *********************************************************************
-    *
-    *  Broadcom Common Firmware Environment (CFE)
-    *
-    *  Device function prototypes		File: cfe_api_int.h
-    *
-    *  This header defines all internal types and macros for the
-    *  library.  This is stuff that's not exported to an app
-    *  using the library.
-    *
-    *  Authors:  Mitch Lichtenberg, Chris Demetriou
-    *
-    ********************************************************************* */
-
-#ifndef CFE_API_INT_H
-#define CFE_API_INT_H
-
-/*  *********************************************************************
-    *  Constants
-    ********************************************************************* */
-
-#define CFE_CMD_FW_GETINFO	0
-#define CFE_CMD_FW_RESTART	1
-#define CFE_CMD_FW_BOOT		2
-#define CFE_CMD_FW_CPUCTL	3
-#define CFE_CMD_FW_GETTIME      4
-#define CFE_CMD_FW_MEMENUM	5
-#define CFE_CMD_FW_FLUSHCACHE	6
-
-#define CFE_CMD_DEV_GETHANDLE	9
-#define CFE_CMD_DEV_ENUM	10
-#define CFE_CMD_DEV_OPEN	11
-#define CFE_CMD_DEV_INPSTAT	12
-#define CFE_CMD_DEV_READ	13
-#define CFE_CMD_DEV_WRITE	14
-#define CFE_CMD_DEV_IOCTL	15
-#define CFE_CMD_DEV_CLOSE	16
-#define CFE_CMD_DEV_GETINFO	17
-
-#define CFE_CMD_ENV_ENUM	20
-#define CFE_CMD_ENV_GET		22
-#define CFE_CMD_ENV_SET		23
-#define CFE_CMD_ENV_DEL		24
-
-#define CFE_CMD_MAX		32
-
-#define CFE_CMD_VENDOR_USE	0x8000	/* codes above this are for customer use */
-
-/*  *********************************************************************
-    *  Structures
-    ********************************************************************* */
-
-typedef uint64_t cfe_xuint_t;
-typedef int64_t cfe_xint_t;
-typedef int64_t cfe_xptr_t;
-
-typedef struct xiocb_buffer_s {
-	cfe_xuint_t buf_offset;		/* offset on device (bytes) */
-	cfe_xptr_t  buf_ptr;		/* pointer to a buffer */
-	cfe_xuint_t buf_length;		/* length of this buffer */
-	cfe_xuint_t buf_retlen;		/* returned length (for read ops) */
-	cfe_xuint_t buf_ioctlcmd;	/* IOCTL command (used only for IOCTLs) */
-} xiocb_buffer_t;
-
-#define buf_devflags buf_ioctlcmd	/* returned device info flags */
-
-typedef struct xiocb_inpstat_s {
-	cfe_xuint_t inp_status;		/* 1 means input available */
-} xiocb_inpstat_t;
-
-typedef struct xiocb_envbuf_s {
-	cfe_xint_t enum_idx;		/* 0-based enumeration index */
-	cfe_xptr_t name_ptr;		/* name string buffer */
-	cfe_xint_t name_length;		/* size of name buffer */
-	cfe_xptr_t val_ptr;		/* value string buffer */
-	cfe_xint_t val_length;		/* size of value string buffer */
-} xiocb_envbuf_t;
-
-typedef struct xiocb_cpuctl_s {
-	cfe_xuint_t cpu_number;		/* cpu number to control */
-	cfe_xuint_t cpu_command;	/* command to issue to CPU */
-	cfe_xuint_t start_addr;		/* CPU start address */
-	cfe_xuint_t gp_val;		/* starting GP value */
-	cfe_xuint_t sp_val;		/* starting SP value */
-	cfe_xuint_t a1_val;		/* starting A1 value */
-} xiocb_cpuctl_t;
-
-typedef struct xiocb_time_s {
-	cfe_xint_t ticks;		/* current time in ticks */
-} xiocb_time_t;
-
-typedef struct xiocb_exitstat_s {
-	cfe_xint_t status;
-} xiocb_exitstat_t;
-
-typedef struct xiocb_meminfo_s {
-	cfe_xint_t mi_idx;		/* 0-based enumeration index */
-	cfe_xint_t mi_type;		/* type of memory block */
-	cfe_xuint_t mi_addr;		/* physical start address */
-	cfe_xuint_t mi_size;		/* block size */
-} xiocb_meminfo_t;
-
-typedef struct xiocb_fwinfo_s {
-	cfe_xint_t fwi_version;		/* major, minor, eco version */
-	cfe_xint_t fwi_totalmem;	/* total installed mem */
-	cfe_xint_t fwi_flags;		/* various flags */
-	cfe_xint_t fwi_boardid;		/* board ID */
-	cfe_xint_t fwi_bootarea_va;	/* VA of boot area */
-	cfe_xint_t fwi_bootarea_pa;	/* PA of boot area */
-	cfe_xint_t fwi_bootarea_size;	/* size of boot area */
-	cfe_xint_t fwi_reserved1;
-	cfe_xint_t fwi_reserved2;
-	cfe_xint_t fwi_reserved3;
-} xiocb_fwinfo_t;
-
-typedef struct cfe_xiocb_s {
-	cfe_xuint_t xiocb_fcode;	/* IOCB function code */
-	cfe_xint_t xiocb_status;	/* return status */
-	cfe_xint_t xiocb_handle;	/* file/device handle */
-	cfe_xuint_t xiocb_flags;	/* flags for this IOCB */
-	cfe_xuint_t xiocb_psize;	/* size of parameter list */
-	union {
-		xiocb_buffer_t xiocb_buffer;	/* buffer parameters */
-		xiocb_inpstat_t xiocb_inpstat;	/* input status parameters */
-		xiocb_envbuf_t xiocb_envbuf;	/* environment function parameters */
-		xiocb_cpuctl_t xiocb_cpuctl;	/* CPU control parameters */
-		xiocb_time_t xiocb_time;	/* timer parameters */
-		xiocb_meminfo_t xiocb_meminfo;	/* memory arena info parameters */
-		xiocb_fwinfo_t xiocb_fwinfo;	/* firmware information */
-		xiocb_exitstat_t xiocb_exitstat;	/* Exit Status */
-	} plist;
-} cfe_xiocb_t;
-
-#endif				/* CFE_API_INT_H */
diff -puN arch/mips/sibyte/cfe/cfe_error.h~mips-move-platform-independent-cfe-code-into-arch-mips-cfe /dev/null
--- a/arch/mips/sibyte/cfe/cfe_error.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- */
-
-/*  *********************************************************************
-    *
-    *  Broadcom Common Firmware Environment (CFE)
-    *
-    *  Error codes				File: cfe_error.h
-    *
-    *  CFE's global error code list is here.
-    *
-    *  Author:  Mitch Lichtenberg
-    *
-    ********************************************************************* */
-
-
-#define CFE_OK			 0
-#define CFE_ERR                 -1	/* generic error */
-#define CFE_ERR_INV_COMMAND	-2
-#define CFE_ERR_EOF		-3
-#define CFE_ERR_IOERR		-4
-#define CFE_ERR_NOMEM		-5
-#define CFE_ERR_DEVNOTFOUND	-6
-#define CFE_ERR_DEVOPEN		-7
-#define CFE_ERR_INV_PARAM	-8
-#define CFE_ERR_ENVNOTFOUND	-9
-#define CFE_ERR_ENVREADONLY	-10
-
-#define CFE_ERR_NOTELF		-11
-#define CFE_ERR_NOT32BIT 	-12
-#define CFE_ERR_WRONGENDIAN 	-13
-#define CFE_ERR_BADELFVERS 	-14
-#define CFE_ERR_NOTMIPS 	-15
-#define CFE_ERR_BADELFFMT 	-16
-#define CFE_ERR_BADADDR 	-17
-
-#define CFE_ERR_FILENOTFOUND	-18
-#define CFE_ERR_UNSUPPORTED	-19
-
-#define CFE_ERR_HOSTUNKNOWN	-20
-
-#define CFE_ERR_TIMEOUT		-21
-
-#define CFE_ERR_PROTOCOLERR	-22
-
-#define CFE_ERR_NETDOWN		-23
-#define CFE_ERR_NONAMESERVER	-24
-
-#define CFE_ERR_NOHANDLES	-25
-#define CFE_ERR_ALREADYBOUND	-26
-
-#define CFE_ERR_CANNOTSET	-27
-#define CFE_ERR_NOMORE		-28
-#define CFE_ERR_BADFILESYS	-29
-#define CFE_ERR_FSNOTAVAIL	-30
-
-#define CFE_ERR_INVBOOTBLOCK	-31
-#define CFE_ERR_WRONGDEVTYPE	-32
-#define CFE_ERR_BBCHECKSUM	-33
-#define CFE_ERR_BOOTPROGCHKSUM	-34
-
-#define CFE_ERR_LDRNOTAVAIL	-35
-
-#define CFE_ERR_NOTREADY	-36
-
-#define CFE_ERR_GETMEM          -37
-#define CFE_ERR_SETMEM          -38
-
-#define CFE_ERR_NOTCONN		-39
-#define CFE_ERR_ADDRINUSE	-40
diff -puN arch/mips/sibyte/cfe/console.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/sibyte/cfe/console.c
--- a/arch/mips/sibyte/cfe/console.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/sibyte/cfe/console.c
@@ -4,8 +4,8 @@
 
 #include <asm/sibyte/board.h>
 
-#include "cfe_api.h"
-#include "cfe_error.h"
+#include <asm/cfe/cfe_api.h>
+#include <asm/cfe/cfe_error.h>
 
 extern int cfe_cons_handle;
 
diff -puN arch/mips/sibyte/cfe/setup.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/sibyte/cfe/setup.c
--- a/arch/mips/sibyte/cfe/setup.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/sibyte/cfe/setup.c
@@ -29,8 +29,8 @@
 #include <asm/reboot.h>
 #include <asm/sibyte/board.h>
 
-#include "cfe_api.h"
-#include "cfe_error.h"
+#include <asm/cfe/cfe_api.h>
+#include <asm/cfe/cfe_error.h>
 
 /* Max ram addressable in 32-bit segments */
 #ifdef CONFIG_64BIT
diff -puN arch/mips/sibyte/cfe/smp.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe arch/mips/sibyte/cfe/smp.c
--- a/arch/mips/sibyte/cfe/smp.c~mips-move-platform-independent-cfe-code-into-arch-mips-cfe
+++ a/arch/mips/sibyte/cfe/smp.c
@@ -21,8 +21,8 @@
 #include <linux/smp.h>
 #include <asm/processor.h>
 
-#include "cfe_api.h"
-#include "cfe_error.h"
+#include <asm/cfe/cfe_api.h>
+#include <asm/cfe/cfe_error.h>
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
diff -puN /dev/null include/asm-mips/cfe/cfe_api.h
--- /dev/null
+++ a/include/asm-mips/cfe/cfe_api.h
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*  *********************************************************************
+    *
+    *  Broadcom Common Firmware Environment (CFE)
+    *
+    *  Device function prototypes		File: cfe_api.h
+    *
+    *  This file contains declarations for doing callbacks to
+    *  cfe from an application.  It should be the only header
+    *  needed by the application to use this library
+    *
+    *  Authors:  Mitch Lichtenberg, Chris Demetriou
+    *
+    ********************************************************************* */
+
+#ifndef CFE_API_H
+#define CFE_API_H
+
+/*
+ * Apply customizations here for different OSes.  These need to:
+ *	* typedef uint64_t, int64_t, intptr_t, uintptr_t.
+ *	* define cfe_strlen() if use of an existing function is desired.
+ *	* define CFE_API_IMPL_NAMESPACE if API functions are to use
+ *	  names in the implementation namespace.
+ * Also, optionally, if the build environment does not do so automatically,
+ * CFE_API_* can be defined here as desired.
+ */
+/* Begin customization. */
+#include <linux/types.h>
+#include <linux/string.h>
+
+typedef long intptr_t;
+
+#define cfe_strlen strlen
+
+#define CFE_API_ALL
+#define CFE_API_STRLEN_CUSTOM
+/* End customization. */
+
+
+/*  *********************************************************************
+    *  Constants
+    ********************************************************************* */
+
+/* Seal indicating CFE's presence, passed to user program. */
+#define CFE_EPTSEAL 0x43464531
+
+#define CFE_MI_RESERVED	0	/* memory is reserved, do not use */
+#define CFE_MI_AVAILABLE 1	/* memory is available */
+
+#define CFE_FLG_WARMSTART     0x00000001
+#define CFE_FLG_FULL_ARENA    0x00000001
+#define CFE_FLG_ENV_PERMANENT 0x00000001
+
+#define CFE_CPU_CMD_START 1
+#define CFE_CPU_CMD_STOP 0
+
+#define CFE_STDHANDLE_CONSOLE	0
+
+#define CFE_DEV_NETWORK 	1
+#define CFE_DEV_DISK		2
+#define CFE_DEV_FLASH		3
+#define CFE_DEV_SERIAL		4
+#define CFE_DEV_CPU		5
+#define CFE_DEV_NVRAM		6
+#define CFE_DEV_CLOCK           7
+#define CFE_DEV_OTHER		8
+#define CFE_DEV_MASK		0x0F
+
+#define CFE_CACHE_FLUSH_D	1
+#define CFE_CACHE_INVAL_I	2
+#define CFE_CACHE_INVAL_D	4
+#define CFE_CACHE_INVAL_L2	8
+
+#define CFE_FWI_64BIT		0x00000001
+#define CFE_FWI_32BIT		0x00000002
+#define CFE_FWI_RELOC		0x00000004
+#define CFE_FWI_UNCACHED	0x00000008
+#define CFE_FWI_MULTICPU	0x00000010
+#define CFE_FWI_FUNCSIM		0x00000020
+#define CFE_FWI_RTLSIM		0x00000040
+
+typedef struct {
+	int64_t fwi_version;		/* major, minor, eco version */
+	int64_t fwi_totalmem;		/* total installed mem */
+	int64_t fwi_flags;		/* various flags */
+	int64_t fwi_boardid;		/* board ID */
+	int64_t fwi_bootarea_va;	/* VA of boot area */
+	int64_t fwi_bootarea_pa;	/* PA of boot area */
+	int64_t fwi_bootarea_size;	/* size of boot area */
+} cfe_fwinfo_t;
+
+
+/*
+ * cfe_strlen is handled specially: If already defined, it has been
+ * overridden in this environment with a standard strlen-like function.
+ */
+#ifdef cfe_strlen
+# define CFE_API_STRLEN_CUSTOM
+#else
+# ifdef CFE_API_IMPL_NAMESPACE
+#  define cfe_strlen(a)			__cfe_strlen(a)
+# endif
+int cfe_strlen(char *name);
+#endif
+
+/*
+ * Defines and prototypes for functions which take no arguments.
+ */
+#ifdef CFE_API_IMPL_NAMESPACE
+int64_t __cfe_getticks(void);
+#define cfe_getticks()			__cfe_getticks()
+#else
+int64_t cfe_getticks(void);
+#endif
+
+/*
+ * Defines and prototypes for the rest of the functions.
+ */
+#ifdef CFE_API_IMPL_NAMESPACE
+#define cfe_close(a)			__cfe_close(a)
+#define cfe_cpu_start(a,b,c,d,e)	__cfe_cpu_start(a,b,c,d,e)
+#define cfe_cpu_stop(a)			__cfe_cpu_stop(a)
+#define cfe_enumenv(a,b,d,e,f)		__cfe_enumenv(a,b,d,e,f)
+#define cfe_enummem(a,b,c,d,e)		__cfe_enummem(a,b,c,d,e)
+#define cfe_exit(a,b)			__cfe_exit(a,b)
+#define cfe_flushcache(a)		__cfe_cacheflush(a)
+#define cfe_getdevinfo(a)		__cfe_getdevinfo(a)
+#define cfe_getenv(a,b,c)		__cfe_getenv(a,b,c)
+#define cfe_getfwinfo(a)		__cfe_getfwinfo(a)
+#define cfe_getstdhandle(a)		__cfe_getstdhandle(a)
+#define cfe_init(a,b)			__cfe_init(a,b)
+#define cfe_inpstat(a)			__cfe_inpstat(a)
+#define cfe_ioctl(a,b,c,d,e,f)		__cfe_ioctl(a,b,c,d,e,f)
+#define cfe_open(a)			__cfe_open(a)
+#define cfe_read(a,b,c)			__cfe_read(a,b,c)
+#define cfe_readblk(a,b,c,d)		__cfe_readblk(a,b,c,d)
+#define cfe_setenv(a,b)			__cfe_setenv(a,b)
+#define cfe_write(a,b,c)		__cfe_write(a,b,c)
+#define cfe_writeblk(a,b,c,d)		__cfe_writeblk(a,b,c,d)
+#endif				/* CFE_API_IMPL_NAMESPACE */
+
+int cfe_close(int handle);
+int cfe_cpu_start(int cpu, void (*fn) (void), long sp, long gp, long a1);
+int cfe_cpu_stop(int cpu);
+int cfe_enumenv(int idx, char *name, int namelen, char *val, int vallen);
+int cfe_enummem(int idx, int flags, uint64_t * start, uint64_t * length,
+		uint64_t * type);
+int cfe_exit(int warm, int status);
+int cfe_flushcache(int flg);
+int cfe_getdevinfo(char *name);
+int cfe_getenv(char *name, char *dest, int destlen);
+int cfe_getfwinfo(cfe_fwinfo_t * info);
+int cfe_getstdhandle(int flg);
+int cfe_init(uint64_t handle, uint64_t ept);
+int cfe_inpstat(int handle);
+int cfe_ioctl(int handle, unsigned int ioctlnum, unsigned char *buffer,
+	      int length, int *retlen, uint64_t offset);
+int cfe_open(char *name);
+int cfe_read(int handle, unsigned char *buffer, int length);
+int cfe_readblk(int handle, int64_t offset, unsigned char *buffer,
+		int length);
+int cfe_setenv(char *name, char *val);
+int cfe_write(int handle, unsigned char *buffer, int length);
+int cfe_writeblk(int handle, int64_t offset, unsigned char *buffer,
+		 int length);
+
+#endif				/* CFE_API_H */
diff -puN /dev/null include/asm-mips/cfe/cfe_error.h
--- /dev/null
+++ a/include/asm-mips/cfe/cfe_error.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (C) 2000, 2001, 2002 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*  *********************************************************************
+    *
+    *  Broadcom Common Firmware Environment (CFE)
+    *
+    *  Error codes				File: cfe_error.h
+    *
+    *  CFE's global error code list is here.
+    *
+    *  Author:  Mitch Lichtenberg
+    *
+    ********************************************************************* */
+
+
+#define CFE_OK			 0
+#define CFE_ERR                 -1	/* generic error */
+#define CFE_ERR_INV_COMMAND	-2
+#define CFE_ERR_EOF		-3
+#define CFE_ERR_IOERR		-4
+#define CFE_ERR_NOMEM		-5
+#define CFE_ERR_DEVNOTFOUND	-6
+#define CFE_ERR_DEVOPEN		-7
+#define CFE_ERR_INV_PARAM	-8
+#define CFE_ERR_ENVNOTFOUND	-9
+#define CFE_ERR_ENVREADONLY	-10
+
+#define CFE_ERR_NOTELF		-11
+#define CFE_ERR_NOT32BIT 	-12
+#define CFE_ERR_WRONGENDIAN 	-13
+#define CFE_ERR_BADELFVERS 	-14
+#define CFE_ERR_NOTMIPS 	-15
+#define CFE_ERR_BADELFFMT 	-16
+#define CFE_ERR_BADADDR 	-17
+
+#define CFE_ERR_FILENOTFOUND	-18
+#define CFE_ERR_UNSUPPORTED	-19
+
+#define CFE_ERR_HOSTUNKNOWN	-20
+
+#define CFE_ERR_TIMEOUT		-21
+
+#define CFE_ERR_PROTOCOLERR	-22
+
+#define CFE_ERR_NETDOWN		-23
+#define CFE_ERR_NONAMESERVER	-24
+
+#define CFE_ERR_NOHANDLES	-25
+#define CFE_ERR_ALREADYBOUND	-26
+
+#define CFE_ERR_CANNOTSET	-27
+#define CFE_ERR_NOMORE		-28
+#define CFE_ERR_BADFILESYS	-29
+#define CFE_ERR_FSNOTAVAIL	-30
+
+#define CFE_ERR_INVBOOTBLOCK	-31
+#define CFE_ERR_WRONGDEVTYPE	-32
+#define CFE_ERR_BBCHECKSUM	-33
+#define CFE_ERR_BOOTPROGCHKSUM	-34
+
+#define CFE_ERR_LDRNOTAVAIL	-35
+
+#define CFE_ERR_NOTREADY	-36
+
+#define CFE_ERR_GETMEM          -37
+#define CFE_ERR_SETMEM          -38
+
+#define CFE_ERR_NOTCONN		-39
+#define CFE_ERR_ADDRINUSE	-40
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch

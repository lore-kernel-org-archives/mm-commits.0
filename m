From: akpm@linux-foundation.org
Subject: [merged] nfs-avoid-warnings-when-config_nfs_v4=n.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:48 -0800
Message-ID: <201001212128.o0LLSmaA030758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab0AUV3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: avoid warnings when CONFIG_NFS_V4=n
has been removed from the -mm tree.  Its filename was
     nfs-avoid-warnings-when-config_nfs_v4=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: avoid warnings when CONFIG_NFS_V4=n
From: David Howells <dhowells@redhat.com>

Avoid the following warnings when CONFIG_NFS_V4=n:

	fs/nfs/sysctl.c:19: warning: unused variable `nfs_set_port_max'
	fs/nfs/sysctl.c:18: warning: unused variable `nfs_set_port_min'

by making those variables contingent on NFSv4 being configured.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/sysctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/nfs/sysctl.c~nfs-avoid-warnings-when-config_nfs_v4=n fs/nfs/sysctl.c
--- a/fs/nfs/sysctl.c~nfs-avoid-warnings-when-config_nfs_v4=n
+++ a/fs/nfs/sysctl.c
@@ -15,8 +15,10 @@
 
 #include "callback.h"
 
+#ifdef CONFIG_NFS_V4
 static const int nfs_set_port_min = 0;
 static const int nfs_set_port_max = 65535;
+#endif
 static struct ctl_table_header *nfs_callback_sysctl_table;
 
 static ctl_table nfs_cb_sysctls[] = {
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


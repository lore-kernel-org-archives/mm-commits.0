From: akpm@linux-foundation.org
Subject: + nfs-avoid-warnings-when-config_nfs_v4=n.patch added to -mm tree
Date: Wed, 13 Jan 2010 16:52:06 -0800
Message-ID: <201001140052.o0E0q6H9006588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab0ANAxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 19:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     nfs: avoid warnings when CONFIG_NFS_V4=n
has been added to the -mm tree.  Its filename is
     nfs-avoid-warnings-when-config_nfs_v4=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

kernel-credc-use-kmem_cache_free.patch
nfs-avoid-warnings-when-config_nfs_v4=n.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


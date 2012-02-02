From: akpm@linux-foundation.org
Subject: [merged] sunrpc-fix-statsh-for-config_proc_fs-not-enabled.patch removed from -mm tree
Date: Thu, 02 Feb 2012 12:11:20 -0800
Message-ID: <20120202201121.78B8CA016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46123 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2BBULX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 15:11:23 -0500
Received: by yenl2 with SMTP id l2so304251yen.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 12:11:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, Trond.Myklebust@netapp.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sunrpc: fix stats.h for CONFIG_PROC_FS not enabled
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-statsh-for-config_proc_fs-not-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: sunrpc: fix stats.h for CONFIG_PROC_FS not enabled

Fix build errors in linux/sunrpc/stats.h when CONFIG_PROC_FS
is not enabled:
- add parameter names to inline functions
- fix placement of '(' in rpc_proc_unregister()

Fixes these errors:
include/linux/sunrpc/stats.h:72:63: error: parameter name omitted
include/linux/sunrpc/stats.h:73:46: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'net'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/stats.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sunrpc/stats.h~sunrpc-fix-statsh-for-config_proc_fs-not-enabled include/linux/sunrpc/stats.h
--- a/include/linux/sunrpc/stats.h~sunrpc-fix-statsh-for-config_proc_fs-not-enabled
+++ a/include/linux/sunrpc/stats.h
@@ -69,8 +69,8 @@ void			svc_seq_show(struct seq_file *,
 				     const struct svc_stat *);
 #else
 
-static inline struct proc_dir_entry *rpc_proc_register(struct net *, struct rpc_stat *s) { return NULL; }
-static inline void rpc_proc_unregisterstruct net *, (const char *p) {}
+static inline struct proc_dir_entry *rpc_proc_register(struct net *net, struct rpc_stat *s) { return NULL; }
+static inline void rpc_proc_unregister(struct net *net, const char *p) {}
 static inline void rpc_proc_zero(const struct rpc_program *p) {}
 
 static inline struct proc_dir_entry *svc_proc_register(struct net *net, struct svc_stat *s,
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch


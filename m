From: akpm@linux-foundation.org
Subject: + sunrpc-fix-statsh-for-config_proc_fs-not-enabled.patch added to -mm tree
Date: Wed, 25 Jan 2012 16:28:24 -0800
Message-ID: <20120126002824.903C9A0291@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:45183 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2AZA20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 19:28:26 -0500
Received: by faaa19 with SMTP id a19so19294faa.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 16:28:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, Trond.Myklebust@netapp.com, skinsbursky@parallels.com


The patch titled
     Subject: sunrpc: fix stats.h for CONFIG_PROC_FS not enabled
has been added to the -mm tree.  Its filename is
     sunrpc-fix-statsh-for-config_proc_fs-not-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: sunrpc: fix stats.h for CONFIG_PROC_FS not enabled

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
sunrpc-fix-statsh-for-config_proc_fs-not-enabled.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
ramoops-use-pstore-interface.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch


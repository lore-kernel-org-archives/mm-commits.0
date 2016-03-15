From: akpm@linux-foundation.org
Subject: + cred-userns-define-current_user_ns-as-a-function.patch added to -mm tree
Date: Tue, 15 Mar 2016 11:58:40 -0700
Message-ID: <56e85b60.sPLKUgfSk/mr9FL2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145AbcCOS6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 14:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, baiyaowei@cmss.chinamobile.com, dhowells@redhat.com, james.l.morris@oracle.com, paulmck@linux.vnet.ibm.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cred/userns: define current_user_ns() as a function
has been added to the -mm tree.  Its filename is
     cred-userns-define-current_user_ns-as-a-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cred-userns-define-current_user_ns-as-a-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cred-userns-define-current_user_ns-as-a-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: cred/userns: define current_user_ns() as a function

The current_user_ns() macro currently returns &init_user_ns when
user namespaces are disabled, and that causes several warnings
when building with gcc-6.0 in code that compares the result of
the macro to &init_user_ns itself:

fs/xfs/xfs_ioctl.c: In function 'xfs_ioctl_setattr_check_projid':
fs/xfs/xfs_ioctl.c:1249:22: error: self-comparison always evaluates to true [-Werror=tautological-compare]
  if (current_user_ns() == &init_user_ns)

This is a legitimate warning in principle, but here it isn't
really helpful, so I'm reprasing the definition in a way that
shuts up the warning. Apparently gcc only warns when comparing
identical literals, but it can figure out that the result of
an inline function can be identical to a constant expression
in order to optimize a condition yet not warn about the fact
that the condition is known at compile time. This is exactly
what we want here, and it looks reasonable because we generally
prefer inline functions over macros anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    2 --
 include/linux/cred.h       |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/capability.h~cred-userns-define-current_user_ns-as-a-function include/linux/capability.h
--- a/include/linux/capability.h~cred-userns-define-current_user_ns-as-a-function
+++ a/include/linux/capability.h
@@ -40,8 +40,6 @@ struct inode;
 struct dentry;
 struct user_namespace;
 
-struct user_namespace *current_user_ns(void);
-
 extern const kernel_cap_t __cap_empty_set;
 extern const kernel_cap_t __cap_init_eff_set;
 
diff -puN include/linux/cred.h~cred-userns-define-current_user_ns-as-a-function include/linux/cred.h
--- a/include/linux/cred.h~cred-userns-define-current_user_ns-as-a-function
+++ a/include/linux/cred.h
@@ -377,7 +377,10 @@ extern struct user_namespace init_user_n
 #ifdef CONFIG_USER_NS
 #define current_user_ns()	(current_cred_xxx(user_ns))
 #else
-#define current_user_ns()	(&init_user_ns)
+static inline struct user_namespace *current_user_ns(void)
+{
+	return &init_user_ns;
+}
 #endif
 
 
_

Patches currently in -mm which might be from arnd@arndb.de are

paride-make-verbose-parameter-an-int-again.patch
mm-compaction-introduce-kcompactd-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch
cred-userns-define-current_user_ns-as-a-function.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch


From: akpm@linux-foundation.org
Subject: [merged] cred-userns-define-current_user_ns-as-a-function.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:14 -0700
Message-ID: <56f2d576.njX+LH1gls3j1oU0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbcCWRmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, baiyaowei@cmss.chinamobile.com, dhowells@redhat.com, james.l.morris@oracle.com, paulmck@linux.vnet.ibm.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cred/userns: define current_user_ns() as a function
has been removed from the -mm tree.  Its filename was
     cred-userns-define-current_user_ns-as-a-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

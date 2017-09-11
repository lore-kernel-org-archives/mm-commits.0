From: akpm@linux-foundation.org
Subject: [merged]
 kmod-split-off-umh-headers-into-its-own-file.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:43:43 -0700
Message-ID: <20170911194343.lAHuwucd0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdIKTnp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, linux@roeck-us.net, matt.redfearn@imgtec.com, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au


The patch titled
     Subject: kmod: split off umh headers into its own file
has been removed from the -mm tree.  Its filename was
     kmod-split-off-umh-headers-into-its-own-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: split off umh headers into its own file

In the future usermode helper users do not need to carry in all the of
kmod headers declarations.

Since kmod.h still includes umh.h this change has no functional changes,
each umh user can be cleaned up separately later and with time.

Link: http://lkml.kernel.org/r/20170810180618.22457-4-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS          |    1 
 include/linux/kmod.h |   60 -----------------------------------
 include/linux/umh.h  |   69 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 59 deletions(-)

diff -puN MAINTAINERS~kmod-split-off-umh-headers-into-its-own-file MAINTAINERS
--- a/MAINTAINERS~kmod-split-off-umh-headers-into-its-own-file
+++ a/MAINTAINERS
@@ -7462,6 +7462,7 @@ M:	"Luis R. Rodriguez" <mcgrof@kernel.or
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	kernel/umh.c
+F:	include/linux/umh.h
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
diff -puN include/linux/kmod.h~kmod-split-off-umh-headers-into-its-own-file include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-split-off-umh-headers-into-its-own-file
+++ a/include/linux/kmod.h
@@ -19,6 +19,7 @@
  *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/umh.h>
 #include <linux/gfp.h>
 #include <linux/stddef.h>
 #include <linux/errno.h>
@@ -44,63 +45,4 @@ static inline int request_module_nowait(
 #define try_then_request_module(x, mod...) (x)
 #endif
 
-
-struct cred;
-struct file;
-
-#define UMH_NO_WAIT	0	/* don't wait at all */
-#define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
-#define UMH_WAIT_PROC	2	/* wait for the process to complete */
-#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
-
-struct subprocess_info {
-	struct work_struct work;
-	struct completion *complete;
-	const char *path;
-	char **argv;
-	char **envp;
-	int wait;
-	int retval;
-	int (*init)(struct subprocess_info *info, struct cred *new);
-	void (*cleanup)(struct subprocess_info *info);
-	void *data;
-} __randomize_layout;
-
-extern int
-call_usermodehelper(const char *path, char **argv, char **envp, int wait);
-
-extern struct subprocess_info *
-call_usermodehelper_setup(const char *path, char **argv, char **envp,
-			  gfp_t gfp_mask,
-			  int (*init)(struct subprocess_info *info, struct cred *new),
-			  void (*cleanup)(struct subprocess_info *), void *data);
-
-extern int
-call_usermodehelper_exec(struct subprocess_info *info, int wait);
-
-extern struct ctl_table usermodehelper_table[];
-
-enum umh_disable_depth {
-	UMH_ENABLED = 0,
-	UMH_FREEZING,
-	UMH_DISABLED,
-};
-
-extern int __usermodehelper_disable(enum umh_disable_depth depth);
-extern void __usermodehelper_set_disable_depth(enum umh_disable_depth depth);
-
-static inline int usermodehelper_disable(void)
-{
-	return __usermodehelper_disable(UMH_DISABLED);
-}
-
-static inline void usermodehelper_enable(void)
-{
-	__usermodehelper_set_disable_depth(UMH_ENABLED);
-}
-
-extern int usermodehelper_read_trylock(void);
-extern long usermodehelper_read_lock_wait(long timeout);
-extern void usermodehelper_read_unlock(void);
-
 #endif /* __LINUX_KMOD_H__ */
diff -puN /dev/null include/linux/umh.h
--- /dev/null
+++ a/include/linux/umh.h
@@ -0,0 +1,69 @@
+#ifndef __LINUX_UMH_H__
+#define __LINUX_UMH_H__
+
+#include <linux/gfp.h>
+#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/compiler.h>
+#include <linux/workqueue.h>
+#include <linux/sysctl.h>
+
+struct cred;
+struct file;
+
+#define UMH_NO_WAIT	0	/* don't wait at all */
+#define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
+#define UMH_WAIT_PROC	2	/* wait for the process to complete */
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+
+struct subprocess_info {
+	struct work_struct work;
+	struct completion *complete;
+	const char *path;
+	char **argv;
+	char **envp;
+	int wait;
+	int retval;
+	int (*init)(struct subprocess_info *info, struct cred *new);
+	void (*cleanup)(struct subprocess_info *info);
+	void *data;
+} __randomize_layout;
+
+extern int
+call_usermodehelper(const char *path, char **argv, char **envp, int wait);
+
+extern struct subprocess_info *
+call_usermodehelper_setup(const char *path, char **argv, char **envp,
+			  gfp_t gfp_mask,
+			  int (*init)(struct subprocess_info *info, struct cred *new),
+			  void (*cleanup)(struct subprocess_info *), void *data);
+
+extern int
+call_usermodehelper_exec(struct subprocess_info *info, int wait);
+
+extern struct ctl_table usermodehelper_table[];
+
+enum umh_disable_depth {
+	UMH_ENABLED = 0,
+	UMH_FREEZING,
+	UMH_DISABLED,
+};
+
+extern int __usermodehelper_disable(enum umh_disable_depth depth);
+extern void __usermodehelper_set_disable_depth(enum umh_disable_depth depth);
+
+static inline int usermodehelper_disable(void)
+{
+	return __usermodehelper_disable(UMH_DISABLED);
+}
+
+static inline void usermodehelper_enable(void)
+{
+	__usermodehelper_set_disable_depth(UMH_ENABLED);
+}
+
+extern int usermodehelper_read_trylock(void);
+extern long usermodehelper_read_lock_wait(long timeout);
+extern void usermodehelper_read_unlock(void);
+
+#endif /* __LINUX_UMH_H__ */
_

Patches currently in -mm which might be from mcgrof@kernel.org are



From: akpm@linux-foundation.org
Subject: [merged]
 compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:30 -0700
Message-ID: <56f2d50e.kwC1Ck065HcUsA5M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcCWRkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, adilger.kernel@dilger.ca, airlied@linux.ie, clemens@ladisch.de, davem@davemloft.net, dh.herrmann@googlemail.com, dmitry.torokhov@gmail.com, eparis@redhat.com, herbert@gondor.apana.org.au, hpa@zytor.com, jkosina@suse.cz, matt@codeblueprint.co.uk, mingo@elte.hu, nhorman@tuxdriver.com, oded.gabbay@gmail.com, oleg.drokin@intel.com, oleg@redhat.com, paul@paul-moore.com, sam@ravnborg.org, steffen.klassert@secunet.com, tglx@linutronix.de, tytso@mit.edu, vyasevich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: add in_compat_syscall to ask whether we're in a compat syscall
has been removed from the -mm tree.  Its filename was
     compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: compat: add in_compat_syscall to ask whether we're in a compat syscall

A lot of code currently abuses is_compat_task to determine this.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: David Herrmann <dh.herrmann@googlemail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/compat.h~compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall include/linux/compat.h
--- a/include/linux/compat.h~compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall
+++ a/include/linux/compat.h
@@ -5,6 +5,8 @@
  * syscall compatibility layer.
  */
 
+#include <linux/types.h>
+
 #ifdef CONFIG_COMPAT
 
 #include <linux/stat.h>
@@ -719,9 +721,22 @@ asmlinkage long compat_sys_sched_rr_get_
 
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
+
+/*
+ * For most but not all architectures, "am I in a compat syscall?" and
+ * "am I a compat task?" are the same question.  For architectures on which
+ * they aren't the same question, arch code can override in_compat_syscall.
+ */
+
+#ifndef in_compat_syscall
+static inline bool in_compat_syscall(void) { return is_compat_task(); }
+#endif
+
 #else
 
 #define is_compat_task() (0)
+static inline bool in_compat_syscall(void) { return false; }
 
 #endif /* CONFIG_COMPAT */
+
 #endif /* _LINUX_COMPAT_H */
_

Patches currently in -mm which might be from luto@kernel.org are



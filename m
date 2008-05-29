From: akpm@linux-foundation.org
Subject: + call_usermodehelper-increase-reliability.patch added to -mm tree
Date: Wed, 28 May 2008 17:04:23 -0700
Message-ID: <200805290004.m4T04NAB007061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbYE2AFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 20:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, jeremy@xensource.com, lizf@cn.fujitsu.com, menage@google.com, rusty@rustcorp.com.au


The patch titled
     call_usermodehelper(): increase reliability
has been added to the -mm tree.  Its filename is
     call_usermodehelper-increase-reliability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: call_usermodehelper(): increase reliability
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently call_usermodehelper_setup() uses GFP_ATOMIC.  but it can return
NULL _very_ easily.

GFP_ATOMIC is needed only when we can't sleep.  and, GFP_KERNEL is robust
and better.

thus, I add gfp_mask argument to call_usermodehelper_setup().

So, its callers pass the gfp_t as below:

call_usermodehelper() and call_usermodehelper_keys():
	depend on 'wait' argument.
call_usermodehelper_pipe():
	always GFP_KERNEL because always run under process context.
orderly_poweroff():
	pass to GFP_ATOMIC because may run under interrupt context.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Paul Menage" <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   11 +++++++----
 kernel/kmod.c        |    9 +++++----
 kernel/sys.c         |    2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN include/linux/kmod.h~call_usermodehelper-increase-reliability include/linux/kmod.h
--- a/include/linux/kmod.h~call_usermodehelper-increase-reliability
+++ a/include/linux/kmod.h
@@ -19,6 +19,7 @@
  *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/gfp.h>
 #include <linux/stddef.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
@@ -40,8 +41,8 @@ struct file;
 struct subprocess_info;
 
 /* Allocate a subprocess_info structure */
-struct subprocess_info *call_usermodehelper_setup(char *path,
-						  char **argv, char **envp);
+struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
+						  char **envp, gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
@@ -68,8 +69,9 @@ static inline int
 call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
 	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 	return call_usermodehelper_exec(info, wait);
@@ -80,8 +82,9 @@ call_usermodehelper_keys(char *path, cha
 			 struct key *session_keyring, enum umh_wait wait)
 {
 	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/kmod.c~call_usermodehelper-increase-reliability kernel/kmod.c
--- a/kernel/kmod.c~call_usermodehelper-increase-reliability
+++ a/kernel/kmod.c
@@ -352,16 +352,17 @@ static inline void register_pm_notifier_
  * @path: path to usermode executable
  * @argv: arg vector for process
  * @envp: environment for process
+ * @gfp_mask: gfp mask for memory allocation
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
-struct subprocess_info *call_usermodehelper_setup(char *path,
-						  char **argv, char **envp)
+struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
+						  char **envp, gfp_t gfp_mask)
 {
 	struct subprocess_info *sub_info;
-	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
+	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
 	if (!sub_info)
 		goto out;
 
@@ -494,7 +495,7 @@ int call_usermodehelper_pipe(char *path,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp);
+	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/sys.c~call_usermodehelper-increase-reliability kernel/sys.c
--- a/kernel/sys.c~call_usermodehelper-increase-reliability
+++ a/kernel/sys.c
@@ -1795,7 +1795,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	info = call_usermodehelper_setup(argv[0], argv, envp);
+	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
 	if (info == NULL) {
 		argv_free(argv);
 		goto out;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
call_usermodehelper-increase-reliability.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch


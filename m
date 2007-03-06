From: akpm@linux-foundation.org
Subject: - slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:39 -0800
Message-ID: <200703060210.l262Ada1009022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933852AbXCFCOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: misc cleanups requested at inclusion time.
has been removed from the -mm tree.  Its filename was
     slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: slim: misc cleanups requested at inclusion time.
From: Kylene Jo Hall <kjhall@us.ibm.com>

Miscellaneous fixes requested when the intial patches were pulled in
last week.  This patch addresses the following comments.

On Thu, 2006-09-14 at 16:52 -0700, Andrew Morton wrote:
> trivial things:
> > +char *slm_iac_str[] = {
> > +	ZERO_STR,
> > +	UNTRUSTED_STR,
> > +	USER_STR,
> > +	SYSTEM_STR
> > +};
>
> Could this be made static?
>
No because it is used in slm_secfs.c.

> > +		case '#':
> > +			while ((*bufp != '\n') && (bufp++ < buf_end)) ;
>
> newline needed here.
Added in the patch.

> > +static int has_file_wperm(struct slm_file_xattr *cur_level)
> > +{
> > +	int i, j = 0;
> > +	struct files_struct *files = current->files;
> > +	unsigned long fd = 0;
> > +	struct fdtable *fdt;
> > +	struct file *file;
> > +	int rc = 0;
> > +
> > +	if (is_kernel_thread(current))
> > +		return 0;
> > +
> > +	if (!files || !cur_level)
> > +		return 0;
> > +
> > +	spin_lock(&files->file_lock);
> > +	fdt = files_fdtable(files);
> > +
> > +	for (;;) {
> > +		i = j * __NFDBITS;
> > +		if (i >= fdt->max_fdset || i >= fdt->max_fds)
> > +			break;
> > +		fd = fdt->open_fds->fds_bits[j++];
> > +		while (fd) {
> > +			if (fd & 1) {
> > +				file = fdt->fd[i++];
> > +				if (file)
> > +					rc = mark_has_file_wperm(file,
> > +						cur_level);
> > +			}
> > +			fd >>= 1;
> > +		}
> > +	}
> > +	spin_unlock(&files->file_lock);
> > +	return rc;
> > +}
>
> Could we use a more meaningful identifier than `j' here?  Perhaps `i' too?
This function has been cleaned up with the use of find_next_bit and i
and j are no longer used in the patch below.

> > +	for (iac = 0; iac < sizeof(slm_iac_str) / sizeof(char *); iac++) {
>
> ARRAY_SIZE()
Fixed below.

> > +		if (strncmp(token, slm_iac_str[iac], strlen(slm_iac_str[iac]))
> > +		    == 0)
> > +			return iac;
> > +	}
> > +	return SLM_IAC_ERROR;
> > +}
> > +
> >
> > ...
> >
> > +
> > +static inline int slm_getprocattr(struct task_struct *tsk,
> > +				  char *name, void *value, size_t size)
> It's rather pointless to declare a function inline and to then only refer to
> it via a pointer-to-function.  Please review all inlinings.
All inlines have been reviewed and fixed if necessary in the patch
below.  3 hooks were affected.

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff -puN security/slim/slm_main.c~slim-main-patch-misc-cleanups-requested-at-inclusion-time security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-patch-misc-cleanups-requested-at-inclusion-time
+++ a/security/slim/slm_main.c
@@ -58,6 +58,7 @@ static char *get_token(char *buf_start, 
 			break;
 		case '#':
 			while ((*bufp != '\n') && (bufp++ < buf_end)) ;
+
 			bufp++;
 			break;
 		default:
@@ -133,7 +134,6 @@ static inline int mark_has_file_wperm(st
  */
 static int has_file_wperm(struct slm_file_xattr *cur_level)
 {
-	int i, j = 0;
 	struct files_struct *files = current->files;
 	unsigned long fd = 0;
 	struct fdtable *fdt;
@@ -149,21 +149,12 @@ static int has_file_wperm(struct slm_fil
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 
-	for (;;) {
-		i = j * __NFDBITS;
-		if (i >= fdt->max_fdset || i >= fdt->max_fds)
-			break;
-		fd = fdt->open_fds->fds_bits[j++];
-		while (fd) {
-			if (fd & 1) {
-				file = fdt->fd[i++];
-				if (file)
-					rc = mark_has_file_wperm(file,
-						cur_level);
-			}
-			fd >>= 1;
-		}
+	while((fd=find_next_bit(fdt->open_fds->fds_bits, fdt->max_fdset, fd)) < fdt->max_fdset) {
+		file = fdt->fd[fd++];
+		if (file)
+			rc = mark_has_file_wperm(file, cur_level);
 	}
+
 	spin_unlock(&files->file_lock);
 	return rc;
 }
@@ -226,7 +217,7 @@ static enum slm_iac_level parse_iac(char
 
 	if (strncmp(token, EXEMPT_STR, strlen(EXEMPT_STR)) == 0)
 		return SLM_IAC_EXEMPT;
-	for (iac = 0; iac < sizeof(slm_iac_str) / sizeof(char *); iac++) {
+	for (iac = 0; iac < ARRAY_SIZE(slm_iac_str); iac++) {
 		if (strncmp(token, slm_iac_str[iac], strlen(slm_iac_str[iac]))
 		    == 0)
 			return iac;
@@ -1056,14 +1047,14 @@ static int slm_task_post_setuid(uid_t ol
 	return 0;
 }
 
-static inline int slm_setprocattr(struct task_struct *tsk,
+static int slm_setprocattr(struct task_struct *tsk,
 				  char *name, void *value, size_t size)
 {
 	return -EACCES;
 
 }
 
-static inline int slm_getprocattr(struct task_struct *tsk,
+static int slm_getprocattr(struct task_struct *tsk,
 				  char *name, void *value, size_t size)
 {
 	struct slm_tsec_data *tsec = tsk->security;
@@ -1209,7 +1200,7 @@ static int slm_inode_setattr(struct dent
 	return rc;
 }
 
-static inline int slm_capable(struct task_struct *tsk, int cap)
+static int slm_capable(struct task_struct *tsk, int cap)
 {
 	struct slm_tsec_data *tsec = tsk->security;
 	int rc = 0;
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch
slim-main-patch-handle-failure-to-register.patch
slim-main-patch-fix-bug-with-mm_users-usage.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-secfs-patch-slim-correct-use-of-snprintf.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch

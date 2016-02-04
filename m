From: akpm@linux-foundation.org
Subject: + lib-update-single-char-callers-of-strtobool.patch added to -mm
 tree
Date: Thu, 04 Feb 2016 13:40:42 -0800
Message-ID: <56b3c55a.qDNMOnWd8LNMub4V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbcBDVkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:40:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, kvalo@codeaurora.org, mingo@elte.hu, mpe@ellerman.id.au, nishants@marvell.com, sfrench@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: update single-char callers of strtobool()
has been added to the -mm tree.  Its filename is
     lib-update-single-char-callers-of-strtobool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-single-char-callers-of-strtobool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-single-char-callers-of-strtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: update single-char callers of strtobool()

Some callers of strtobool() were passing a pointer to unterminated
strings.  In preparation of adding multi-character processing to
kstrtobool(), update the callers to not pass single-character pointers,
and switch to using the new kstrtobool_from_user() helper where possible.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Steve French <sfrench@samba.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/marvell/mwifiex/debugfs.c |   10 +-
 fs/cifs/cifs_debug.c                           |   58 ++++-----------
 fs/cifs/cifs_debug.h                           |    2 
 fs/cifs/cifsfs.c                               |    6 -
 fs/cifs/cifsglob.h                             |    4 -
 5 files changed, 26 insertions(+), 54 deletions(-)

diff -puN drivers/net/wireless/marvell/mwifiex/debugfs.c~lib-update-single-char-callers-of-strtobool drivers/net/wireless/marvell/mwifiex/debugfs.c
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c~lib-update-single-char-callers-of-strtobool
+++ a/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -880,14 +880,12 @@ mwifiex_reset_write(struct file *file,
 {
 	struct mwifiex_private *priv = file->private_data;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	char cmd;
 	bool result;
+	int rc;
 
-	if (copy_from_user(&cmd, ubuf, sizeof(cmd)))
-		return -EFAULT;
-
-	if (strtobool(&cmd, &result))
-		return -EINVAL;
+	rc = kstrtobool_from_user(ubuf, count, 0, &result);
+	if (rc)
+		return rc;
 
 	if (!result)
 		return -EINVAL;
diff -puN fs/cifs/cifs_debug.c~lib-update-single-char-callers-of-strtobool fs/cifs/cifs_debug.c
--- a/fs/cifs/cifs_debug.c~lib-update-single-char-callers-of-strtobool
+++ a/fs/cifs/cifs_debug.c
@@ -255,7 +255,6 @@ static const struct file_operations cifs
 static ssize_t cifs_stats_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	char c;
 	bool bv;
 	int rc;
 	struct list_head *tmp1, *tmp2, *tmp3;
@@ -263,11 +262,8 @@ static ssize_t cifs_stats_proc_write(str
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
-	rc = get_user(c, buffer);
-	if (rc)
-		return rc;
-
-	if (strtobool(&c, &bv) == 0) {
+	rc = kstrtobool_from_user(buffer, count, 0, &bv);
+	if (rc == 0) {
 #ifdef CONFIG_CIFS_STATS2
 		atomic_set(&totBufAllocCount, 0);
 		atomic_set(&totSmBufAllocCount, 0);
@@ -290,6 +286,8 @@ static ssize_t cifs_stats_proc_write(str
 			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
+	} else {
+		return rc;
 	}
 
 	return count;
@@ -433,17 +431,17 @@ static int cifsFYI_proc_open(struct inod
 static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
-	char c;
+	char c[2] = { '\0' };
 	bool bv;
 	int rc;
 
-	rc = get_user(c, buffer);
+	rc = get_user(c[0], buffer);
 	if (rc)
 		return rc;
-	if (strtobool(&c, &bv) == 0)
+	if (strtobool(c, &bv) == 0)
 		cifsFYI = bv;
-	else if ((c > '1') && (c <= '9'))
-		cifsFYI = (int) (c - '0'); /* see cifs_debug.h for meanings */
+	else if ((c[0] > '1') && (c[0] <= '9'))
+		cifsFYI = (int) (c[0] - '0'); /* see cifs_debug.h for meanings */
 
 	return count;
 }
@@ -471,20 +469,12 @@ static int cifs_linux_ext_proc_open(stru
 static ssize_t cifs_linux_ext_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	char c;
-	bool bv;
 	int rc;
 
-	rc = get_user(c, buffer);
+	rc = kstrtobool_from_user(buffer, count, 0, &linuxExtEnabled);
 	if (rc)
 		return rc;
 
-	rc = strtobool(&c, &bv);
-	if (rc)
-		return rc;
-
-	linuxExtEnabled = bv;
-
 	return count;
 }
 
@@ -511,20 +501,12 @@ static int cifs_lookup_cache_proc_open(s
 static ssize_t cifs_lookup_cache_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	char c;
-	bool bv;
 	int rc;
 
-	rc = get_user(c, buffer);
+	rc = kstrtobool_from_user(buffer, count, 0, &lookupCacheEnabled);
 	if (rc)
 		return rc;
 
-	rc = strtobool(&c, &bv);
-	if (rc)
-		return rc;
-
-	lookupCacheEnabled = bv;
-
 	return count;
 }
 
@@ -551,20 +533,12 @@ static int traceSMB_proc_open(struct ino
 static ssize_t traceSMB_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
-	char c;
-	bool bv;
 	int rc;
 
-	rc = get_user(c, buffer);
+	rc = kstrtobool_from_user(buffer, count, 0, &traceSMB);
 	if (rc)
 		return rc;
 
-	rc = strtobool(&c, &bv);
-	if (rc)
-		return rc;
-
-	traceSMB = bv;
-
 	return count;
 }
 
@@ -622,7 +596,7 @@ static ssize_t cifs_security_flags_proc_
 	int rc;
 	unsigned int flags;
 	char flags_string[12];
-	char c;
+	char c[2] = { '\0' };
 	bool bv;
 
 	if ((count < 1) || (count > 11))
@@ -635,11 +609,11 @@ static ssize_t cifs_security_flags_proc_
 
 	if (count < 3) {
 		/* single char or single char followed by null */
-		c = flags_string[0];
-		if (strtobool(&c, &bv) == 0) {
+		c[0] = flags_string[0];
+		if (strtobool(c, &bv) == 0) {
 			global_secflags = bv ? CIFSSEC_MAX : CIFSSEC_DEF;
 			return count;
-		} else if (!isdigit(c)) {
+		} else if (!isdigit(c[0])) {
 			cifs_dbg(VFS, "Invalid SecurityFlags: %s\n",
 					flags_string);
 			return -EINVAL;
diff -puN fs/cifs/cifs_debug.h~lib-update-single-char-callers-of-strtobool fs/cifs/cifs_debug.h
--- a/fs/cifs/cifs_debug.h~lib-update-single-char-callers-of-strtobool
+++ a/fs/cifs/cifs_debug.h
@@ -25,7 +25,7 @@
 void cifs_dump_mem(char *label, void *data, int length);
 void cifs_dump_detail(void *);
 void cifs_dump_mids(struct TCP_Server_Info *);
-extern int traceSMB;		/* flag which enables the function below */
+extern bool traceSMB;		/* flag which enables the function below */
 void dump_smb(void *, int);
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
diff -puN fs/cifs/cifsfs.c~lib-update-single-char-callers-of-strtobool fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~lib-update-single-char-callers-of-strtobool
+++ a/fs/cifs/cifsfs.c
@@ -54,10 +54,10 @@
 #endif
 
 int cifsFYI = 0;
-int traceSMB = 0;
+bool traceSMB;
 bool enable_oplocks = true;
-unsigned int linuxExtEnabled = 1;
-unsigned int lookupCacheEnabled = 1;
+bool linuxExtEnabled = true;
+bool lookupCacheEnabled = true;
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
diff -puN fs/cifs/cifsglob.h~lib-update-single-char-callers-of-strtobool fs/cifs/cifsglob.h
--- a/fs/cifs/cifsglob.h~lib-update-single-char-callers-of-strtobool
+++ a/fs/cifs/cifsglob.h
@@ -1596,11 +1596,11 @@ GLOBAL_EXTERN atomic_t midCount;
 
 /* Misc globals */
 GLOBAL_EXTERN bool enable_oplocks; /* enable or disable oplocks */
-GLOBAL_EXTERN unsigned int lookupCacheEnabled;
+GLOBAL_EXTERN bool lookupCacheEnabled;
 GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
 GLOBAL_EXTERN unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
-GLOBAL_EXTERN unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
+GLOBAL_EXTERN bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-add-on-off-support-to-kstrtobool.patch
param-convert-some-on-off-users-to-strtobool.patch


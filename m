From: akpm@linux-foundation.org
Subject: + ipc-initialize-structure-memory-to-zero-for-compat-functions.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:51:27 -0700
Message-ID: <201010072251.o97MpR6P029138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab0JGWvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, arnd@arndb.de, manfred@colorfullife.com


The patch titled
     ipc: initialize structure memory to zero for compat functions
has been added to the -mm tree.  Its filename is
     ipc-initialize-structure-memory-to-zero-for-compat-functions.patch

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
Subject: ipc: initialize structure memory to zero for compat functions
From: Dan Rosenberg <drosenberg@vsecurity.com>

This takes care of leaking uninitialized kernel stack memory to
userspace from non-zeroed fields in structs in compat ipc functions.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c    |    6 ++++++
 ipc/compat_mq.c |    5 +++++
 2 files changed, 11 insertions(+)

diff -puN ipc/compat.c~ipc-initialize-structure-memory-to-zero-for-compat-functions ipc/compat.c
--- a/ipc/compat.c~ipc-initialize-structure-memory-to-zero-for-compat-functions
+++ a/ipc/compat.c
@@ -241,6 +241,8 @@ long compat_sys_semctl(int first, int se
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
+	memset(&s64, 0, sizeof(s64));
+
 	if (!uptr)
 		return -EINVAL;
 	if (get_user(pad, (u32 __user *) uptr))
@@ -421,6 +423,8 @@ long compat_sys_msgctl(int first, int se
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
+	memset(&m64, 0, sizeof(m64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_INFO:
 	case IPC_RMID:
@@ -594,6 +598,8 @@ long compat_sys_shmctl(int first, int se
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
+	memset(&s64, 0, sizeof(s64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
 	case SHM_LOCK:
diff -puN ipc/compat_mq.c~ipc-initialize-structure-memory-to-zero-for-compat-functions ipc/compat_mq.c
--- a/ipc/compat_mq.c~ipc-initialize-structure-memory-to-zero-for-compat-functions
+++ a/ipc/compat_mq.c
@@ -53,6 +53,9 @@ asmlinkage long compat_sys_mq_open(const
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
 		struct mq_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -127,6 +130,8 @@ asmlinkage long compat_sys_mq_getsetattr
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 
+	memset(&mqstat, 0, sizeof(mqstat));
+
 	if (u_mqstat) {
 		if (get_compat_mq_attr(&mqstat, u_mqstat) ||
 		    copy_to_user(p, &mqstat, sizeof(mqstat)))
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
ipc-initialize-structure-memory-to-zero-for-compat-functions.patch


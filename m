From: akpm@linux-foundation.org
Subject: - cgroup-api-files-add-res_counter_read_u64.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:13 -0700
Message-ID: <200804300542.m3U5gDju029126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbYD3Fnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: add res_counter_read_u64()
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-add-res_counter_read_u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: add res_counter_read_u64()
From: Paul Menage <menage@google.com>

Adds a function for returning the value of a resource counter member, in a
form suitable for use in a cgroup read_u64 control file method.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    5 ++++-
 kernel/res_counter.c        |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~cgroup-api-files-add-res_counter_read_u64 include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroup-api-files-add-res_counter_read_u64
+++ a/include/linux/res_counter.h
@@ -39,8 +39,9 @@ struct res_counter {
 	spinlock_t lock;
 };
 
-/*
+/**
  * Helpers to interact with userspace
+ * res_counter_read_u64() - returns the value of the specified member.
  * res_counter_read/_write - put/get the specified fields from the
  * res_counter struct to/from the user
  *
@@ -51,6 +52,8 @@ struct res_counter {
  * @pos:     and the offset.
  */
 
+u64 res_counter_read_u64(struct res_counter *counter, int member);
+
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
diff -puN kernel/res_counter.c~cgroup-api-files-add-res_counter_read_u64 kernel/res_counter.c
--- a/kernel/res_counter.c~cgroup-api-files-add-res_counter_read_u64
+++ a/kernel/res_counter.c
@@ -93,6 +93,11 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	return *res_counter_member(counter, member);
+}
+
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *userbuf, size_t nbytes, loff_t *pos,
 		int (*write_strategy)(char *st_buf, unsigned long long *val))
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch


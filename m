From: akpm@osdl.org
Subject: + sysctl_ms_jiffies-fix-oldlen-semantics.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:24:31 -0800
Message-ID: <200612122124.kBCLOVCn016181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbWLLVYf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:24:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ebiederm@xmission.com


The patch titled
     sysctl_{,ms_}jiffies: fix oldlen semantics
has been added to the -mm tree.  Its filename is
     sysctl_ms_jiffies-fix-oldlen-semantics.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl_{,ms_}jiffies: fix oldlen semantics
From: Alexey Dobriyan <adobriyan@openvz.org>

currently it's
1) if *oldlenp == 0,
	don't writeback anything

2) if *oldlenp >= table->maxlen,
	don't writeback more than table->maxlen bytes and rewrite *oldlenp
	don't look at underlying type granularity

3) if 0 < *oldlenp < table->maxlen,
		*cough*
	string sysctls don't writeback more than *oldlenp bytes.
	OK, that's because sizeof(char) == 1

	int sysctls writeback anything in (0, table->maxlen] range
	Though accept integers divisible by sizeof(int) for writing.

sysctl_jiffies and sysctl_ms_jiffies don't writeback anything but
sizeof(int), which violates 1) and 2).

So, make sysctl_jiffies and sysctl_ms_jiffies accept
a) *oldlenp == 0, not doing writeback
b) *oldlenp >= sizeof(int), writing one integer.

-EINVAL still returned for *oldlenp == 1, 2, 3.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   44 ++++++++++++++++++++++++++++----------------
 1 files changed, 28 insertions(+), 16 deletions(-)

diff -puN kernel/sysctl.c~sysctl_ms_jiffies-fix-oldlen-semantics kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl_ms_jiffies-fix-oldlen-semantics
+++ a/kernel/sysctl.c
@@ -2554,17 +2554,23 @@ int sysctl_jiffies(ctl_table *table, int
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
-	if (oldval) {
+	if (oldval && oldlenp) {
 		size_t olen;
-		if (oldlenp) { 
-			if (get_user(olen, oldlenp))
+
+		if (get_user(olen, oldlenp))
+			return -EFAULT;
+		if (olen) {
+			int val;
+
+			if (olen < sizeof(int))
+				return -EINVAL;
+
+			val = *(int *)(table->data) / HZ;
+			if (put_user(val, (int __user *)oldval))
+				return -EFAULT;
+			if (put_user(sizeof(int), oldlenp))
 				return -EFAULT;
-			if (olen!=sizeof(int))
-				return -EINVAL; 
 		}
-		if (put_user(*(int *)(table->data)/HZ, (int __user *)oldval) ||
-		    (oldlenp && put_user(sizeof(int),oldlenp)))
-			return -EFAULT;
 	}
 	if (newval && newlen) { 
 		int new;
@@ -2582,17 +2588,23 @@ int sysctl_ms_jiffies(ctl_table *table, 
 		void __user *oldval, size_t __user *oldlenp,
 		void __user *newval, size_t newlen)
 {
-	if (oldval) {
+	if (oldval && oldlenp) {
 		size_t olen;
-		if (oldlenp) { 
-			if (get_user(olen, oldlenp))
+
+		if (get_user(olen, oldlenp))
+			return -EFAULT;
+		if (olen) {
+			int val;
+
+			if (olen < sizeof(int))
+				return -EINVAL;
+
+			val = jiffies_to_msecs(*(int *)(table->data));
+			if (put_user(val, (int __user *)oldval))
+				return -EFAULT;
+			if (put_user(sizeof(int), oldlenp))
 				return -EFAULT;
-			if (olen!=sizeof(int))
-				return -EINVAL; 
 		}
-		if (put_user(jiffies_to_msecs(*(int *)(table->data)), (int __user *)oldval) ||
-		    (oldlenp && put_user(sizeof(int),oldlenp)))
-			return -EFAULT;
 	}
 	if (newval && newlen) { 
 		int new;
_

Patches currently in -mm which might be from adobriyan@openvz.org are

origin.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch


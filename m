From: akpm@linux-foundation.org
Subject: + init-resolve-shadow-warnings.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:48:51 -0700
Message-ID: <5400d923.96kPGiqL1ACRIZEY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2Tsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/initramfs.c: resolve shadow warnings
has been added to the -mm tree.  Its filename is
     init-resolve-shadow-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-resolve-shadow-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-resolve-shadow-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rustad <mark.d.rustad@intel.com>
Subject: init/initramfs.c: resolve shadow warnings

Resolve shadow warnings that are produced in W=2 builds by renaming a
global with a too-generic name and renaming a formal parameter.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN init/initramfs.c~init-resolve-shadow-warnings init/initramfs.c
--- a/init/initramfs.c~init-resolve-shadow-warnings
+++ a/init/initramfs.c
@@ -197,14 +197,14 @@ static __initdata enum state {
 } state, next_state;
 
 static __initdata char *victim;
-static unsigned long count __initdata;
+static unsigned long byte_count __initdata;
 static __initdata loff_t this_header, next_header;
 
 static inline void __init eat(unsigned n)
 {
 	victim += n;
 	this_header += n;
-	count -= n;
+	byte_count -= n;
 }
 
 static __initdata char *vcollected;
@@ -214,7 +214,7 @@ static __initdata char *collect;
 
 static void __init read_into(char *buf, unsigned size, enum state next)
 {
-	if (count >= size) {
+	if (byte_count >= size) {
 		collected = victim;
 		eat(size);
 		state = next;
@@ -237,8 +237,8 @@ static int __init do_start(void)
 static int __init do_collect(void)
 {
 	unsigned long n = remains;
-	if (count < n)
-		n = count;
+	if (byte_count < n)
+		n = byte_count;
 	memcpy(collect, victim, n);
 	eat(n);
 	collect += n;
@@ -280,8 +280,8 @@ static int __init do_header(void)
 
 static int __init do_skip(void)
 {
-	if (this_header + count < next_header) {
-		eat(count);
+	if (this_header + byte_count < next_header) {
+		eat(byte_count);
 		return 1;
 	} else {
 		eat(next_header - this_header);
@@ -292,9 +292,9 @@ static int __init do_skip(void)
 
 static int __init do_reset(void)
 {
-	while(count && *victim == '\0')
+	while(byte_count && *victim == '\0')
 		eat(1);
-	if (count && (this_header & 3))
+	if (byte_count && (this_header & 3))
 		error("broken padding");
 	return 1;
 }
@@ -309,11 +309,11 @@ static int __init maybe_link(void)
 	return 0;
 }
 
-static void __init clean_path(char *path, umode_t mode)
+static void __init clean_path(char *path, umode_t fmode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!sys_newlstat(path, &st) && (st.st_mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
 			sys_rmdir(path);
 		else
@@ -368,7 +368,7 @@ static int __init do_name(void)
 
 static int __init do_copy(void)
 {
-	if (count >= body_len) {
+	if (byte_count >= body_len) {
 		if (xwrite(wfd, victim, body_len) != body_len)
 			error("write error");
 		sys_close(wfd);
@@ -378,10 +378,10 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		if (xwrite(wfd, victim, count) != count)
+		if (xwrite(wfd, victim, byte_count) != byte_count)
 			error("write error");
-		body_len -= count;
-		eat(count);
+		body_len -= byte_count;
+		eat(byte_count);
 		return 1;
 	}
 }
@@ -411,12 +411,12 @@ static __initdata int (*actions[])(void)
 
 static long __init write_buffer(char *buf, unsigned long len)
 {
-	count = len;
+	byte_count = len;
 	victim = buf;
 
 	while (!actions[state]())
 		;
-	return len - count;
+	return len - byte_count;
 }
 
 static long __init flush_buffer(void *bufv, unsigned long len)
_

Patches currently in -mm which might be from mark.d.rustad@intel.com are

init-resolve-shadow-warnings.patch


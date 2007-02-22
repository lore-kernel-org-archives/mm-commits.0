From: akpm@linux-foundation.org
Subject: + parisc-sync-compat-getdents-on-ia64-and-parisc.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:03:50 -0800
Message-ID: <200702220103.l1M13o6W032273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXBVBEB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:04:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aandreev@openvz.org, adobriyan@openvz.org, grundler@google.com, kyle@mcmartin.ca, willy@debian.org


The patch titled
     parisc: sync compat getdents
has been added to the -mm tree.  Its filename is
     parisc-sync-compat-getdents-on-ia64-and-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parisc: sync compat getdents
From: Alexandr Andreev <aandreev@openvz.org>

Add VERIFY_WRITE check in the beginning like compat_sys_getdents() EFAULT on
parisc if put_user() fails.

Signed-off-by: Alexandr Andreev <aandreev@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc32.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~parisc-sync-compat-getdents-on-ia64-and-parisc arch/ia64/ia32/sys_ia32.c
diff -puN arch/parisc/kernel/sys_parisc32.c~parisc-sync-compat-getdents-on-ia64-and-parisc arch/parisc/kernel/sys_parisc32.c
--- a/arch/parisc/kernel/sys_parisc32.c~parisc-sync-compat-getdents-on-ia64-and-parisc
+++ a/arch/parisc/kernel/sys_parisc32.c
@@ -350,6 +350,10 @@ sys32_getdents (unsigned int fd, void __
 	struct getdents32_callback buf;
 	int error;
 
+	error = -EFAULT;
+	if (!access_ok(VERIFY_WRITE, dirent, count))
+		goto out;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -366,8 +370,10 @@ sys32_getdents (unsigned int fd, void __
 	error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
-		put_user(file->f_pos, &lastdirent->d_off);
-		error = count - buf.count;
+		if (put_user(file->f_pos, &lastdirent->d_off))
+			error = -EFAULT;
+		else
+			error = count - buf.count;
 	}
 
 out_putf:
_

Patches currently in -mm which might be from aandreev@openvz.org are

ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch

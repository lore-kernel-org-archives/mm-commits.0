From: akpm@linux-foundation.org
Subject: [merged] add-error-checks-to-initramfs.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:41:28 -0700
Message-ID: <53ea6de8.3X4+Uv2AK7trbnKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58832 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaHLTl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:29 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1307856yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.engraf@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: add write error checks
has been removed from the -mm tree.  Its filename was
     add-error-checks-to-initramfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Engraf <david.engraf@sysgo.com>
Subject: initramfs: add write error checks

On a system with low memory extracting the initramfs may fail.  If this
happens the user gets "Failed to execute /init" instead of an initramfs
error.

Check return value of sys_write and call error() when the write was
incomplete or failed.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN init/initramfs.c~add-error-checks-to-initramfs init/initramfs.c
--- a/init/initramfs.c~add-error-checks-to-initramfs
+++ a/init/initramfs.c
@@ -369,7 +369,8 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		xwrite(wfd, victim, body_len);
+		if (xwrite(wfd, victim, body_len) != body_len)
+			error("write error");
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
@@ -377,7 +378,8 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		xwrite(wfd, victim, count);
+		if (xwrite(wfd, victim, count) != count)
+			error("write error");
 		body_len -= count;
 		eat(count);
 		return 1;
_

Patches currently in -mm which might be from david.engraf@sysgo.com are

origin.patch


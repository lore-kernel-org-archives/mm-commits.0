From: akpm@linux-foundation.org
Subject: + add-error-checks-to-initramfs.patch added to -mm tree
Date: Mon, 21 Jul 2014 15:46:22 -0700
Message-ID: <53cd983e.ZNXg8CYV4LCZIM4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:58117 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGUWqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 18:46:24 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so356351ykq.0
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 15:46:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.engraf@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: add write error checks
has been added to the -mm tree.  Its filename is
     add-error-checks-to-initramfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-error-checks-to-initramfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-error-checks-to-initramfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

add-error-checks-to-initramfs.patch


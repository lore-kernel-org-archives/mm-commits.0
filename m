From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-msg-fix-message-length-check-for-negative-values-fix.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:47:05 -0800
Message-ID: <5282afe9./GKQccAN4Lk2C7+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KLWrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, spender@grsecurity.net, pageexec@freemail.hu, minipli@googlemail.com, manfred@colorfullife.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-msg-fix-message-length-check-for-negative-values-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,manfred@colorfullife.com,minipli@googlemail.com,pageexec@freemail.hu,spender@grsecurity.net,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:47:04 -0800


The patch titled
     Subject: ipc-msg-fix-message-length-check-for-negative-values-fix
has been removed from the -mm tree.  Its filename was
     ipc-msg-fix-message-length-check-for-negative-values-fix.patch

This patch was dropped because it was folded into ipc-msg-fix-message-length-check-for-negative-values.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-msg-fix-message-length-check-for-negative-values-fix

fix i386 min() warnings

ipc/msgutil.c: In function 'alloc_msg':
ipc/msgutil.c:54: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:66: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'load_msg':
ipc/msgutil.c:94: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:101: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'copy_msg':
ipc/msgutil.c:127: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:135: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'store_msg':
ipc/msgutil.c:155: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:162: warning: comparison of distinct pointer types lacks a cast

Cc: Brad Spengler <spender@grsecurity.net>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Pax Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values-fix ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values-fix
+++ a/ipc/msgutil.c
@@ -41,8 +41,8 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	((size_t)PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	((size_t)PAGE_SIZE-sizeof(struct msg_msgseg))
 
 
 static struct msg_msg *alloc_msg(size_t len)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
drivers-rtc-rtc-as3722-add-rtc-driver.patch
fs-hfs-btreeh-remove-duplicate-defines.patch
gcov-add-support-for-gcc-47-gcov-format.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values.patch


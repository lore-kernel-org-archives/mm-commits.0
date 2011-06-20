From: akpm@linux-foundation.org
Subject: + include-linux-compath-declare-compat_sys_sendmmsg.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:31:03 -0700
Message-ID: <201106202331.p5KNV3M8029848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab1FTXbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, arnd@arndb.de


The patch titled
     include/linux/compat.h: declare compat_sys_sendmmsg()
has been added to the -mm tree.  Its filename is
     include-linux-compath-declare-compat_sys_sendmmsg.patch

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
Subject: include/linux/compat.h: declare compat_sys_sendmmsg()
From: Chris Metcalf <cmetcalf@tilera.com>

This is required for tilegx to be able to use the compat unistd.h header
where compat_sys_sendmmsg() is now mentioned.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/compat.h~include-linux-compath-declare-compat_sys_sendmmsg include/linux/compat.h
--- a/include/linux/compat.h~include-linux-compath-declare-compat_sys_sendmmsg
+++ a/include/linux/compat.h
@@ -467,6 +467,8 @@ asmlinkage long compat_sys_setsockopt(in
 				      char __user *optval, unsigned int optlen);
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg,
 				   unsigned flags);
+asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags);
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg,
 				   unsigned int flags);
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len,
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

include-linux-compath-declare-compat_sys_sendmmsg.patch
linux-next.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
consolidate-config_debug_strict_user_copy_checks.patch


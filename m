From: akpm@linux-foundation.org
Subject: [merged]
 firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:51 -0700
Message-ID: <56f2d523.AAWZMWz9bZj3LS6j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbcCWRkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: use in_compat_syscall to check ioctl compatness
has been removed from the -mm tree.  Its filename was
     firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: firewire: use in_compat_syscall to check ioctl compatness

Firewire was using is_compat_task to check whether it was in a
compat ioctl or a non-compat ioctl.  Use is_compat_syscall instead
so it works properly on all architectures.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firewire/core-cdev.c~firewire-use-in_compat_syscall-to-check-ioctl-compatness drivers/firewire/core-cdev.c
--- a/drivers/firewire/core-cdev.c~firewire-use-in_compat_syscall-to-check-ioctl-compatness
+++ a/drivers/firewire/core-cdev.c
@@ -221,7 +221,7 @@ struct inbound_phy_packet_event {
 #ifdef CONFIG_COMPAT
 static void __user *u64_to_uptr(u64 value)
 {
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return compat_ptr(value);
 	else
 		return (void __user *)(unsigned long)value;
@@ -229,7 +229,7 @@ static void __user *u64_to_uptr(u64 valu
 
 static u64 uptr_to_u64(void __user *ptr)
 {
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return ptr_to_compat(ptr);
 	else
 		return (u64)(unsigned long)ptr;
_

Patches currently in -mm which might be from luto@kernel.org are



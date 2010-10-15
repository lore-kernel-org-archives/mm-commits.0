From: akpm@linux-foundation.org
Subject: + typesh-define-__aligned_u64-and-expose-to-userspace.patch added to -mm tree
Date: Thu, 14 Oct 2010 21:33:56 -0700
Message-ID: <201010150432.o9F4WeRw006060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab0JOEdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Oct 2010 00:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, agruen@suse.de, andi@firstfloor.org, davem@davemloft.net, jengelh@medozas.de


The patch titled
     types.h: define __aligned_u64 and expose to userspace
has been added to the -mm tree.  Its filename is
     typesh-define-__aligned_u64-and-expose-to-userspace.patch

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
Subject: types.h: define __aligned_u64 and expose to userspace
From: Eric Paris <eparis@redhat.com>

We currently have a kernel internal type called aligned_u64 which aligns
__u64's on 8 bytes boundaries even on systems which would normally align
them on 4 byte boundaries.  This patch creates a new type __aligned_u64
which does the same thing but which is exposed to userspace rather than
being kernel internal.

[akpm: merge early as both the net and audit trees want this]

Based-on-patch-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: David Miller <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/types.h~typesh-define-__aligned_u64-and-expose-to-userspace include/linux/types.h
--- a/include/linux/types.h~typesh-define-__aligned_u64-and-expose-to-userspace
+++ a/include/linux/types.h
@@ -178,6 +178,11 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
+/* this is a special 64bit data type that is 8-byte aligned */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
_

Patches currently in -mm which might be from eparis@redhat.com are

origin.patch
typesh-define-__aligned_u64-and-expose-to-userspace.patch
linux-next.patch
audit-call-tty_audit_push_task-outside-preempt-disabled.patch
audit-do-not-send-uninitialized-data-for-audit_tty_get.patch
audit-use-rcu-for-task-lookup-protection.patch
audit-add-support-to-match-lsm-labels-on-user-audit-messages.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
fsnotify-remove-alignment-padding-from-fsnotify_mark-on-64-bit-builds.patch


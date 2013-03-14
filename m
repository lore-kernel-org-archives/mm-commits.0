From: akpm@linux-foundation.org
Subject: [merged] uapi-fix-endianness-conditionals-in-linux-raid-md_ph.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:48 -0700
Message-ID: <20130314185248.7997831C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52951 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3CNSwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:49 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so80564vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: fix endianness conditionals in linux/raid/md_p.h
has been removed from the -mm tree.  Its filename was
     uapi-fix-endianness-conditionals-in-linux-raid-md_ph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: fix endianness conditionals in linux/raid/md_p.h

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be
compared against __BYTE_ORDER in preprocessor conditionals where these are
exposed to userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for
"defined(__XXX_ENDIAN)" rather than comparing against __BYTE_ORDER and
this has incorrectly leaked into the userspace headers.

The definition of struct mdp_superblock_s in linux/raid/md_p.h is wrong in
this way.  Note that userspace will likely interpret the ordering of the
fields incorrectly as the big-endian variant on a little-endian machines -
depending on header inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the ordering of events_hi, events_lo, cp_events_hi and
cp_events_lo in struct mdp_superblock_s / typedef mdp_super_t.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/raid/md_p.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/raid/md_p.h~uapi-fix-endianness-conditionals-in-linux-raid-md_ph include/uapi/linux/raid/md_p.h
--- a/include/uapi/linux/raid/md_p.h~uapi-fix-endianness-conditionals-in-linux-raid-md_ph
+++ a/include/uapi/linux/raid/md_p.h
@@ -145,16 +145,18 @@ typedef struct mdp_superblock_s {
 	__u32 failed_disks;	/*  4 Number of failed disks		      */
 	__u32 spare_disks;	/*  5 Number of spare disks		      */
 	__u32 sb_csum;		/*  6 checksum of the whole superblock        */
-#ifdef __BIG_ENDIAN
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 	__u32 events_hi;	/*  7 high-order of superblock update count   */
 	__u32 events_lo;	/*  8 low-order of superblock update count    */
 	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
 	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
-#else
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 	__u32 events_lo;	/*  7 low-order of superblock update count    */
 	__u32 events_hi;	/*  8 high-order of superblock update count   */
 	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
 	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
+#else
+#error unspecified endianness
 #endif
 	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
 	/* There are only valid for minor_version > 90 */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
debug_locksh-make-warning-more-verbose.patch
mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-remove-free_area_cache.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
mutex-subsystem-synchro-test-module.patch


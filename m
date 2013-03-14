From: akpm@linux-foundation.org
Subject: [merged] uapi-fix-endianness-conditionals-in-linux-accth.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:45 -0700
Message-ID: <20130314185245.7573531C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36286 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3CNSwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:46 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so259266qcr.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: fix endianness conditionals in linux/acct.h
has been removed from the -mm tree.  Its filename was
     uapi-fix-endianness-conditionals-in-linux-accth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: fix endianness conditionals in linux/acct.h

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be
compared against __BYTE_ORDER in preprocessor conditionals where these are
exposed to userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for
"defined(__XXX_ENDIAN)" rather than comparing against __BYTE_ORDER and
this has incorrectly leaked into the userspace headers.

The definition of ACCT_BYTEORDER in linux/acct.h is wrong in this way. 
Note that userspace will likely interpret this incorrectly as the
big-endian variant on little-endian machines - depending on header
inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the value of ACCT_BYTEORDER.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/acct.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/acct.h~uapi-fix-endianness-conditionals-in-linux-accth include/uapi/linux/acct.h
--- a/include/uapi/linux/acct.h~uapi-fix-endianness-conditionals-in-linux-accth
+++ a/include/uapi/linux/acct.h
@@ -107,10 +107,12 @@ struct acct_v3
 #define ACORE		0x08	/* ... dumped core */
 #define AXSIG		0x10	/* ... was killed by a signal */
 
-#ifdef __BIG_ENDIAN
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 #define ACCT_BYTEORDER	0x80	/* accounting file is big endian */
-#else
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 #define ACCT_BYTEORDER	0x00	/* accounting file is little endian */
+#else
+#error unspecified endianness
 #endif
 
 #ifndef __KERNEL__
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


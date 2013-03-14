From: akpm@linux-foundation.org
Subject: [merged] uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:51 -0700
Message-ID: <20130314185251.7C5FA5A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62363 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3CNSww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:52 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so250794vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: fix endianness conditionals in M32R's asm/stat.h
has been removed from the -mm tree.  Its filename was
     uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: fix endianness conditionals in M32R's asm/stat.h

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be
compared against __BYTE_ORDER in preprocessor conditionals where these are
exposed to userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for
"defined(__XXX_ENDIAN)" rather than comparing against __BYTE_ORDER and
this has incorrectly leaked into the userspace headers.

The definition of struct stat64 in M32R's asm/stat.h is wrong in this way.
 Note that userspace will likely interpret the field order incorrectly as
the big-endian variant on little-endian machines - depending on header
inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the ordering of st_blocks and __pad4 in struct stat64.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/uapi/asm/stat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m32r/include/uapi/asm/stat.h~uapi-fix-endianness-conditionals-in-m32rs-asm-stath arch/m32r/include/uapi/asm/stat.h
--- a/arch/m32r/include/uapi/asm/stat.h~uapi-fix-endianness-conditionals-in-m32rs-asm-stath
+++ a/arch/m32r/include/uapi/asm/stat.h
@@ -63,10 +63,10 @@ struct stat64 {
 	long long	st_size;
 	unsigned long	st_blksize;
 
-#if defined(__BIG_ENDIAN)
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 	unsigned long	__pad4;		/* future possible st_blocks high bits */
 	unsigned long	st_blocks;	/* Number 512-byte blocks allocated. */
-#elif defined(__LITTLE_ENDIAN)
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 	unsigned long	st_blocks;	/* Number 512-byte blocks allocated. */
 	unsigned long	__pad4;		/* future possible st_blocks high bits */
 #else
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


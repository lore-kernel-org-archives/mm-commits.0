From: akpm@linux-foundation.org
Subject: + uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:03:06 -0700
Message-ID: <20130312200306.7985731C203@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39831 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3CLUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:03:08 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so28694ves.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:03:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, takata@linux-m32r.org


The patch titled
     Subject: UAPI: fix endianness conditionals in M32R's asm/stat.h
has been added to the -mm tree.  Its filename is
     uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
uapi-fix-endianness-conditionals-in-linux-aio_abih.patch
uapi-fix-endianness-conditionals-in-linux-accth.patch
uapi-fix-endianness-conditionals-in-linux-raid-md_ph.patch
uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch
debug_locksh-make-warning-more-verbose.patch
mm-remove-free_area_cache.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
mutex-subsystem-synchro-test-module.patch


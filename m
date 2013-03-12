From: akpm@linux-foundation.org
Subject: + uapi-fix-endianness-conditionals-in-linux-accth.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:03:02 -0700
Message-ID: <20130312200302.C5AAF31C203@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:48127 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3CLUDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:03:03 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so28945qen.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:03:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     Subject: UAPI: fix endianness conditionals in linux/acct.h
has been added to the -mm tree.  Its filename is
     uapi-fix-endianness-conditionals-in-linux-accth.patch

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
uapi-fix-endianness-conditionals-in-linux-aio_abih.patch
uapi-fix-endianness-conditionals-in-linux-accth.patch
uapi-fix-endianness-conditionals-in-linux-raid-md_ph.patch
uapi-fix-endianness-conditionals-in-m32rs-asm-stath.patch
debug_locksh-make-warning-more-verbose.patch
mm-remove-free_area_cache.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
mutex-subsystem-synchro-test-module.patch


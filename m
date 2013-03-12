From: akpm@linux-foundation.org
Subject: + uapi-fix-endianness-conditionals-in-linux-aio_abih.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:03:00 -0700
Message-ID: <20130312200300.9E6A55A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:53147 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3CLUDB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:03:01 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so28748qea.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:03:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, bcrl@kvack.org, jmoyer@redhat.com


The patch titled
     Subject: UAPI: fix endianness conditionals in linux/aio_abi.h
has been added to the -mm tree.  Its filename is
     uapi-fix-endianness-conditionals-in-linux-aio_abih.patch

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
Subject: UAPI: fix endianness conditionals in linux/aio_abi.h

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be
compared against __BYTE_ORDER in preprocessor conditionals where these are
exposed to userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for
"defined(__XXX_ENDIAN)" rather than comparing against __BYTE_ORDER and
this has incorrectly leaked into the userspace headers.

The definition of PADDED() in linux/aio_abi.h is wrong in this way.  Note
that userspace will likely interpret this and thus the order of fields in
struct iocb incorrectly as the little-endian variant on big-endian
machines - depending on header inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the ordering of aio_key and aio_reserved1 in struct iocb.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/aio_abi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/aio_abi.h~uapi-fix-endianness-conditionals-in-linux-aio_abih include/uapi/linux/aio_abi.h
--- a/include/uapi/linux/aio_abi.h~uapi-fix-endianness-conditionals-in-linux-aio_abih
+++ a/include/uapi/linux/aio_abi.h
@@ -62,9 +62,9 @@ struct io_event {
 	__s64		res2;		/* secondary result */
 };
 
-#if defined(__LITTLE_ENDIAN)
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 #define PADDED(x,y)	x, y
-#elif defined(__BIG_ENDIAN)
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 #define PADDED(x,y)	y, x
 #else
 #error edit for your odd byteorder.
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


From: akpm@linux-foundation.org
Subject: [merged] uapi-fix-endianness-conditionals-in-linux-aio_abih.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:42 -0700
Message-ID: <20130314185242.7C7F131C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42350 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3CNSwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:43 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so258742ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: fix endianness conditionals in linux/aio_abi.h
has been removed from the -mm tree.  Its filename was
     uapi-fix-endianness-conditionals-in-linux-aio_abih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


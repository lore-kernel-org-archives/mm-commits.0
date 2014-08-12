From: akpm@linux-foundation.org
Subject: [merged]
 some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:00 -0700
Message-ID: <53ea6dcc.MfRbqLgKdt7fzIc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44031 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaHLTlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:01 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1312893qaq.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry@linux.vnet.ibm.com, avagin@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/ptrace/peeksiginfo.c: add PAGE_SIZE definition
has been removed from the -mm tree.  Its filename was
     some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Fauck <thierry@linux.vnet.ibm.com>
Subject: tools/testing/selftests/ptrace/peeksiginfo.c: add PAGE_SIZE definition

On IBM powerpc where multiple page size value are supported, current ppc64
and ppc64el distro don't define the PAGE_SIZE variable in /usr/include as
this is a dynamic value retrieved by the getpagesize() or sysconf()
defined in unistd.h.  The PAGE_SIZE variable sounds defined when only one
value is supported by the kernel.

As such, when the PAGE_SIZE definition doesn't exist system should
retrieve the dynamic value.

Signed-off-by: Thierry Fauck <thierry@linux.vnet.ibm.com>
Cc: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ptrace/peeksiginfo.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN tools/testing/selftests/ptrace/peeksiginfo.c~some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf tools/testing/selftests/ptrace/peeksiginfo.c
--- a/tools/testing/selftests/ptrace/peeksiginfo.c~some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf
+++ a/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -31,6 +31,10 @@ static int sys_ptrace(int request, pid_t
 #define TEST_SICODE_PRIV	-1
 #define TEST_SICODE_SHARE	-2
 
+#ifndef PAGE_SIZE
+#define PAGE_SIZE sysconf(_SC_PAGESIZE)
+#endif
+
 #define err(fmt, ...)						\
 		fprintf(stderr,					\
 			"Error (%s:%d): " fmt,			\
_

Patches currently in -mm which might be from thierry@linux.vnet.ibm.com are

origin.patch


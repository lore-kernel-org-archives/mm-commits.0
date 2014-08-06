From: akpm@linux-foundation.org
Subject: +
 some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch added to -mm tree
Date: Wed, 06 Aug 2014 13:06:53 -0700
Message-ID: <53e28add.O8fS3myAtbSB8tki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45236 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaHFUGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:06:54 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so779306pdj.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:06:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry@linux.vnet.ibm.com, avagin@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/ptrace/peeksiginfo.c: add PAGE_SIZE definition
has been added to the -mm tree.  Its filename is
     some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Fauck <thierry@linux.vnet.ibm.com>
Subject: tools/testing/selftests/ptrace/peeksiginfo.c: add PAGE_SIZE definition

Some systems have a dynamic PAGE_SIZE value and do not add a definition
for PAGE_SIZE.  This value will have to be retrieved using getpagesize()
or sysconf().

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

some-systems-have-a-dynamic-page_size-value-and-do-not-add-a-definition-for-page_size-this-value-will-have-to-be-retrieved-using-getpagesize-or-sysconf.patch


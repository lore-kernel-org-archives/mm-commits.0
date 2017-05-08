From: akpm@linux-foundation.org
Subject: + gcov-support-gcc-71.patch added to -mm tree
Date: Mon, 08 May 2017 14:37:13 -0700
Message-ID: <5910e509.bcDY7DVuoRn4ani/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdEHVhO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 17:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mliska@suse.cz, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: support GCC 7.1
has been added to the -mm tree.  Its filename is
     gcov-support-gcc-71.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-support-gcc-71.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-support-gcc-71.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Liska <mliska@suse.cz>
Subject: gcov: support GCC 7.1

Starting from GCC 7.1, __gcov_exit is a new symbol expected
to be implemented in a profiling runtime.

Link: http://lkml.kernel.org/r/8c4084fa-3885-29fe-5fc4-0d4ca199c785@suse.cz
Signed-off-by: Martin Liska <mliska@suse.cz>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/gcov/base.c~gcov-support-gcc-71 kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-support-gcc-71
+++ a/kernel/gcov/base.c
@@ -98,6 +98,12 @@ void __gcov_merge_icall_topn(gcov_type *
 }
 EXPORT_SYMBOL(__gcov_merge_icall_topn);
 
+void __gcov_exit (void)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_exit);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
_

Patches currently in -mm which might be from mliska@suse.cz are

gcov-support-gcc-71.patch
gcov-support-gcc-71-v2.patch


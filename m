From: akpm@linux-foundation.org
Subject: + markers-add-an-if0-to-__mark_check_format.patch added to -mm tree
Date: Wed, 27 Feb 2008 21:22:15 -0800
Message-ID: <200802280522.m1S5MFq1017272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbYB1FXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 00:23:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, fche@redhat.com, jan.kiszka@siemens.com


The patch titled
     markers: add an if(0) to __mark_check_format()
has been added to the -mm tree.  Its filename is
     markers-add-an-if0-to-__mark_check_format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: add an if(0) to __mark_check_format()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Wrap __mark_check_format() into an if(0) to make sure that parameters such as

trace_mark(mm_page_alloc, "order %u pfn %lu", order, page?page_to_pfn(page):0);

(where page_to_pfn() has side-effects) won't generate code because of the
__mark_check_format().

Thanks to Jan Kiszka for reporting this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/marker.h~markers-add-an-if0-to-__mark_check_format include/linux/marker.h
--- a/include/linux/marker.h~markers-add-an-if0-to-__mark_check_format
+++ a/include/linux/marker.h
@@ -104,10 +104,16 @@ static inline void marker_update_probe_r
 #define MARK_NOARGS " "
 
 /* To be used for string format validity checking with gcc */
-static inline void __printf(1, 2) __mark_check_format(const char *fmt, ...)
+static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
 {
 }
 
+#define __mark_check_format(format, args...)				\
+	do {								\
+		if (0)							\
+			___mark_check_format(format, ## args);		\
+	} while (0)
+
 extern marker_probe_func __mark_empty_function;
 
 extern void marker_probe_cb(const struct marker *mdata,
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

git-x86.patch
git-sched.patch
kprobes-indicate-kretprobe-support-in-kconfig.patch
kprobes-move-kprobe-examples-to-samples.patch
markers-dont-risk-null-deref-in-marker.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
markers-add-an-if0-to-__mark_check_format.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
make-marker_debug-static.patch

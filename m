From: akpm@linux-foundation.org
Subject: - markers-add-an-if0-to-__mark_check_format.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:04 -0800
Message-ID: <200803050745.m257j4Sg021565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759107AbYCEHwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, fche@redhat.com, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     markers: add an if(0) to __mark_check_format()
has been removed from the -mm tree.  Its filename was
     markers-add-an-if0-to-__mark_check_format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
make-marker_debug-static.patch


From: akpm@linux-foundation.org
Subject: - readahead-min_ra_pages-max_ra_pages-macros.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:06 -0700
Message-ID: <200707192001.l6JK162k019510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932228AbXGSUad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
has been removed from the -mm tree.  Its filename was
     readahead-min_ra_pages-max_ra_pages-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Define two convenient macros for read-ahead:
	- MAX_RA_PAGES: rounded down counterpart of VM_MAX_READAHEAD
	- MIN_RA_PAGES: rounded _up_ counterpart of VM_MIN_READAHEAD

Note that the rounded up MIN_RA_PAGES will work flawlessly with _large_
page sizes like 64k.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/readahead.c~readahead-min_ra_pages-max_ra_pages-macros mm/readahead.c
--- a/mm/readahead.c~readahead-min_ra_pages-max_ra_pages-macros
+++ a/mm/readahead.c
@@ -21,8 +21,16 @@ void default_unplug_io_fn(struct backing
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
+/*
+ * Convienent macros for min/max read-ahead pages.
+ * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
+ * The latter is necessary for systems with large page size(i.e. 64k).
+ */
+#define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
+#define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
+
 struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE,
+	.ra_pages	= MAX_RA_PAGES,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,
@@ -51,7 +59,7 @@ static inline unsigned long get_max_read
 
 static inline unsigned long get_min_readahead(struct file_ra_state *ra)
 {
-	return (VM_MIN_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	return MIN_RA_PAGES;
 }
 
 static inline void reset_ahead_window(struct file_ra_state *ra)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch

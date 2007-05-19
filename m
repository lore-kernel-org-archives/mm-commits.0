From: akpm@linux-foundation.org
Subject: + readahead-min_ra_pages-max_ra_pages-macros.patch added to -mm tree
Date: Fri, 18 May 2007 23:28:45 -0700
Message-ID: <200705190628.l4J6Siqt031258@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXESGa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, slpratt@austin.ibm.com


The patch titled
     readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
has been added to the -mm tree.  Its filename is
     readahead-min_ra_pages-max_ra_pages-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch

From: akpm@linux-foundation.org
Subject: [merged] mm-remove-likely-from-grab_cache_page_write_begin.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:50 -0800
Message-ID: <201101142248.p0EMmeVF005222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srostedt@redhat.com, npiggin@kernel.dk, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     mm: remove likely() from grab_cache_page_write_begin()
has been removed from the -mm tree.  Its filename was
     mm-remove-likely-from-grab_cache_page_write_begin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove likely() from grab_cache_page_write_begin()
From: Steven Rostedt <srostedt@redhat.com>

Running the annotated branch profiler on a box doing average work
(firefox, evolution, xchat, distcc farm), the likely() used in
grab_cache_page_write_begin() was incorrect most of the time:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
 1924262 71332401  97 grab_cache_page_write_begin    filemap.c           2206

Adding a trace_printk() and running the function tracer limited to
just this function I can see:

        gconfd-2-2696  [000]  4467.268935: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=7
        gconfd-2-2696  [000]  4467.268946: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268947: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=8
        gconfd-2-2696  [000]  4467.268959: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268960: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=9
        gconfd-2-2696  [000]  4467.268972: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268973: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=10
        gconfd-2-2696  [000]  4467.268991: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268992: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=11
        gconfd-2-2696  [000]  4467.269005: grab_cache_page_write_begin <-ext3_write_begin

Which shows that a lot of calls from ext3_write_begin will result in the
page returned by "find_lock_page" will be NULL.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-remove-likely-from-grab_cache_page_write_begin mm/filemap.c
--- a/mm/filemap.c~mm-remove-likely-from-grab_cache_page_write_begin
+++ a/mm/filemap.c
@@ -2227,7 +2227,7 @@ struct page *grab_cache_page_write_begin
 		gfp_notmask = __GFP_FS;
 repeat:
 	page = find_lock_page(mapping, index);
-	if (likely(page))
+	if (page)
 		return page;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
_

Patches currently in -mm which might be from srostedt@redhat.com are

origin.patch
linux-next.patch
vfs-remove-unlikely-from-fput_light.patch
vfs-remove-unlikely-from-fget_light.patch


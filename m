From: akpm@linux-foundation.org
Subject: + mm-remove-likely-from-grab_cache_page_write_begin.patch added to -mm tree
Date: Tue, 14 Dec 2010 12:24:40 -0800
Message-ID: <201012142024.oBEKOeBa007588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759914Ab0LNUYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 15:24:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srostedt@redhat.com, npiggin@kernel.dk, rostedt@goodmis.org


The patch titled
     mm: remove likely() from grab_cache_page_write_begin()
has been added to the -mm tree.  Its filename is
     mm-remove-likely-from-grab_cache_page_write_begin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2241,7 +2241,7 @@ struct page *grab_cache_page_write_begin
 		gfp_notmask = __GFP_FS;
 repeat:
 	page = find_lock_page(mapping, index);
-	if (likely(page))
+	if (page)
 		return page;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
_

Patches currently in -mm which might be from srostedt@redhat.com are

linux-next.patch
mm-remove-likely-from-mapping_unevictable.patch
mm-remove-unlikely-from-page_mapping.patch
mm-remove-likely-from-grab_cache_page_write_begin.patch
vfs-remove-unlikely-from-fput_light.patch
vfs-remove-unlikely-from-fget_light.patch


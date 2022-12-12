Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8132FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiLLCOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiLLCN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34314DEF6
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C866660EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8EEC433EF;
        Mon, 12 Dec 2022 02:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811237;
        bh=npo+P8DIvhi4W0Smof8CaPkTqsUH4m5Ap+6npTr9i80=;
        h=Date:To:From:Subject:From;
        b=m3BrnT2tXPsnHD2H19bJ1e10ruUGq73H/5Kvh3cYJrHWqUjl1/O+S5w1XtFvTrZtV
         GDjNLAfcFluHyxKT7Hvm9LtBRQl/HEI2/tZeIDkgQx7r1UbaH583XPUTwpKwPHzoFP
         TIEMhYP2/Y27Zx5yQMZI1112NiBjDS5rQ6QmeyjU=
Date:   Sun, 11 Dec 2022 18:13:56 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, bfoster@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-skip-write-and-wait-if-end-offset-precedes-start.patch removed from -mm tree
Message-Id: <20221212021357.2E8EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: skip write and wait if end offset precedes start
has been removed from the -mm tree.  Its filename was
     filemap-skip-write-and-wait-if-end-offset-precedes-start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Foster <bfoster@redhat.com>
Subject: filemap: skip write and wait if end offset precedes start
Date: Mon, 28 Nov 2022 10:56:31 -0500

Patch series "filemap: skip write and wait if end offset precedes start",
v2.

A fix for the odd write and wait behavior described in the patch 1 commit
log.  Technically patch 1 could simply remove the check rather than lift
it into the callers, but this seemed a bit more user friendly to me. 
Patch 2 is appended after observation that fadvise() interacted poorly
with the v1 patch.  This is no longer a problem with v2, making patch 2
purely a cleanup.

This series survived both fstests and ltp regression runs without
observable problems.  I had (end < start) warning checks in each relevant
function, with fadvise() being the only caller that triggered them.  That
said, I dropped the warnings after testing because there seemed to much
potential for noise from the various other callers.


This patch (of 2):

A call to file[map]_write_and_wait_range() with an end offset that
precedes the start offset but happens to land in the same page can trigger
writeback submission but fails to wait on the submitted page.  Writeback
submission occurs because __filemap_fdatawrite_range() passes both offsets
down into write_cache_pages(), which rounds down to page indexes before it
starts processing writeback.  However, __filemap_fdatawait_range()
immediately returns if the byte-granular end offset precedes the start
offset.

This behavior was observed in the form of unpredictable latency from a
frequent write and wait call with incorrect parameters.  The behavior gave
the impression that the fdatawait path might occasionally fail to wait on
writeback, but further investigation showed the latency was from
write_cache_pages() waiting on writeback state to clear for a page already
under writeback.  Therefore, this indicated that fdatawait actually never
waits on writeback in this particular situation.

The byte granular check in __filemap_fdatawait_range() goes all the way
back to the old wait_on_page_writeback() helper.  It originally used page
offsets and so would have waited in this problematic case.  That changed
to byte granularity file offsets in commit 94004ed726f3 ("kill
wait_on_page_writeback_range"), which subtly changed this behavior.  The
check itself has become somewhat redundant since the error checking code
that used to follow the wait loop (at the time of the aforementioned
commit) has now been removed and lifted into the higher level callers.

Therefore, we can restore historical fdatawait behavior by simply removing
the check.  Since the current fdatawait behavior has been in place for
quite some time and is consistent with other interfaces that use file
offsets, instead lift the check into the file[map]_write_and_wait_range()
helpers to provide consistent behavior between the write and wait.

Link: https://lkml.kernel.org/r/20221128155632.3950447-1-bfoster@redhat.com
Link: https://lkml.kernel.org/r/20221128155632.3950447-2-bfoster@redhat.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~filemap-skip-write-and-wait-if-end-offset-precedes-start
+++ a/mm/filemap.c
@@ -506,9 +506,6 @@ static void __filemap_fdatawait_range(st
 	struct pagevec pvec;
 	int nr_pages;
 
-	if (end_byte < start_byte)
-		return;
-
 	pagevec_init(&pvec);
 	while (index <= end) {
 		unsigned i;
@@ -670,6 +667,9 @@ int filemap_write_and_wait_range(struct
 {
 	int err = 0, err2;
 
+	if (lend < lstart)
+		return 0;
+
 	if (mapping_needs_writeback(mapping)) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
@@ -770,6 +770,9 @@ int file_write_and_wait_range(struct fil
 	int err = 0, err2;
 	struct address_space *mapping = file->f_mapping;
 
+	if (lend < lstart)
+		return 0;
+
 	if (mapping_needs_writeback(mapping)) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
_

Patches currently in -mm which might be from bfoster@redhat.com are



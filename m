Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39170C4321E
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiK1WTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiK1WSz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:18:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2919130F57
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:18:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D12B80F79
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1301C433C1;
        Mon, 28 Nov 2022 22:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669673930;
        bh=lZ2ObnbOj3iCB0GlSN4mnHNn+wcPkj3A7N6xu0FO8wg=;
        h=Date:To:From:Subject:From;
        b=GSWWACTxidqH18DSFSNXvSLa1sd4Pu8vraxR9oI2q6fFz/HaC6kZzgS86eolETun1
         7FX0zDbaEa9XGTLXfc17kMsXSwD/RoA8fQZhwx8rgKzAmIviBXGPswMHrQL6pUWrZe
         qzEZviPUU/d5GY6LTBEeT/Bbxy9a7up1Fuk0EJSM=
Date:   Mon, 28 Nov 2022 14:18:49 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org, bfoster@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-skip-write-and-wait-if-end-offset-precedes-start.patch added to mm-unstable branch
Message-Id: <20221128221850.B1301C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: skip write and wait if end offset precedes start
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-skip-write-and-wait-if-end-offset-precedes-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-skip-write-and-wait-if-end-offset-precedes-start.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Christoph Hellwig <hch@infradead.org>
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

filemap-skip-write-and-wait-if-end-offset-precedes-start.patch
mm-fadvise-use-llong_max-instead-of-1-for-eof.patch


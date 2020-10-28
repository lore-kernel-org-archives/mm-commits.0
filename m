Return-Path: <SRS0=1Kf1=EE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31DBC4363A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 01:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B742076C
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 01:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603935527;
	bh=0t7UWyDIcQslE6GMcfAqKorBv9IpUXD9uwtYjjltQME=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lU3TpBDxRrgsi+F57uapbcSkgg20KntlkQMVymcUBCw35S9fDwDbTi0n/9FAPyAKy
	 c+xm2Y7JdoEXW5l8cymPBSqtZ3vjtNS4qbo48SKy6DHEcXJPo3KpPJJZ+lhTFbmlXO
	 I02ha4kuNfmNZVXzVnUF7FrG0xRIpWTuRqa780vc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgJ1WDA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729510AbgJ1WCY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 18:02:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF9224755;
        Wed, 28 Oct 2020 20:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603917748;
        bh=0t7UWyDIcQslE6GMcfAqKorBv9IpUXD9uwtYjjltQME=;
        h=Date:From:To:Subject:From;
        b=Ub94Gb9OE5AoavqqSb/rh5cL0ViuiYieDbFmN2QQuIG84aitPwhsumq/If7iv9fEN
         dVQ7vZR+wnKKHfsffzBn6SOgSnT2TkD/DLxBBYkDbK72JQAlSPVG8oCgR1LP2Cd3eN
         yRvG2yDYkppK/asQYx2jQT0VoyUYaVrgnHDQ6tWY=
Date:   Wed, 28 Oct 2020 13:42:27 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + procfs-delete-duplicated-words-other-fixes.patch added
 to -mm tree
Message-ID: <20201028204227.J02fcshFo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: delete duplicated words + other fixes
has been added to the -mm tree.  Its filename is
     procfs-delete-duplicated-words-other-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-delete-duplicated-words-other-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-delete-duplicated-words-other-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: procfs: delete duplicated words + other fixes

Delete repeated words in fs/proc/.
{the, which}
where "which which" was changed to "with which".

Link: https://lkml.kernel.org/r/20201028191525.13413-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    2 +-
 fs/proc/proc_net.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c~procfs-delete-duplicated-words-other-fixes
+++ a/fs/proc/base.c
@@ -2021,7 +2021,7 @@ const struct dentry_operations pid_dentr
  * file type from dcache entry.
  *
  * Since all of the proc inode numbers are dynamically generated, the inode
- * numbers do not exist until the inode is cache.  This means creating the
+ * numbers do not exist until the inode is cache.  This means creating
  * the dcache entry in readdir is necessary to keep the inode numbers
  * reported by readdir in sync with the inode numbers reported
  * by stat.
--- a/fs/proc/proc_net.c~procfs-delete-duplicated-words-other-fixes
+++ a/fs/proc/proc_net.c
@@ -140,7 +140,7 @@ EXPORT_SYMBOL_GPL(proc_create_net_data);
  * @mode: The file's access mode.
  * @parent: The parent directory in which to create.
  * @ops: The seq_file ops with which to read the file.
- * @write: The write method which which to 'modify' the file.
+ * @write: The write method with which to 'modify' the file.
  * @data: Data for retrieval by PDE_DATA().
  *
  * Create a network namespaced proc file in the @parent directory with the
@@ -232,7 +232,7 @@ EXPORT_SYMBOL_GPL(proc_create_net_single
  * @mode: The file's access mode.
  * @parent: The parent directory in which to create.
  * @show: The seqfile show method with which to read the file.
- * @write: The write method which which to 'modify' the file.
+ * @write: The write method with which to 'modify' the file.
  * @data: Data for retrieval by PDE_DATA().
  *
  * Create a network-namespaced proc file in the @parent directory with the
_

Patches currently in -mm which might be from rdunlap@infradead.org are

procfs-delete-duplicated-words-other-fixes.patch


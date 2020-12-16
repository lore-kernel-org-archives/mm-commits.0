Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641B1C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B432343B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgLPRI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:08:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPRI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:08:59 -0500
Date:   Wed, 16 Dec 2020 09:08:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138498;
        bh=9ZOG5c49IBsL4mRiqUeKAT3wFsUySPyzgSsTeq+kvCE=;
        h=From:To:Subject:From;
        b=R7lafNkFa/MiSJcdQem4CLKLe5lux4MiIzpn+DA5ze+M6RaDDGz55CesGdGQK/n1d
         /eTlUfJRneJeuxTMWox9ozPpONScSNaCsP6jkoTiMp+E3ysNtHsMWUmqN7MPycPBHN
         HW+Mi19nptNDrVMfNeZ3qvMd1uptZwRl/0WJ2BJI=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged] procfs-delete-duplicated-words-other-fixes.patch
 removed from -mm tree
Message-ID: <20201216170818.SppFNM-jJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: delete duplicated words + other fixes
has been removed from the -mm tree.  Its filename was
     procfs-delete-duplicated-words-other-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



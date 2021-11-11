Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C623C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B7E61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhKKCs7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE7461108;
        Thu, 11 Nov 2021 02:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598771;
        bh=PdiZohHTcbperSYfxozveOFAgxBueVSJ5ljiY0pYwbI=;
        h=Date:From:To:Subject:From;
        b=mAkbo/aTStVhs29/hseNvgon2trXWCJjqyjFSjh+XTSdjGoL6DP8qkkYvegp0R0KH
         5AnPSXOIAIhhPSZU2V93UIazj9iscFU0j8uqBJYcgR6VvXp+djFo9VOg9Oan10ybRc
         NmvyeUgC1g+klui65kqbZZz960/68oEsEzEicJ5o=
Date:   Wed, 10 Nov 2021 18:46:10 -0800
From:   akpm@linux-foundation.org
To:     changbin.du@intel.com, chansen3@cisco.com, koct9i@gmail.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangbin224@huawei.com
Subject:  [merged]
 tools-vm-page-typesc-move-show_file-to-summary-output.patch removed from
 -mm tree
Message-ID: <20211111024610.E9WOfrjeH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: move show_file() to summary output
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-move-show_file-to-summary-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: tools/vm/page-types.c: move show_file() to summary output

Currently file info from show_file() is printed out within page list like
below, but this is inconvenient a little to utilize the page list from
other scripts (maybe needs additional filtering).

    $ ./page-types -f page-types.c -l
    foffset offset  len     flags
    page-types.c Inode: 15108680 Size: 30953 (8 pages)
    Modify: Sat Oct  2 23:11:20 2021 (2399 seconds ago)
    Access: Sat Oct  2 23:11:28 2021 (2391 seconds ago)
    0       d9f59e  1       ___U_lA____________________________________
    1       1031eb5 1       __RU_l_____________________________________
    2       13bf717 1       __RU_l_____________________________________
    3       13ac333 1       ___U_lA____________________________________
    4       d9f59f  1       __RU_l_____________________________________
    5       183fd49 1       ___U_lA____________________________________
    6       13cbf69 1       ___U_lA____________________________________
    7       d9ef05  1       ___U_lA____________________________________

                 flags      page-count       MB  symbolic-flags                     long-symbolic-flags
    0x000000000000002c               3        0  __RU_l_____________________________________        referenced,uptodate,lru
    0x0000000000000068               5        0  ___U_lA____________________________________        uptodate,lru,active
                 total               8        0

With this patch file info is printed out in summary part like below:

    $ ./page-types -f page-types.c -l
    foffset offset  len     flags
    0       d9f59e  1       ___U_lA_____________________________________
    1       1031eb5 1       __RU_l______________________________________
    2       13bf717 1       __RU_l______________________________________
    3       13ac333 1       ___U_lA_____________________________________
    4       d9f59f  1       __RU_l______________________________________
    5       183fd49 1       ___U_lA_____________________________________
    6       13cbf69 1       ___U_lA_____________________________________

    page-types.c Inode: 15108680 Size: 30953 (8 pages)
    Modify: Sat Oct  2 23:11:20 2021 (2435 seconds ago)
    Access: Sat Oct  2 23:11:28 2021 (2427 seconds ago)

                 flags      page-count       MB  symbolic-flags                     long-symbolic-flags
    0x000000000000002c               3        0  __RU_l______________________________________       referenced,uptodate,lru
    0x0000000000000068               4        0  ___U_lA_____________________________________       uptodate,lru,active
                 total               7        0

Link: https://lkml.kernel.org/r/20211004061325.1525902-3-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Bin Wang <wangbin224@huawei.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Christian Hansen <chansen3@cisco.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/vm/page-types.c~tools-vm-page-typesc-move-show_file-to-summary-output
+++ a/tools/vm/page-types.c
@@ -1034,7 +1034,6 @@ got_sigbus:
 			if (first && opt_list) {
 				first = 0;
 				flush_page_range();
-				show_file(name, st);
 			}
 			add_page(off / page_size + i, pfn,
 				 flags, cgroup, mapcnt, buf[i]);
@@ -1074,10 +1073,10 @@ int walk_tree(const char *name, const st
 	return 0;
 }
 
+struct stat st;
+
 static void walk_page_cache(void)
 {
-	struct stat st;
-
 	kpageflags_fd = checked_open(opt_kpageflags, O_RDONLY);
 	pagemap_fd = checked_open("/proc/self/pagemap", O_RDONLY);
 	sigaction(SIGBUS, &sigbus_action, NULL);
@@ -1374,6 +1373,11 @@ int main(int argc, char *argv[])
 	if (opt_list)
 		printf("\n\n");
 
+	if (opt_file) {
+		show_file(opt_file, &st);
+		printf("\n");
+	}
+
 	show_summary();
 
 	if (opt_list_mapcnt)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are



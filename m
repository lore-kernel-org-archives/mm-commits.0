Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3471C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDE6B61356
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhKEUpn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 459A46128E;
        Fri,  5 Nov 2021 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144982;
        bh=ShfnrBTr9wSsfW0j2EnGKceQ9kQk/11wpBiFqD1/xWA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I7/Js934+CygG4oqWKKAkSDQxRX7vQHDOstqkx92ptwODznchw7e74vgWBH4fdCx3
         AA0zcbMe0lbwr+Bf1HKFUOmM8REfjthU9xth/Dl4VzM/89ZhyAn39p/JLjqtHxMKcl
         CGP3VFPulzr72jE04Q2t+/Lx4QmGd9g6t8fX7VBU=
Date:   Fri, 05 Nov 2021 13:43:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@intel.com,
        chansen3@cisco.com, koct9i@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        torvalds@linux-foundation.org, wangbin224@huawei.com
Subject:  [patch 160/262] tools/vm/page-types.c: move show_file()
 to summary output
Message-ID: <20211105204301.A1DZ4so80%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

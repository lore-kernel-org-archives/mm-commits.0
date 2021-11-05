Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE0FC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F186134F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhKEUpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3086126A;
        Fri,  5 Nov 2021 20:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144979;
        bh=jgYtiR6rG07Cr+X9pE4VeeKB+UpDrZA5xCBhF+Cah3U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gd9IP5qDXi090Y7mtwMwRH9xLZcuJTpwXUbGR+Cn6JwWG9tglX7wOpnKEWJj6SSJF
         nPFqm92tdHj1+7WhHZy447ySuvNdXANTFPouXLr4Wa8Ed8ZgO6VTKaacDHkCjOIgNt
         tG+79vX3OFzl89C1B1RYPeZXPXoZGHu2Ff9O72cc=
Date:   Fri, 05 Nov 2021 13:42:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@intel.com,
        chansen3@cisco.com, koct9i@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        torvalds@linux-foundation.org, wangbin224@huawei.com
Subject:  [patch 159/262] tools/vm/page-types.c: make walk_file()
 aware of address range option
Message-ID: <20211105204258.-SJZLHkr6%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: tools/vm/page-types.c: make walk_file() aware of address range option

Patch series "tools/vm/page-types.c: a few improvements".

This patchset adds some improvements on tools/vm/page-types.c.  Patch 1/3
makes -a option (specify address range) work with -f (file cache mode). 
Patch 2/3 and 3/3 are to fix minor formatting issues of this tool.  These
would make life a little easier for the users of this tool.

Please see individual patches for more details about specific issues.


This patch (of 3):

-a|--addr option is used to limit the range of address to be scanned for
page status.  It works now for physical address space (dafult mode) or for
virtual address space (with -p option), but not for file address space
(with -f option).  So make walk_file() aware of -a option.

Link: https://lkml.kernel.org/r/20211004061325.1525902-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20211004061325.1525902-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Christian Hansen <chansen3@cisco.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Bin Wang <wangbin224@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/tools/vm/page-types.c~tools-vm-page-typesc-make-walk_file-aware-of-address-range-option
+++ a/tools/vm/page-types.c
@@ -967,22 +967,19 @@ static struct sigaction sigbus_action =
 	.sa_flags = SA_SIGINFO,
 };
 
-static void walk_file(const char *name, const struct stat *st)
+static void walk_file_range(const char *name, int fd,
+			    unsigned long off, unsigned long end)
 {
 	uint8_t vec[PAGEMAP_BATCH];
 	uint64_t buf[PAGEMAP_BATCH], flags;
 	uint64_t cgroup = 0;
 	uint64_t mapcnt = 0;
 	unsigned long nr_pages, pfn, i;
-	off_t off, end = st->st_size;
-	int fd;
 	ssize_t len;
 	void *ptr;
 	int first = 1;
 
-	fd = checked_open(name, O_RDONLY|O_NOATIME|O_NOFOLLOW);
-
-	for (off = 0; off < end; off += len) {
+	for (; off < end; off += len) {
 		nr_pages = (end - off + page_size - 1) / page_size;
 		if (nr_pages > PAGEMAP_BATCH)
 			nr_pages = PAGEMAP_BATCH;
@@ -1043,6 +1040,21 @@ got_sigbus:
 				 flags, cgroup, mapcnt, buf[i]);
 		}
 	}
+}
+
+static void walk_file(const char *name, const struct stat *st)
+{
+	int i;
+	int fd;
+
+	fd = checked_open(name, O_RDONLY|O_NOATIME|O_NOFOLLOW);
+
+	if (!nr_addr_ranges)
+		add_addr_range(0, st->st_size / page_size);
+
+	for (i = 0; i < nr_addr_ranges; i++)
+		walk_file_range(name, fd, opt_offset[i] * page_size,
+				(opt_offset[i] + opt_size[i]) * page_size);
 
 	close(fd);
 }
_

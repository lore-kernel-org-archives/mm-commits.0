Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFC3C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F3561248
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJEXoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhJEXon (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:44:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F0C61215;
        Tue,  5 Oct 2021 23:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633477372;
        bh=ETKYEOnbwq0toHioPlAifo7HV4AvyTih7+nH3BN0VHQ=;
        h=Date:From:To:Subject:From;
        b=KXOtBAhOaXDdksbAgny3O4RDHrleBROy8aF739mvB6KI6B8eyeCpNJcYcfxKfAbcn
         Ve3DmiP6QnMrMwTpmEXQZIKpahHA4FcEB2owZPGeN5sIMyXeFzkwu15PD0tH99MT6V
         /kQM7hE/snktHTCP7hmLoPgdehQX+DpTt0kzkLcM=
Date:   Tue, 05 Oct 2021 16:42:51 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@intel.com, chansen3@cisco.com, koct9i@gmail.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangbin224@huawei.com
Subject:  +
 tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch
 added to -mm tree
Message-ID: <20211005234251.MrOWC8jxs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: make walk_file() aware of address range option
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch
tools-vm-page-typesc-move-show_file-to-summary-output.patch
tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch


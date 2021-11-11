Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB73C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8774961247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhKKCtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BBB6113B;
        Thu, 11 Nov 2021 02:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598773;
        bh=1ZNi/Iu6OAE0jW8lDB5tkU6BrkxsXSIr243c83YaCdc=;
        h=Date:From:To:Subject:From;
        b=ma7uxxF14eMlSWokt5bBtYtskudWg5wRF09zOAJ2RjVYf424RU6BgR4+Punz69I4J
         /Xt8G6CzM3yclEExd+g8BG7+cPCGJSlT/J1A3fBTrMFI8FccJpZUnzyZ60Z6nopZBR
         J4zRU+Fl7/dLc+3JbbMiX/fMqYGobR7mPi17H5Nc=
Date:   Wed, 10 Nov 2021 18:46:13 -0800
From:   akpm@linux-foundation.org
To:     changbin.du@intel.com, chansen3@cisco.com, koct9i@gmail.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangbin224@huawei.com
Subject:  [merged]
 tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch removed from
 -mm tree
Message-ID: <20211111024613.Jz_oaBmQF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: print file offset in hexadecimal
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: tools/vm/page-types.c: print file offset in hexadecimal

In page list mode (with -l and -L option), virtual address and physical
address are printed in hexadecimal, but file offset is not, which is
confusing, so let's align it.

Link: https://lkml.kernel.org/r/20211004061325.1525902-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Bin Wang <wangbin224@huawei.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Christian Hansen <chansen3@cisco.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/page-types.c~tools-vm-page-typesc-print-file-offset-in-hexadecimal
+++ a/tools/vm/page-types.c
@@ -390,7 +390,7 @@ static void show_page_range(unsigned lon
 		if (opt_pid)
 			printf("%lx\t", voff);
 		if (opt_file)
-			printf("%lu\t", voff);
+			printf("%lx\t", voff);
 		if (opt_list_cgroup)
 			printf("@%llu\t", (unsigned long long)cgroup0);
 		if (opt_list_mapcnt)
@@ -418,7 +418,7 @@ static void show_page(unsigned long voff
 	if (opt_pid)
 		printf("%lx\t", voffset);
 	if (opt_file)
-		printf("%lu\t", voffset);
+		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
 		printf("@%llu\t", (unsigned long long)cgroup);
 	if (opt_list_mapcnt)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are



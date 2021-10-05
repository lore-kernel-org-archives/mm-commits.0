Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A961C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE3C61244
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhJEXor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhJEXor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE45861248;
        Tue,  5 Oct 2021 23:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633477375;
        bh=bss4gdGY9s2+HFSmQ5KduBvU8ZMroIVHsciHAU8bgHk=;
        h=Date:From:To:Subject:From;
        b=UuUm009n7i6kCc5GP2ZJe3ul30uF9O+GnfoYQPyb22/NMhjSHHo9Lqo1/HMGOzbWg
         1XS8s3oh01oBfwbyUK202cJQDCK40VJ7YJ4y66tRhRLvFLBPhCM1DvZ19gwiaeM6Ay
         6/YvHbDfb4nYcSuUf88gxnd5Qt96Nw78WzE/tZ7k=
Date:   Tue, 05 Oct 2021 16:42:55 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@intel.com, chansen3@cisco.com, koct9i@gmail.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangbin224@huawei.com
Subject:  +
 tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch added to -mm
 tree
Message-ID: <20211005234255.Z-ek0cGvr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: print file offset in hexadecimal
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch

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

tools-vm-page-typesc-make-walk_file-aware-of-address-range-option.patch
tools-vm-page-typesc-move-show_file-to-summary-output.patch
tools-vm-page-typesc-print-file-offset-in-hexadecimal.patch


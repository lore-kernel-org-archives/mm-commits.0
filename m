Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2725BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11FE66135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKEUpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 540D261355;
        Fri,  5 Nov 2021 20:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144985;
        bh=I2DItkYvN5bnUgDVb2gxsHA4B4GOX2xKFZqeBeAEkHY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h5GqdKZ6A6sZ8rn+RoZMkM1IUptaslU9dd0bDvYFp4Czxkg5mPZpmGOWCqwTWWxl0
         O+9qBz5eLWztDvhWstGtsfdZPonJaj31MutEneDNRhjTg/U0+MNALbqWxOy6RxvOxu
         1YKMDQLXtccMuRAmb+/tl9YL7q1QXgrHmzeSZRKs=
Date:   Fri, 05 Nov 2021 13:43:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@intel.com,
        chansen3@cisco.com, koct9i@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        torvalds@linux-foundation.org, wangbin224@huawei.com
Subject:  [patch 161/262] tools/vm/page-types.c: print file offset
 in hexadecimal
Message-ID: <20211105204304.q6OqMQ7kF%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7CDC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEF761181
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbhKICRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238836AbhKICRP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:17:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A81A361181;
        Tue,  9 Nov 2021 02:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636424070;
        bh=LywbsyETS9dHwyHn1Zrl1CBRij+N99FgipMIAEaIfF4=;
        h=Date:From:To:Subject:From;
        b=EGhxNhT+H8DJ+tEstU+fpbvozQlorf+QRYmPm6NnwK0VjavAgAC1kPVd/pInPuSga
         aGQrQm3jbhKlLoPCcpVJLA98XBplwUTANwKtqr9AG++vSXFDb+AZRwhGDQEByW/7Og
         6bBjJcnmJpdZ9wxQmRVJgj9A1IY+AFu5QOLoYHi8=
Date:   Mon, 08 Nov 2021 18:14:30 -0800
From:   akpm@linux-foundation.org
To:     imran.f.khan@oracle.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch
 removed from -mm tree
Message-ID: <20211109021430.yCghUmnN6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch

This patch was dropped because it was folded into lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3

export stack_depot_snprint() to modules

Link: https://lkml.kernel.org/r/20210916133535.3592491-4-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackdepot.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3
+++ a/lib/stackdepot.c
@@ -236,6 +236,7 @@ int stack_depot_snprint(depot_stack_hand
 	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
 						spaces) : 0;
 }
+EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
 /**
  * stack_depot_print - print stack entries from a depot
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are

lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
lib-stackdepot-add-helper-to-print-stack-entries.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch


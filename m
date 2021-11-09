Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DACC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E53B661452
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbhKICh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKICh4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A25C6613B3;
        Tue,  9 Nov 2021 02:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425311;
        bh=k1abyCFRlKFs/J8AeEOTTfUth0LjXtWIVD/SGsT+TGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pvXQPz25xg+OmkN+12IeWXKXIXEkRIx4vE4FIwpHqm6CfMgl2+do2dy6kpHYIrNGN
         kUu8V0olNBJzaRZB+BrlF39k317URV8MIhDwvizFL0cQiC8hBh35JS/UuYNLAQ2vl0
         1UXNkxa49XgJ7Ha5JoU9gZCxY8E1lr4TgyLZLnlc=
Date:   Mon, 08 Nov 2021 18:35:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        deng.changcheng@zte.com.cn, dyoung@redhat.com, horms@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [patch 70/87] crash_dump: remove duplicate include in
 crash_dump.h
Message-ID: <20211109023510.g8I6RAb-H%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>
Subject: crash_dump: remove duplicate include in crash_dump.h

In crash_dump.h, header file <linux/pgtable.h> is included twice.  This
duplication was introduced in commit 65fddcfca8ad("mm: reorder includes
after introduction of linux/pgtable.h") where the order of the header
files is adjusted, while the old one was not removed.

Clean it up here.

Link: https://lkml.kernel.org/r/20211020090659.1038877-1-ye.guojin@zte.com.cn
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Changcheng Deng <deng.changcheng@zte.com.cn>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/crash_dump.h~crash_dump-remove-duplicate-include-in-crash_dumph
+++ a/include/linux/crash_dump.h
@@ -8,8 +8,6 @@
 #include <linux/pgtable.h>
 #include <uapi/linux/vmcore.h>
 
-#include <linux/pgtable.h> /* for pgprot_t */
-
 /* For IS_ENABLED(CONFIG_CRASH_DUMP) */
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
_

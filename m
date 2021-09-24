Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384DFC43219
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9D76127A
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243488AbhIXWpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238242AbhIXWpP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1F861019;
        Fri, 24 Sep 2021 22:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523422;
        bh=RpB1DxDYaXU7/JZEGKGoFaw9n+Fbb+USJOf6il0Qr3A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xHMBBpXFLY7xyMFj5OiyOT6E6MbSzUxi6ijCNzbQD4PTCZDG6A2PGMpRETM8hhN8t
         cNHiv1CY3O6HO7sQy2MBsvzqZV8s/dPFe4Ae7tf7NejI9GSPEgx+1c3H+Q5OW+Yj2A
         I7pv5ZvCnKTG9f8s1X6k7fSFv+l442x5XFvXOKDU=
Date:   Fri, 24 Sep 2021 15:43:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/16] tools/vm/page-types: remove dependency on
 opt_file for idle page tracking
Message-ID: <20210924224341.cP9xYOrED%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: tools/vm/page-types: remove dependency on opt_file for idle page tracking

Idle page tracking can also be used for process address space, not only
file mappings.

Without this change, using with '-i' option for process address space
encounters below errors reported.

$ sudo ./page-types -p $(pidof bash) -i
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
....

Link: https://lkml.kernel.org/r/20210917032826.10669-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page-types.c~tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking
+++ a/tools/vm/page-types.c
@@ -1331,7 +1331,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
_

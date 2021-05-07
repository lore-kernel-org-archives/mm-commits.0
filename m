Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C17C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1123611EE
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhEGBDK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEGBDJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2171611ED;
        Fri,  7 May 2021 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349331;
        bh=EemAkoOj6zk8uFTQjT7tG20Ogvn72UgHFmv5AVnYTTs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m2cetK0np1E+D75vbzA4cggTqRGQKmRJGmP/TTRYtl0jZ5OX8/qbMpkYldH+A6PUc
         ZuXBuZVnJms+4wHQn8h0PcUdlxM87Zs1daQKXw/jDChyz1jwawd3SWQ9HwOQARlD69
         TNLXq7XtpbbJm2FUWvhK63eZ+YhOmZ5oGwK8ylPU=
Date:   Thu, 06 May 2021 18:02:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        gregkh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/91] fs/proc/generic.c: fix incorrect
 pde_is_permanent check
Message-ID: <20210507010210.9J8es3ews%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: fs/proc/generic.c: fix incorrect pde_is_permanent check

Currently the pde_is_permanent() check is being run on root multiple times
rather than on the next proc directory entry.  This looks like a
copy-paste error.  Fix this by replacing root with next.

Addresses-Coverity: ("Copy-paste error")
Link: https://lkml.kernel.org/r/20210318122633.14222-1-colin.king@canonical.com
Fixes: d919b33dafb3 ("proc: faster open/read/close with "permanent" files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-fix-incorrect-pde_is_permanent-check
+++ a/fs/proc/generic.c
@@ -756,7 +756,7 @@ int remove_proc_subtree(const char *name
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
-			if (unlikely(pde_is_permanent(root))) {
+			if (unlikely(pde_is_permanent(next))) {
 				write_unlock(&proc_subdir_lock);
 				WARN(1, "removing permanent /proc entry '%s/%s'",
 					next->parent->name, next->name);
_

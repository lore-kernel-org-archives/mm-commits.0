Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B061C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D3A61288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhKEUoa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233679AbhKEUoa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF70C61262;
        Fri,  5 Nov 2021 20:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144910;
        bh=BSW36IfBi42ma3jGEns2UC6IdWxbZwxD8teozAaJBUM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ODbcsuiWu+Foww5pmzvZSG8cowDFKTfb3G+guTK4UKy+pSGa5HuIlYIcFr4ByRnPY
         En2i4a09DhNxifPJp25MmykvQ1iNaVeIKUZHBMEAaNwlzBYYiWW0Dg5Bv8iA2B8bK2
         Q3+uAbSaHK1HnD5VyaeAOF1FjDk1q4O6M0YjJC8o=
Date:   Fri, 05 Nov 2021 13:41:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ran.jianping@zte.com.cn,
        shuah@kernel.org, torvalds@linux-foundation.org, zealci@zte.com.cn
Subject:  [patch 137/262] mm: remove duplicate include in
 hugepage-mremap.c
Message-ID: <20211105204149.yGUgSZG33%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ran Jianping <ran.jianping@zte.com.cn>
Subject: mm: remove duplicate include in hugepage-mremap.c

Remove duplicate includes 'unistd.h' included in
 '/tools/testing/selftests/vm/hugepage-mremap.c'  is duplicated.It is also
 included on 23 line.

Link: https://lkml.kernel.org/r/20211018102336.869726-1-ran.jianping@zte.com.cn
Signed-off-by: Ran Jianping <ran.jianping@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-remove-duplicate-include-in-hugepage-mremapc
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -15,7 +15,6 @@
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
 #include <sys/syscall.h> /* Definition of SYS_* constants */
-#include <unistd.h>
 #include <linux/userfaultfd.h>
 #include <sys/ioctl.h>
 
_

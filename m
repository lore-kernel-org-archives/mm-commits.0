Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D876BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C150461208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhKKCsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ACBD60F46;
        Thu, 11 Nov 2021 02:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598712;
        bh=5DhXb7q5ZlSnzJLZb+oac/UOoxD526Pr5NHMsh+HKfo=;
        h=Date:From:To:Subject:From;
        b=Rrmcqe1Q/6cEQMRlBS14kL/UxXLAwNMm4GQwnBncA5x1vzdoQ+A0WXl2VpWpo23ns
         MzFE3YM/Ja+c2xYbcMR01d49T2+r3jGhJGjRsjCX1Z4Q1/5E3JidjPR44GHZv0KVFd
         8AJE/w7kDGIZp9CXUo3YZ7prNAxu4hkEMynGPIFw=
Date:   Wed, 10 Nov 2021 18:45:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ran.jianping@zte.com.cn,
        shuah@kernel.org, zealci@zte.com.cn
Subject:  [merged]
 mm-remove-duplicate-include-in-hugepage-mremapc.patch removed from -mm tree
Message-ID: <20211111024512.gOFzwoH1C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove duplicate include in hugepage-mremap.c
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicate-include-in-hugepage-mremapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ran.jianping@zte.com.cn are



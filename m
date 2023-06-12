Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC9FC7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbjFLVb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjFLVb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30090
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456E262BC8
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90800C433EF;
        Mon, 12 Jun 2023 21:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605516;
        bh=FuH9nHoH7q1ofsNhPOIyrG0EckMNjOyTd1wsayoDd4Y=;
        h=Date:To:From:Subject:From;
        b=eWq/6mFOFJtsmXY4VzcDNgY/t+v8jhbNxFGQBcXTP1TObBMxeBw1NFWPeKlXh4Him
         ipjvCXvtuafTkb5hWhqxNkevRwOsklKBHcncPreSsBw+ltJoiqsyveBmEBLND/EBAP
         j9EeK504+Wl5J53Zch5psScm9gSZ3jFp7jX1gxyw=
Date:   Mon, 12 Jun 2023 14:31:55 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, jeffxu@google.com, yuehaibing@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch added to mm-unstable branch
Message-Id: <20230612213156.90800C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: pid_namespace: remove unused set_memfd_noexec_scope()
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: kernel: pid_namespace: remove unused set_memfd_noexec_scope()
Date: Sat, 10 Jun 2023 18:28:58 +0800

This inline function is unused, remove it.

Link: https://lkml.kernel.org/r/20230610102858.31488-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_sysctl.h |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/pid_sysctl.h~kernel-pid_namespace-remove-unused-set_memfd_noexec_scope
+++ a/kernel/pid_sysctl.h
@@ -52,7 +52,6 @@ static inline void register_pid_ns_sysct
 }
 #else
 static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
-static inline void set_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void register_pid_ns_sysctl_table_vm(void) {}
 #endif
 
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch


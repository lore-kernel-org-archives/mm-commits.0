Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99F5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjFSX0J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjFSXYU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8119AA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E65A60FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889D4C433C8;
        Mon, 19 Jun 2023 23:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216976;
        bh=LRBDpY/6Aj2/PcqkAHMa/Y3ZEisr6iqYuuRd7ZvDMDw=;
        h=Date:To:From:Subject:From;
        b=IVg09mNU2V3zNEXmWa7ZcOh6GGuHVHRevMMIOK7Kg4J9GLI32n6gSp+aGr4lY+/jQ
         WcZOcBZ8eR8dnWh1R7lwMlZZZzWAdNDbAzM7W68TaBxhaT3p1hT0tVTyp/+CWWoBOp
         zlu4TWN+gF6J2ar1iSRY4S07G+e0to65DO+pfZOI=
Date:   Mon, 19 Jun 2023 16:22:56 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, jeffxu@google.com, yuehaibing@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch removed from -mm tree
Message-Id: <20230619232256.889D4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel: pid_namespace: remove unused set_memfd_noexec_scope()
has been removed from the -mm tree.  Its filename was
     kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



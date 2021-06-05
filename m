Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90716C48BC2
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755836140F
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhFEDDa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhFEDD3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FE261406;
        Sat,  5 Jun 2021 03:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862091;
        bh=mWDruc4KJkk3g4ozS1gws+YNRyRZhpLkAcooKndnv28=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lqpyJ3Rh3L5Xu5Lae30aHKxRAwIxwinS6nUKOEn5cE+ziLjW8E0s9rS2eNXmzJKom
         mYKrbba+6nxLW6oz750d3h1KlF6L1rU0rqdvzKytHyYvFBw1NJTQ+7KVRvHgdq92kG
         Abe7jRjOOolyCgImpSEIjkYvVs8+cJ3Eut5nOTg8=
Date:   Fri, 04 Jun 2021 20:01:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, dmatlack@google.com,
        gladkov.alexey@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/13] proc: add .gitignore for proc-subset-pid
 selftest
Message-ID: <20210605030130.uSF25Ou87%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Matlack <dmatlack@google.com>
Subject: proc: add .gitignore for proc-subset-pid selftest

This new selftest needs an entry in the .gitignore file otherwise git
will try to track the binary.

Link: https://lkml.kernel.org/r/20210601164305.11776-1-dmatlack@google.com
Fixes: 268af17ada5855 ("selftests: proc: test subset=pid")
Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-add-gitignore-for-proc-subset-pid-selftest
+++ a/tools/testing/selftests/proc/.gitignore
@@ -10,6 +10,7 @@
 /proc-self-map-files-002
 /proc-self-syscall
 /proc-self-wchan
+/proc-subset-pid
 /proc-uptime-001
 /proc-uptime-002
 /read
_

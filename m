Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B49C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 04:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiBDEsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:48:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiBDEsi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 23:48:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E90561B46
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 04:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D98AC004E1;
        Fri,  4 Feb 2022 04:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950117;
        bh=acTcsiWTfExJwsF+ZMbsLeLZj7KAWvifRi1Zm0RUsKg=;
        h=Date:From:To:Cc:Subject:From;
        b=vP8pyX3ccvgHa58EaWaVHDIPlqxZAb9W0+gcybnW5YcWoLD4LS1K3QxzQLB8uPGIf
         BWK40zlEVWT6RhyIwksFmbLP1bVQ66A7wQVwlVVMH3lvyM0cKQPYeL6HCjTMLQeF83
         M+PDN7ufnOUPiAFocfw8v0vAmpoJcKXZAwGpYUZc=
Date:   Thu, 3 Feb 2022 20:48:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

10 patches, based on 1f2cfdd349b7647f438c1e552dc1b983da86d830.

Subsystems affected by this patch series:

  mm/vmscan
  mm/debug
  mm/pagemap
  ipc
  mm/kmemleak
  MAINTAINERS
  mm/selftests

Subsystem: mm/vmscan

    Chen Wandun <chenwandun@huawei.com>:
      Revert "mm/page_isolation: unset migratetype directly for non Buddy page"

Subsystem: mm/debug

    Pasha Tatashin <pasha.tatashin@soleen.com>:
    Patch series "page table check fixes and cleanups", v5:
      mm/debug_vm_pgtable: remove pte entry from the page table
      mm/page_table_check: use unsigned long for page counters and cleanup
      mm/khugepaged: unify collapse pmd clear, flush and free
      mm/page_table_check: check entries at pmd levels

Subsystem: mm/pagemap

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/pgtable: define pte_index so that preprocessor could recognize it

Subsystem: ipc

    Minghao Chi <chi.minghao@zte.com.cn>:
      ipc/sem: do not sleep with a spin lock held

Subsystem: mm/kmemleak

    Lang Yu <lang.yu@amd.com>:
      mm/kmemleak: avoid scanning potential huge holes

Subsystem: MAINTAINERS

    Mike Rapoport <rppt@linux.ibm.com>:
      MAINTAINERS: update rppt's email

Subsystem: mm/selftests

    Shuah Khan <skhan@linuxfoundation.org>:
      kselftest/vm: revert "tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner"

 MAINTAINERS                              |    2 -
 include/linux/page_table_check.h         |   19 ++++++++++
 include/linux/pgtable.h                  |    1 
 ipc/sem.c                                |    4 +-
 mm/debug_vm_pgtable.c                    |    2 +
 mm/khugepaged.c                          |   37 +++++++++++---------
 mm/kmemleak.c                            |   13 +++----
 mm/page_isolation.c                      |    2 -
 mm/page_table_check.c                    |   55 +++++++++++++++----------------
 tools/testing/selftests/vm/userfaultfd.c |   11 ++++--
 10 files changed, 89 insertions(+), 57 deletions(-)


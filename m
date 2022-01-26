Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50EEC3525A
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 01:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbiAZBtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiAZBtO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 20:49:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D81C06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 17:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7527B81AC6
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 01:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E88AC340E0;
        Wed, 26 Jan 2022 01:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643161751;
        bh=v2tiUd8qnI44TyvODTtHX/4Mvdqt3YOp8gUSWT6zq8s=;
        h=Date:From:To:Subject:From;
        b=l/pSkL7fVktOUZHATNexuvbfrYIvfML0pDdsEzcmie09NDWVu89BvNTRlF/SZRHqC
         JN10bOjxxyHmGf66EdXqTuJxIMrmXTAdMvkicy6V2k9iCqUPM48w2hf+izBMKTyemr
         uVIWmcF+OB+LZTvgSxpqhMnvD+ESADv9Iuzp2Aio=
Date:   Tue, 25 Jan 2022 17:49:10 -0800
From:   akpm@linux-foundation.org
To:     andrealmeid@collabora.com, apopple@nvidia.com,
        chi.minghao@zte.com.cn, dave@stgolabs.net, davem@davemloft.net,
        dvhart@infradead.org, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mic@digikod.net, mingo@redhat.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, shuah@kernel.org,
        tglx@linutronix.de, usama.anjum@collabora.com
Subject:  +
 selftests-vm-remove-dependecy-from-internal-kernel-macros.patch added to
 -mm tree
Message-ID: <20220126014910.M5VvdW90q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: remove dependecy from internal kernel macros
has been added to the -mm tree.  Its filename is
     selftests-vm-remove-dependecy-from-internal-kernel-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-remove-dependecy-from-internal-kernel-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-remove-dependecy-from-internal-kernel-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: vm: remove dependecy from internal kernel macros

The defination of swap() is used from kernel's internal header when this
test is built in source tree.  The build fails when this test is built out
of source tree as defination of swap() isn't found.  Selftests shouldn't
depend on kernel's internal header files.  They can only depend on uapi
header files.  Add the defination of swap() to fix the build error:

	gcc -Wall  -I/linux_mainline2/build/usr/include -no-pie    userfaultfd.c -lrt -lpthread -o /linux_mainline2/build/kselftest/vm/userfaultfd
	userfaultfd.c: In function `userfaultfd_stress':
	userfaultfd.c:1530:3: warning: implicit declaration of function `swap'; did you mean `swab'? [-Wimplicit-function-declaration]
	 1530 |   swap(area_src, area_dst);
	      |   ^~~~
	      |   swab
	/usr/bin/ld: /tmp/cclUUH7V.o: in function `userfaultfd_stress':
	userfaultfd.c:(.text+0x4d64): undefined reference to `swap'
	/usr/bin/ld: userfaultfd.c:(.text+0x4d82): undefined reference to `swap'
	collect2: error: ld returned 1 exit status

Link: https://lkml.kernel.org/r/20220119101531.2850400-11-usama.anjum@collabora.com
Fixes: 2c769ed7137a ("tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Andr Almeida <andrealmeid@collabora.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Mickal Salan <mic@digikod.net>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-remove-dependecy-from-internal-kernel-macros
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -119,6 +119,9 @@ struct uffd_stats {
 				 ~(unsigned long)(sizeof(unsigned long long) \
 						  -  1)))
 
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-set-the-build-variable-to-absolute-path.patch
selftests-add-and-export-a-kernel-uapi-headers-path.patch
selftests-correct-the-headers-install-path.patch
selftests-futex-add-the-uapi-headers-include-variable.patch
selftests-kvm-add-the-uapi-headers-include-variable.patch
selftests-landlock-add-the-uapi-headers-include-variable.patch
selftests-net-add-the-uapi-headers-include-variable.patch
selftests-mptcp-add-the-uapi-headers-include-variable.patch
selftests-vm-add-the-uapi-headers-include-variable.patch
selftests-vm-remove-dependecy-from-internal-kernel-macros.patch


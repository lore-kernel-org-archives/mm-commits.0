Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E398C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiCYWp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiCYWpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEEE20E979
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59757614D8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14B4C004DD;
        Fri, 25 Mar 2022 22:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248205;
        bh=7GjExLcVHmCUaNl9EMvpWOLh+3RXU+riOCAEZ63oceA=;
        h=Date:To:From:Subject:From;
        b=gLtXAcT+29MDDst1ZCQyigCfbXuI9BOoRyi2m9Hi/qgtD1DLsr4Xiw9CML+/rcyZx
         j9moU5aES6muSPV5qb3eSfqK9jWFy3JyC2Rz8ZzUpcr/OxxAafL5ukCQBT1C6/shDe
         mOPxwJCD+VWrlSf1eVNu4YhMPZks9f166WzxQ5x0=
Date:   Fri, 25 Mar 2022 15:43:25 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, shuah@kernel.org,
        peterz@infradead.org, pbonzini@redhat.com, mingo@redhat.com,
        mic@digikod.net, matthieu.baerts@tessares.net,
        mathew.j.martineau@linux.intel.com, kuba@kernel.org,
        dvhart@infradead.org, dave@stgolabs.net, davem@davemloft.net,
        chi.minghao@zte.com.cn, apopple@nvidia.com,
        andrealmeid@collabora.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-vm-remove-dependecy-from-internal-kernel-macros.patch removed from -mm tree
Message-Id: <20220325224325.B14B4C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: remove dependecy from internal kernel macros
has been removed from the -mm tree.  Its filename was
     selftests-vm-remove-dependecy-from-internal-kernel-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -122,6 +122,9 @@ struct uffd_stats {
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-vm-add-test-for-soft-dirty-pte-bit.patch


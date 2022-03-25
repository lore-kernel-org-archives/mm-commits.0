Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA25AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346842AbiCYBQb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357254AbiCYBQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D032B69729
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C5D2618F6
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C645DC340EC;
        Fri, 25 Mar 2022 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170855;
        bh=7SRsMXupj0RrnQBFbCgm7EaGx8rN51ziwzcte7YuUT0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ZAYOGfQu2ixqs+qEBldHxjQP8l/cWsik8o4grOWLNJq+cZzkZr5WhieacNKcipI8Z
         3gA1jgB5MgZyFBVJl06VKYaLpih3UcCXk9UmYk9GihlJ7903DrWPNGJx88RGF1q2Gu
         D5H50wNW05q8GeGuD63o6Okq/zClfkH0iTQuytWI=
Date:   Thu, 24 Mar 2022 18:14:15 -0700
To:     tglx@linutronix.de, shuah@kernel.org, peterz@infradead.org,
        pbonzini@redhat.com, mingo@redhat.com, mic@digikod.net,
        matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, dvhart@infradead.org, dave@stgolabs.net,
        davem@davemloft.net, chi.minghao@zte.com.cn, apopple@nvidia.com,
        andrealmeid@collabora.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 113/114] selftests: vm: remove dependecy from internal kernel macros
Message-Id: <20220325011415.C645DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

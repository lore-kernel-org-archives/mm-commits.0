Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FB7C63697
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 01:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiAZBtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiAZBtH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 20:49:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48CCC06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 17:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43398615E7
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 01:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2398BC340E0;
        Wed, 26 Jan 2022 01:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643161745;
        bh=dw8+E+F2LE402iKqFfyysjjghysx3UhMY1/jGvEyze0=;
        h=Date:From:To:Subject:From;
        b=Nxmh8lN5uogaBw63SUz7omjs5rAJ0PtexfaNpKn0oOwme1pVBWDkAdODdc3q0W72V
         cUTwkWtTnsMbFfHe9bEZcQsw9keyfzG+Jtn0enw/q4VnBIaxYwtYpTSEqtJfUtjYtB
         KBTTum+8Hggs7UffOX3jbqRRMx03rAjHboiAMk24=
Date:   Tue, 25 Jan 2022 17:49:04 -0800
From:   akpm@linux-foundation.org
To:     andrealmeid@collabora.com, apopple@nvidia.com,
        chi.minghao@zte.com.cn, dave@stgolabs.net, davem@davemloft.net,
        dvhart@infradead.org, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mic@digikod.net, mingo@redhat.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, shuah@kernel.org,
        tglx@linutronix.de, usama.anjum@collabora.com
Subject:  +
 selftests-mptcp-add-the-uapi-headers-include-variable.patch added to -mm
 tree
Message-ID: <20220126014904.CAiLP3lBi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mptcp: add the uapi headers include variable
has been added to the -mm tree.  Its filename is
     selftests-mptcp-add-the-uapi-headers-include-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-mptcp-add-the-uapi-headers-include-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-mptcp-add-the-uapi-headers-include-variable.patch

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
Subject: selftests: mptcp: add the uapi headers include variable

Out of tree build of this test fails if relative path of the output
directory is specified.  Add the KHDR_INCLUDES to correctly reach the
headers.

Link: https://lkml.kernel.org/r/20220119101531.2850400-9-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andr Almeida <andrealmeid@collabora.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Mickal Salan <mic@digikod.net>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/net/mptcp/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/Makefile~selftests-mptcp-add-the-uapi-headers-include-variable
+++ a/tools/testing/selftests/net/mptcp/Makefile
@@ -3,7 +3,7 @@
 top_srcdir = ../../../../..
 KSFT_KHDR_INSTALL := 1
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh
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


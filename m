Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04ABC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD9021707
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486202;
	bh=cczKYMWOYDUkxakBqpC0P5BRovB5e48Fr2UeRac9y+s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oo7JWCcnmCJy3Q2EQ67S9VAstNhGrMIYy7E0kpKlwS258KV+9Vw6WhA2QHDLXAIjk
	 m55jLwBrkXrQApjKdYpzo48I67IhbTxfRS7lUAG5S/c9pyJY6z8scGj83e8CZvbqjo
	 0UmBohYIG3h/9WrWKExlkkMQR26ygNo8foq8CFyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgISDaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgISDaB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:30:01 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102CB21534;
        Sat, 19 Sep 2020 03:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486201;
        bh=cczKYMWOYDUkxakBqpC0P5BRovB5e48Fr2UeRac9y+s=;
        h=Date:From:To:Subject:From;
        b=yg65e6IGX4s27cJQJAoZEMKS97k38yQK5S46z8mUckSG1NZlUQsMI7ABVJJxcsXbE
         96lcM+oXztluMjSx0QoWzt1tInFFoVsqn95v//giotK0VT2de4UxBvWqLxUlj14VIK
         6DnSR6xghkRe6xklaTdRZHikyL7rcns2qEF5ZHAc=
Date:   Fri, 18 Sep 2020 20:30:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, cai@redhat.com
Subject:  +
 arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch added to -mm
 tree
Message-ID: <20200919033000.xvLdK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix
has been added to the -mm tree.  Its filename is
     arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@redhat.com>
Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix

<stdin>:1532:2: warning: #warning syscall memfd_secret not implemented [-Wcpp]

wire up powerpc

Link: https://lkml.kernel.org/r/fdd0240c187f974fccc553acea895f638d5e822a.camel@redhat.com
Cc: Mike Rapoport <rppt@linux.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checksyscalls.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checksyscalls.sh~arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix
+++ a/scripts/checksyscalls.sh
@@ -40,6 +40,10 @@ cat << EOF
 #define __IGNORE_setrlimit	/* setrlimit */
 #endif
 
+#ifndef __ARCH_WANT_MEMFD_SECRET
+#define __IGNORE_memfd_secret
+#endif
+
 /* Missing flags argument */
 #define __IGNORE_renameat	/* renameat2 */
 
_

Patches currently in -mm which might be from cai@redhat.com are

arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch


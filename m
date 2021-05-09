Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7C9C43461
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACFE61421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEIX33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 19:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhEIX32 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 19:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F072B613C2;
        Sun,  9 May 2021 23:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620602904;
        bh=LTXZgXE/w4L+KWsj0trVmaJH2BTGTunG9XJY/yWZ3WY=;
        h=Date:From:To:Subject:From;
        b=0GXkMi+6OYW69SXrwVM818HfkrNLBaFoA4CDwIYbmN76ULNh6lLwRjJJva5Sj+MEa
         6JB7EiH/wUq7tP/1iXEir3ZMro3z3c9srUoDPAYN8oiW6W7UEJIjmGODzECaH6suTu
         m2XBNECEIeIN+531VQePQMyf0uzHBRIKzrb7EG5k=
Date:   Sun, 09 May 2021 16:28:23 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gpiccoli@canonical.com, joe@perches.com,
        keescook@chromium.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, pmladek@suse.com, qais.yousef@arm.com,
        rdunlap@infradead.org, santosh@fossix.org, steve@sk2.org,
        vbabka@suse.cz, wangqing@vivo.com
Subject:  +
 doc-watchdog-modify-the-doc-related-to-watchdog-%u.patch added to -mm tree
Message-ID: <20210509232823.QrZHmhPUu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: watchdog: modify the doc related to "watchdog/%u"
has been added to the -mm tree.  Its filename is
     doc-watchdog-modify-the-doc-related-to-watchdog-%u.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/doc-watchdog-modify-the-doc-r=
elated-to-watchdog-%25u.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/doc-watchdog-modify-the-doc-r=
elated-to-watchdog-%25u.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Wang Qing <wangqing@vivo.com>
Subject: doc: watchdog: modify the doc related to "watchdog/%u"

"watchdog/%u" threads has be replaced by cpu_stop_work.  The current
description is extremely misleading.

Link: https://lkml.kernel.org/r/1619687073-24686-5-git-send-email-wangqing@=
vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Qais Yousef <qais.yousef@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Santosh Sivaraj <santosh@fossix.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~doc-watchdog-modify-the-d=
oc-related-to-watchdog-%u
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -1282,11 +1282,11 @@ This parameter can be used to control th
 =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 The soft lockup detector monitors CPUs for threads that are hogging the CP=
Us
-without rescheduling voluntarily, and thus prevent the 'watchdog/N' threads
-from running. The mechanism depends on the CPUs ability to respond to timer
-interrupts which are needed for the 'watchdog/N' threads to be woken up by
-the watchdog timer function, otherwise the NMI watchdog =E2=80=94 if enabl=
ed =E2=80=94 can
-detect a hard lockup condition.
+without rescheduling voluntarily, and thus prevent the 'migration/N' threa=
ds
+from running, causing the watchdog work fail to execute. The mechanism dep=
ends
+on the CPUs ability to respond to timer interrupts which are needed for the
+watchdog work to be queued by the watchdog timer function, otherwise the N=
MI
+watchdog =E2=80=94 if enabled =E2=80=94 can detect a hard lockup condition.
=20
=20
 stack_erasing
_

Patches currently in -mm which might be from wangqing@vivo.com are

kernel-watchdog-modify-the-explanation-related-to-watchdog-thread.patch
doc-watchdog-modify-the-explanation-related-to-watchdog-thread.patch
doc-watchdog-modify-the-doc-related-to-watchdog-%u.patch


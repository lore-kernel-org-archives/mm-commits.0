Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE09C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4857361D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhF2Cgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Cgw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C33061A1D;
        Tue, 29 Jun 2021 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934064;
        bh=8PcazK9i+Ut9HZBii6YC2k2sGBxQKiXQcKrIg5dMTIQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DOfADohHRHds+PBdDnn+oAhXrkOIJ6UVF5GXHmKNTDqhRWSZ35RC7q4kNEfzi5GwT
         tO+2AacvPmbBws9Zs0Xs+RqAmO/UHTzSCXcj+ZkXQB1OlwO88oPFQxUKEuSl1PWE/e
         6SUSD38dNflt/e35glPXo/PVwhENOI8LTxqBnueM=
Date:   Mon, 28 Jun 2021 19:34:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, gpiccoli@canonical.com,
        joe@perches.com, keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, qais.yousef@arm.com, rdunlap@infradead.org,
        santosh@fossix.org, steve@sk2.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, wangqing@vivo.com
Subject:  [patch 021/192] doc: watchdog: modify the doc related to
 "watchdog/%u"
Message-ID: <20210629023424.hvTBJhiAG%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1283,11 +1283,11 @@ This parameter can be used to control th
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

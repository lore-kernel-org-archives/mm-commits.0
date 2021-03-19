Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33348C433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F037861974
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCSRVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhCSRVM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 305D76197A;
        Fri, 19 Mar 2021 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616174471;
        bh=P8VYCvfI8v9W0YG/inc8i2IuWXzu6YXs4F1VAtxLvn0=;
        h=Date:From:To:Subject:From;
        b=w0gLkgb/bKRghAarc3scZXuMi+yaansF+kyVGw0St3vZ4taY3QfxNw42rYnmOOKWJ
         omC6ihdKGSokcGY5JhgqdVTOEIUVf0O8ZsBYGa4UHOWOLIe1zAqhjBLpqNJABbGKLF
         Uv2TB8HqBKc5tKTdXdma2PoAviUE0BPZBdwTfj6U=
Date:   Fri, 19 Mar 2021 10:21:10 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        wen.gang.wang@oracle.com
Subject:  + ocfs2-map-flags-directly-in-flags_to_o2dlm.patch added
 to -mm tree
Message-ID: <20210319172110.1_TNRQbFk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: map flags directly in flags_to_o2dlm()
has been added to the -mm tree.  Its filename is
     ocfs2-map-flags-directly-in-flags_to_o2dlm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-map-flags-directly-in-f=
lags_to_o2dlm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-map-flags-directly-in-f=
lags_to_o2dlm.patch

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
=46rom: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: map flags directly in flags_to_o2dlm()

Use macro map_flag() is tricky and coccicheck outputs the following
warning:

fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
So map flags directly in flags_to_o2dlm() to make coccicheck=C2=A0happy.
And remove BUG_ON() here as well to simplify code since it runs well
a long time.

Link: https://lkml.kernel.org/r/1616138664-35935-1-git-send-email-joseph.qi=
@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_o2cb.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/stack_o2cb.c~ocfs2-map-flags-directly-in-flags_to_o2dlm
+++ a/fs/ocfs2/stack_o2cb.c
@@ -59,31 +59,31 @@ static inline int mode_to_o2dlm(int mode
 	return mode;
 }
=20
-#define map_flag(_generic, _o2dlm)		\
-	if (flags & (_generic)) {		\
-		flags &=3D ~(_generic);		\
-		o2dlm_flags |=3D (_o2dlm);	\
-	}
 static int flags_to_o2dlm(u32 flags)
 {
 	int o2dlm_flags =3D 0;
=20
-	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
-	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
-	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
-	map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
-	map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
-	map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
-	map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
-	map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
-	map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
-
-	/* map_flag() should have cleared every flag passed in */
-	BUG_ON(flags !=3D 0);
+	if (flags & DLM_LKF_NOQUEUE)
+		o2dlm_flags |=3D LKM_NOQUEUE;
+	if (flags & DLM_LKF_CANCEL)
+		o2dlm_flags |=3D LKM_CANCEL;
+	if (flags & DLM_LKF_CONVERT)
+		o2dlm_flags |=3D LKM_CONVERT;
+	if (flags & DLM_LKF_VALBLK)
+		o2dlm_flags |=3D LKM_VALBLK;
+	if (flags & DLM_LKF_IVVALBLK)
+		o2dlm_flags |=3D LKM_INVVALBLK;
+	if (flags & DLM_LKF_ORPHAN)
+		o2dlm_flags |=3D LKM_ORPHAN;
+	if (flags & DLM_LKF_FORCEUNLOCK)
+		o2dlm_flags |=3D LKM_FORCE;
+	if (flags & DLM_LKF_TIMEOUT)
+		o2dlm_flags |=3D LKM_TIMEOUT;
+	if (flags & DLM_LKF_LOCAL)
+		o2dlm_flags |=3D LKM_LOCAL;
=20
 	return o2dlm_flags;
 }
-#undef map_flag
=20
 /*
  * Map an o2dlm status to standard errno values.
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-map-flags-directly-in-flags_to_o2dlm.patch

